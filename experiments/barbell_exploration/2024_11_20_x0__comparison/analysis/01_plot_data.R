rm(list = ls())

library(ggplot2)
library(dplyr)
source("https://gist.githubusercontent.com/benmarwick/2a1bb0133ff568cbe28d/raw/fb53bd97121f7f9ce947837ef1a4c65a73bffb3f/geom_flat_violin.R")
library(khroma)

df_raw = read.csv('../data/processed/combined_discovery_data.csv')

df_raw$structure_str = paste0('Barbell (', df_raw$chain_size_first, '% Chain)')
df_raw$structure_factor = factor(df_raw$structure_str, levels = c(
  'Barbell (5% Chain)',
  'Barbell (10% Chain)',
  'Barbell (50% Chain)',
  'Barbell (80% Chain)',
  'Barbell (90% Chain)'
  ))

df_raw$reward_str = paste0('Reward: ', df_raw$reward)
df_raw$reward_factor = factor(df_raw$reward_str, levels = paste0('Reward: ', c(1.1, 2)))

df_raw$fitness_step_str = paste0('Fitness step: ', df_raw$fitness_step)
df_raw$fitness_step_factor = factor(df_raw$fitness_step_str, levels = paste0('Fitness step: ', c(-0.05, -0.01, 0, 0.01, 0.05)))

df_last = df_raw[!is.na(df_raw$update_last),]

df_plot = dplyr::group_by(df_last, rep_id, trial_id, structure, reward, fitness_step, structure_factor, reward_factor, fitness_step_factor) %>%
  dplyr::summarize(
    update_first = dplyr::first(update_first), 
    update_last = dplyr::first(update_last), 
    update_offset = dplyr::first(update_offset), 
    discovery_site_idx_last = dplyr::first(discovery_site_idx_last),
    structure = dplyr::first(structure), 
    reward = dplyr::first(reward), 
    fitness_step = dplyr::first(fitness_step),
    chain_size = dplyr::first(chain_size_first),
    clique_size = dplyr::first(clique_size_first),
    structure_factor = dplyr::first(structure_factor),
    reward_factor = dplyr::first(reward_factor),
    fitness_step_factor = dplyr::first(fitness_step_factor)
    )


plot_dir = '../plots/'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir)
}

ggplot(df_plot[df_plot$reward == 1.1,], aes(x = update_offset)) + 
  geom_histogram(aes(fill = structure_factor), binwidth=25) +
  facet_grid(rows = vars(fitness_step_factor), cols = vars(structure_factor)) + 
  scale_fill_bright() + 
  xlab('Generations between first and second discovery') + 
  ylab('Count') + 
  theme(legend.position = 'none')
ggsave(paste0(plot_dir, '/update_offset_r_1_1.png'), units = 'in', width = 8, height = 6.5)

ggplot(df_plot[df_plot$reward == 2,], aes(x = update_offset)) + 
  geom_histogram(aes(fill = structure_factor), binwidth=25) +
  facet_grid(rows = vars(fitness_step_factor), cols = vars(structure_factor)) + 
  scale_fill_bright() + 
  xlab('Generations between first and second discovery') + 
  ylab('Count') + 
  theme(legend.position = 'none')
ggsave(paste0(plot_dir, '/update_offset_r_2.png'), units = 'in', width = 8, height = 6.5)

df_plot$new_trial_seed = paste0(df_plot$rep_id, '_', df_plot$trial_id)

df_summary = dplyr::group_by(df_plot, structure, reward, fitness_step, structure_factor) %>%
  dplyr::summarize(unique_seeds = n_distinct(new_trial_seed), 
                   reward_factor = dplyr::first(reward_factor), 
                   fitness_step_factor = dplyr::first(fitness_step_factor)
                   )

df_summary$second_discovery_frac = df_summary$unique_seeds / 10^4

ggplot(df_summary, aes(x = structure_factor, y = second_discovery_frac, fill = structure_factor)) + 
  geom_hline(yintercept = 1, linetype = 'dashed', alpha = 0.5) + 
  geom_col(position=position_dodge()) + 
  geom_text(aes(y = second_discovery_frac + 0.05, label = round(second_discovery_frac, 2))) + 
  facet_grid(cols = vars(fitness_step_factor), rows = vars(reward_factor)) + 
  scale_y_continuous(limits = c(0,1.1), breaks = seq(0, 1, 0.25)) +
  scale_fill_bright() + 
  xlab('') + 
  ylab('Fractions of replicates that made two discoveries') + 
  labs(fill = 'Graph structure') + 
  theme(legend.position = 'bottom') +
  theme(axis.text.x = element_blank(), axis.ticks.x =  element_blank())
ggsave(paste0(plot_dir, '/frac_second_discovery.png'), units = 'in', width = 8, height = 6.5)


ggplot(df_plot, aes(x = structure_factor, y = update_first, fill = structure_factor)) + 
  geom_flat_violin( position = position_nudge(x = .2, y = 0), alpha = .8 ) +
  geom_point( mapping=aes(color = structure_factor), position = position_jitter(width = .15), size = .5, alpha = 0.2 ) +
  geom_boxplot( width = .1, outlier.shape = NA, alpha = 0.5 ) + 
  facet_grid(cols = vars(fitness_step_factor), rows = vars(reward_factor)) +
  scale_y_continuous(breaks = c(0, 250, 500, 750, 1000), limits = c(0,1001)) +
  scale_color_discrete(guide = 'none') + 
  theme(legend.position = 'bottom') +
  theme(axis.text.x = element_blank(), axis.ticks.x =  element_blank()) +
  xlab('Graph structure') + 
  ylab('Generation of first discovery') + 
  labs(fill = 'Graph structure') 
ggsave(paste0(plot_dir, '/time_to_first_discovery.png'), units = 'in', width = 8, height = 6.5)

ggplot(df_plot, aes(x = as.factor(fitness_step), y = update_first, fill = structure_factor)) + 
  geom_flat_violin( position = position_nudge(x = .2, y = 0), alpha = .8 ) +
  geom_point( mapping=aes(color = structure_factor), position = position_jitter(width = .15), size = .5, alpha = 0.2 ) +
  geom_boxplot( width = .1, outlier.shape = NA, alpha = 0.5 ) + 
  facet_grid(cols = vars(structure_factor), rows = vars(reward_factor)) + 
  scale_y_continuous(breaks = c(0, 250, 500, 750, 1000), limits = c(0,1001)) +
  scale_color_discrete(guide = 'none') + 
  theme(legend.position = 'bottom') +
  xlab('Fitness step (not to scale)') +
  ylab('Generation of first discovery') + 
  labs(fill = 'Graph structure') 
ggsave(paste0(plot_dir, '/time_to_first_discovery_alt.png'), units = 'in', width = 8, height = 6.5)

ggplot(df_plot, aes(x = fitness_step_factor, y = update_offset, fill = structure_factor)) + 
  geom_flat_violin( position = position_nudge(x = .2, y = 0), alpha = .8 ) +
  geom_point( mapping=aes(color = structure_factor), position = position_jitter(width = .15), size = .5, alpha = 0.8 ) +
  geom_boxplot( width = .1, outlier.shape = NA, alpha = 0.5 ) + 
  facet_grid(cols = vars(structure_factor), rows = vars(reward_factor))

ggplot(df_plot, aes(x = structure_factor, y = update_offset, fill = structure_factor)) + 
  geom_flat_violin( position = position_nudge(x = .2, y = 0), alpha = .8 ) +
  geom_point( mapping=aes(color = structure_factor), position = position_jitter(width = .15), size = .5, alpha = 0.2 ) +
  geom_boxplot( width = .1, outlier.shape = NA, alpha = 0.5 ) + 
  facet_grid(cols = vars(fitness_step_factor), rows = vars(reward_factor)) +
  scale_y_continuous(breaks = c(0, 250, 500, 750, 1000), limits = c(0,1001)) +
  scale_color_discrete(guide = 'none') + 
  theme(legend.position = 'bottom') +
  theme(axis.text.x = element_blank(), axis.ticks.x =  element_blank()) +
  xlab('Graph structure') + 
  ylab('Generations between discoveries') + 
  labs(fill = 'Graph structure') 
ggsave(paste0(plot_dir, '/update_offset_raincloud.png'), units = 'in', width = 8, height = 6.5)

ggplot(df_plot, aes(x = as.factor(fitness_step), y = update_offset, fill = structure_factor)) + 
  geom_flat_violin( position = position_nudge(x = .2, y = 0), alpha = .8 ) +
  geom_point( mapping=aes(color = structure_factor), position = position_jitter(width = .15), size = .5, alpha = 0.2 ) +
  geom_boxplot( width = .1, outlier.shape = NA, alpha = 0.5 ) + 
  facet_grid(cols = vars(structure_factor), rows = vars(reward_factor)) + 
  scale_y_continuous(breaks = c(0, 250, 500, 750, 1000), limits = c(0,1001)) +
  scale_color_discrete(guide = 'none') + 
  theme(legend.position = 'bottom') +
  xlab('Fitness step (not to scale)') +
  ylab('Generations between discoveries') + 
  labs(fill = 'Graph structure') 
ggsave(paste0(plot_dir, '/update_offset_alt_raincloud.png'), units = 'in', width = 8, height = 6.5)




#### Calculate fraction of first-crosses
df_raw$new_trial_seed = paste0(df_raw$rep_id, '_', df_raw$trial_id)

df_summary_2 = dplyr::group_by(df_raw, structure, reward, fitness_step, structure_factor) %>%
  dplyr::summarize(unique_seeds = n_distinct(new_trial_seed), 
                   reward_factor = dplyr::first(reward_factor), 
                   fitness_step_factor = dplyr::first(fitness_step_factor)
                   )

df_summary_2$first_discovery_frac = df_summary_2$unique_seeds / 10^4

ggplot(df_summary_2, aes(x = structure_factor, y = first_discovery_frac, fill = structure_factor)) + 
  geom_hline(yintercept = 1, linetype = 'dashed', alpha = 0.5) + 
  geom_col(position=position_dodge()) + 
  geom_text(aes(y = first_discovery_frac + 0.05, label = round(first_discovery_frac, 2))) + 
  facet_grid(cols = vars(fitness_step_factor), rows = vars(reward_factor)) + 
  scale_y_continuous(limits = c(0,1.1), breaks = seq(0, 1, 0.25)) +
  scale_fill_bright() + 
  xlab('') + 
  ylab('Fractions of replicates that made the first discovery') + 
  labs(fill = 'Graph structure') + 
  theme(legend.position = 'bottom') +
  theme(axis.text.x = element_blank(), axis.ticks.x =  element_blank())
ggsave(paste0(plot_dir, '/frac_first_discovery.png'), units = 'in', width = 8, height = 6.5)

# Look at frraction of first-crossers that crossed again
df_combined_summary = merge(df_summary, df_summary_2, by = c('fitness_step_factor', 'reward_factor', 'structure_factor'))
df_combined_summary$extra_frac = df_combined_summary$second_discovery_frac / df_combined_summary$first_discovery_frac
ggplot(df_combined_summary, aes(x = structure_factor, y = extra_frac, fill = structure_factor)) + 
  geom_hline(yintercept = 1, linetype = 'dashed', alpha = 0.5) + 
  geom_col(position=position_dodge()) + 
  geom_text(aes(y = extra_frac + 0.05, label = round(extra_frac, 2))) + 
  facet_grid(cols = vars(fitness_step_factor), rows = vars(reward_factor)) + 
  scale_y_continuous(limits = c(0,1.1), breaks = seq(0, 1, 0.25)) +
  scale_fill_bright() + 
  xlab('') + 
  ylab('Fraction of first-crossers that also made the second discovery') + 
  labs(fill = 'Graph structure') + 
  theme(legend.position = 'bottom') +
  theme(axis.text.x = element_blank(), axis.ticks.x =  element_blank())
ggsave(paste0(plot_dir, '/frac_alt.png'), units = 'in', width = 8, height = 6.5)



#### Glancing at clustering

df_plot$left_clique_cutoff = df_plot$clique_size / 100 * 3600
df_plot$right_clique_cutoff = 3600 - df_plot$left_clique_cutoff
df_plot$chain_pct = paste0(df_plot$chain_size, '% Chain')
df_plot$chain_factor = factor(df_plot$chain_pct, levels = c('5% Chain', '10% Chain', '50% Chain', '80% Chain', '90% Chain'))

ggplot(df_plot[df_plot$reward == 1.1,], aes(x = discovery_site_idx_last, fill = chain_factor)) + 
  geom_vline(aes(xintercept = left_clique_cutoff), linetype = 'dashed', alpha = 0.5) + 
  geom_vline(aes(xintercept = right_clique_cutoff), linetype = 'dashed', alpha = 0.5) + 
  geom_histogram(binwidth=36) + 
  scale_fill_bright() + 
  scale_y_continuous(expand = c(0,0)) + 
  labs(fill = 'Graph structure') + 
  theme(axis.text.x = element_blank(), axis.ticks.x =  element_blank()) + 
  xlab('Site of second discovery') + 
  ylab('Count') + 
  theme(legend.position = 'bottom') + 
  facet_grid(cols = vars(fitness_step_factor), rows = vars(chain_factor)) 
ggsave(paste0(plot_dir, '/second_discovery_sites_reward_1_1.png'), units = 'in', width = 8, height = 6.5)

ggplot(df_plot[df_plot$reward == 2,], aes(x = discovery_site_idx_last, fill = chain_factor)) + 
  geom_vline(aes(xintercept = left_clique_cutoff), linetype = 'dashed', alpha = 0.5) + 
  geom_vline(aes(xintercept = right_clique_cutoff), linetype = 'dashed', alpha = 0.5) + 
  geom_histogram(binwidth=36) + 
  scale_fill_bright() + 
  scale_y_continuous(expand = c(0,0)) + 
  labs(fill = 'Graph structure') + 
  theme(axis.text.x = element_blank(), axis.ticks.x =  element_blank()) + 
  xlab('Site of second discovery') + 
  ylab('Count') + 
  theme(legend.position = 'bottom') + 
  facet_grid(cols = vars(fitness_step_factor), rows = vars(chain_factor)) 
ggsave(paste0(plot_dir, '/second_discovery_sites_reward_2.png'), units = 'in', width = 8, height = 6.5)

df_plot$is_clique = df_plot$discovery_site_idx_last <= df_plot$left_clique_cutoff | df_plot$discovery_site_idx_last >= df_plot$right_clique_cutoff

df_clique_summary_second = dplyr::group_by(df_plot, is_clique, structure_factor, chain_factor, reward_factor, fitness_step_factor) %>%
  dplyr::summarize(count = dplyr::n())

ggplot(df_clique_summary_second, aes(x = fitness_step_factor, y = count, fill = is_clique)) + 
  geom_col(position = position_dodge2()) + 
  facet_grid(rows = vars(reward_factor), cols = vars(chain_factor))

ggplot(df_clique_summary_second, aes(x = chain_factor, y = count, fill = is_clique)) + 
  geom_col(position = position_dodge2()) + 
  facet_grid(rows = vars(reward_factor), cols = vars(fitness_step_factor))

df_clique_summary_second$opposite = 0
for(row_idx in 1:nrow(df_clique_summary_second)){
  chain = df_clique_summary_second[row_idx,]$chain_factor
  reward = df_clique_summary_second[row_idx,]$reward_factor
  fitness_step = df_clique_summary_second[row_idx,]$fitness_step_factor
  is_clique = df_clique_summary_second[row_idx,]$is_clique
  opposite_row = df_clique_summary_second[
      df_clique_summary_second$reward_factor == reward & 
      df_clique_summary_second$fitness_step_factor == fitness_step & 
      df_clique_summary_second$chain_factor == chain & 
      df_clique_summary_second$is_clique == !is_clique,]
  if(nrow(opposite_row) > 0){
    df_clique_summary_second[row_idx,]$opposite = opposite_row$count
  }
}
df_clique_summary_second$frac = df_clique_summary_second$count / (df_clique_summary_second$count + df_clique_summary_second$opposite)


ggplot(df_clique_summary_second[df_clique_summary_second$is_clique,], aes(x = fitness_step_factor, y = frac, fill = chain_factor)) + 
  geom_col(position = position_dodge()) + 
  facet_grid(rows = vars(reward_factor), cols = vars(chain_factor))

ggplot(df_clique_summary_second[df_clique_summary_second$is_clique,], aes(x = chain_factor, y = frac, fill = chain_factor)) + 
  geom_col(position = position_dodge()) + 
  facet_grid(rows = vars(reward_factor), cols = vars(fitness_step_factor))

ggplot(df_clique_summary_second[df_clique_summary_second$is_clique,], aes(x = reward_factor, y = frac, fill = chain_factor)) + 
  geom_col(position = position_dodge()) + 
  facet_grid(rows = vars(fitness_step_factor), cols = vars(chain_factor))

df_raw$left_clique_cutoff = df_raw$clique_size_first / 100 * 3600
df_raw$right_clique_cutoff = 3600 - df_raw$left_clique_cutoff
df_raw$chain_pct = paste0(df_raw$chain_size_first, '% Chain')
df_raw$chain_factor = factor(df_raw$chain_pct, levels = c('5% Chain', '10% Chain', '50% Chain', '80% Chain', '90% Chain'))
  
ggplot(df_raw[df_plot$reward == 1.1,], aes(x = discovery_site_idx_first, fill = chain_factor)) + 
  geom_vline(aes(xintercept = left_clique_cutoff), linetype = 'dashed', alpha = 0.5) + 
  geom_vline(aes(xintercept = right_clique_cutoff), linetype = 'dashed', alpha = 0.5) + 
  geom_histogram(binwidth=36) + 
  scale_fill_bright() + 
  scale_y_continuous(expand = c(0,0)) + 
  labs(fill = 'Graph structure') + 
  theme(axis.text.x = element_blank(), axis.ticks.x =  element_blank()) + 
  xlab('Site of first discovery') + 
  ylab('Count') + 
  theme(legend.position = 'bottom') + 
  facet_grid(cols = vars(fitness_step_factor), rows = vars(chain_factor)) 
ggsave(paste0(plot_dir, '/first_discovery_sites_reward_1_1.png'), units = 'in', width = 8, height = 6.5)


ggplot(df_raw[df_plot$reward == 2,], aes(x = discovery_site_idx_first, fill = chain_factor)) + 
  geom_vline(aes(xintercept = left_clique_cutoff), linetype = 'dashed', alpha = 0.5) + 
  geom_vline(aes(xintercept = right_clique_cutoff), linetype = 'dashed', alpha = 0.5) + 
  geom_histogram(binwidth=36) + 
  scale_fill_bright() + 
  scale_y_continuous(expand = c(0,0)) + 
  labs(fill = 'Graph structure') + 
  theme(axis.text.x = element_blank(), axis.ticks.x =  element_blank()) + 
  xlab('Site of first discovery') + 
  ylab('Count') + 
  theme(legend.position = 'bottom') + 
  facet_grid(cols = vars(fitness_step_factor), rows = vars(chain_factor)) 
ggsave(paste0(plot_dir, '/first_discovery_sites_reward_2.png'), units = 'in', width = 8, height = 6.5)


df_raw$is_clique = df_raw$discovery_site_idx_first <= df_raw$left_clique_cutoff | df_raw$discovery_site_idx_first >= df_raw$right_clique_cutoff

df_clique_summary = dplyr::group_by(df_raw, is_clique, structure_factor, chain_factor, reward_factor, fitness_step_factor) %>%
  dplyr::summarize(count = dplyr::n())

ggplot(df_clique_summary, aes(x = fitness_step_factor, y = count, fill = is_clique)) + 
  geom_col(position = position_dodge()) + 
  facet_grid(rows = vars(reward_factor), cols = vars(chain_factor))

df_clique_summary$opposite = 0
for(row_idx in 1:nrow(df_clique_summary)){
  chain = df_clique_summary[row_idx,]$chain_factor
  reward = df_clique_summary[row_idx,]$reward_factor
  fitness_step = df_clique_summary[row_idx,]$fitness_step_factor
  is_clique = df_clique_summary[row_idx,]$is_clique
  df_clique_summary[row_idx,]$opposite = df_clique_summary[
      df_clique_summary$reward_factor == reward & 
      df_clique_summary$fitness_step_factor == fitness_step & 
      df_clique_summary$chain_factor == chain & 
      df_clique_summary$is_clique == !is_clique,]$count
}
df_clique_summary$frac = df_clique_summary$count / (df_clique_summary$count + df_clique_summary$opposite)


ggplot(df_clique_summary[df_clique_summary$is_clique,], aes(x = fitness_step_factor, y = frac, fill = chain_factor)) + 
  geom_col(position = position_dodge()) + 
  facet_grid(rows = vars(reward_factor), cols = vars(chain_factor))

ggplot(df_clique_summary[df_clique_summary$is_clique,], aes(x = reward_factor, y = frac, fill = chain_factor)) + 
  geom_col(position = position_dodge()) + 
  facet_grid(rows = vars(fitness_step_factor), cols = vars(chain_factor))
