rm(list = ls())

library(ggplot2)
library(dplyr)
source("https://gist.githubusercontent.com/benmarwick/2a1bb0133ff568cbe28d/raw/fb53bd97121f7f9ce947837ef1a4c65a73bffb3f/geom_flat_violin.R")
library(khroma)

plot_dir = '../plots/'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir)
}

df_raw = read.csv('../data/processed/combined_discovery_data.csv')

df_raw$structure_str = 'Linear Chain'
df_raw[df_raw$structure == 'cycle',]$structure_str = 'Cycle'
df_raw[df_raw$structure == 'toroidal_lattice',]$structure_str = 'Toroidal Lattice'
df_raw[df_raw$structure == 'star',]$structure_str = 'Star'
df_raw$structure_factor = factor(df_raw$structure_str, levels = c('Linear Chain', 'Cycle', 'Toroidal Lattice', 'Star'))

df_raw$reward_str = paste0('Reward: ', df_raw$reward)
df_raw$reward_factor = factor(df_raw$reward_str, levels = paste0('Reward: ', c(1.1, 2)))

df_raw$fitness_step_str = paste0('Fitness step: ', df_raw$fitness_step)
df_raw$fitness_step_factor = factor(df_raw$fitness_step_str, levels = paste0('Fitness step: ', c(-0.05, -0.01, 0, 0.01, 0.05)))

df_prev = df_raw[!is.na(df_raw$update_prev),]


df_exp_summary = dplyr::group_by(df_raw, structure, reward, fitness_step, structure_factor, reward_factor, fitness_step_factor) %>%
  dplyr::summarize(max_discovery = max(discovery_index))

ggplot(df_exp_summary, aes(x = structure_factor, y = max_discovery, fill = structure_factor)) + 
  geom_col() + 
  facet_grid(rows = vars(reward_factor), cols = vars(fitness_step_factor))
ggsave(paste0(plot_dir, '/max_discovery.png'), units = 'in', width = 8, height = 6.5)



df_trial_summary = dplyr::group_by(df_raw, exp_slug, structure, reward, fitness_step, structure_factor, reward_factor, fitness_step_factor) %>%
  dplyr::summarize(max_discovery = max(discovery_index))

ggplot(df_trial_summary, aes(x = structure_factor, y = max_discovery)) + 
  geom_boxplot() + 
  facet_grid(rows = vars(reward_factor), cols = vars(fitness_step_factor))
ggsave(paste0(plot_dir, '/trial_max_discovery.png'), units = 'in', width = 8, height = 6.5)

ggplot(df_trial_summary[df_trial_summary$structure == 'linear_chain',], aes(x = max_discovery)) + 
  geom_histogram(binwidth=1) + 
  facet_grid(rows = vars(reward_factor), cols = vars(fitness_step_factor))
ggsave(paste0(plot_dir, '/trial_max_discovery__linear_chain.png'), units = 'in', width = 8, height = 6.5)

ggplot(df_trial_summary[df_trial_summary$structure == 'cycle',], aes(x = max_discovery)) + 
  geom_histogram(binwidth=1) + 
  facet_grid(rows = vars(reward_factor), cols = vars(fitness_step_factor))
ggsave(paste0(plot_dir, '/trial_max_discovery__cycle.png'), units = 'in', width = 8, height = 6.5)

ggplot(df_trial_summary[df_trial_summary$structure == 'star',], aes(x = max_discovery)) + 
  geom_histogram(binwidth=1) + 
  facet_grid(rows = vars(reward_factor), cols = vars(fitness_step_factor))
ggsave(paste0(plot_dir, '/trial_max_discovery__star.png'), units = 'in', width = 8, height = 6.5)

ggplot(df_trial_summary[df_trial_summary$structure == 'toroidal_lattice',], aes(x = max_discovery)) + 
  geom_histogram(binwidth=1) + 
  facet_grid(rows = vars(reward_factor), cols = vars(fitness_step_factor))
ggsave(paste0(plot_dir, '/trial_max_discovery__toroidal_lattice.png'), units = 'in', width = 8, height = 6.5)


ggplot(df_raw[!is.na(df_raw$update_offset),], aes(x = structure_factor, y = update_offset, fill = structure_factor)) + 
  geom_boxplot() + 
  facet_grid(rows = vars(reward_factor), cols = vars(fitness_step_factor))
ggsave(paste0(plot_dir, '/update_offset.png'), units = 'in', width = 8, height = 6.5)

ggplot(df_raw[!is.na(df_raw$site_offset),], aes(x = structure_factor, y = site_offset)) + 
  geom_boxplot() + 
  facet_grid(rows = vars(reward_factor), cols = vars(fitness_step_factor))


df_raw$adj_site_offset = df_raw$site_offset

chain_mask = df_raw$structure == 'linear_chain'
df_raw[chain_mask,]$adj_site_offset = abs(df_raw[chain_mask,]$site_offset)

find_cycle_dist = function(x){
  a = as.numeric(x[9])
  b = as.numeric(x[15])
  res_1 = abs(a - b)
  res_2 = abs(a - b - 3600)
  res_3 = abs(a - b + 3600)
  return(min(res_1, res_2, res_3))
}

cycle_mask = df_raw$structure == 'cycle' & !is.na(df_raw$site_offset) 
df_raw[cycle_mask,]$adj_site_offset = apply(df_raw[cycle_mask,], 1, find_cycle_dist)

star_mask = df_raw$structure == 'star' & !is.na(df_raw$site_offset) 
df_raw[star_mask,]$adj_site_offset = 2 
df_raw[star_mask & (df_raw$discovery_site_idx == 0 | df_raw$discovery_site_idx_prev == 0),]$adj_site_offset = 1
df_raw[star_mask & (df_raw$discovery_site_idx == df_raw$discovery_site_idx_prev),]$adj_site_offset = 0

df_raw$grid_row = NA
df_raw$grid_col = NA
df_raw$grid_row_prev = NA
df_raw$grid_col_prev = NA
df_raw$adj_grid_row_prev = NA
df_raw$adj_grid_col_prev = NA
grid_mask = df_raw$structure == 'toroidal_lattice' & !is.na(df_raw$site_offset) 
df_raw[grid_mask,]$grid_row = df_raw[grid_mask,]$discovery_site_idx %% 60
df_raw[grid_mask,]$grid_col = floor(df_raw[grid_mask,]$discovery_site_idx / 60)
df_raw[grid_mask,]$grid_row_prev = df_raw[grid_mask,]$discovery_site_idx_prev %% 60
df_raw[grid_mask,]$grid_col_prev = floor(df_raw[grid_mask,]$discovery_site_idx_prev / 60)
df_raw[grid_mask,]$adj_grid_col_prev = df_raw[grid_mask,]$grid_col_prev
df_raw[grid_mask,]$adj_grid_row_prev = df_raw[grid_mask,]$grid_row_prev

off_left_mask = grid_mask & abs(df_raw$grid_col - (df_raw$grid_col_prev - 60)) < abs(df_raw$grid_col - df_raw$grid_col_prev)
df_raw[off_left_mask,]$adj_grid_col_prev = df_raw[off_left_mask,]$grid_col_prev - 60
off_right_mask = grid_mask & abs(df_raw$grid_col - (df_raw$grid_col_prev + 60)) < abs(df_raw$grid_col - df_raw$grid_col_prev)
df_raw[off_right_mask,]$adj_grid_col_prev = df_raw[off_right_mask,]$grid_col_prev + 60

off_top_mask = grid_mask & abs(df_raw$grid_row - (df_raw$grid_row_prev - 60)) < abs(df_raw$grid_row - df_raw$grid_row_prev)
df_raw[off_top_mask,]$adj_grid_row_prev = df_raw[off_top_mask,]$grid_row_prev - 60
off_bottom_mask = grid_mask & abs(df_raw$grid_row - (df_raw$grid_row_prev + 60)) < abs(df_raw$grid_row - df_raw$grid_row_prev)
df_raw[off_bottom_mask,]$adj_grid_row_prev = df_raw[off_bottom_mask,]$grid_row_prev + 60

df_raw[grid_mask,]$adj_site_offset = abs(df_raw[grid_mask,]$grid_row - df_raw[grid_mask,]$adj_grid_row_prev) + abs(df_raw[grid_mask,]$grid_col - df_raw[grid_mask,]$adj_grid_col_prev)



ggplot(df_raw[grid_mask & df_raw$fitness_step == 0.01 & df_raw$discovery_index >= 11,]) + 
  geom_segment(aes(x = 0, y = 0, xend = 60, yend = 0)) + 
  geom_segment(aes(x = 0, y = 0, xend = 0, yend = 60)) + 
  geom_segment(aes(x = 0, y = 60, xend = 60, yend = 60)) + 
  geom_segment(aes(x = 60, y = 0, xend = 60, yend = 60)) + 
  geom_segment(aes(x = grid_col, y = grid_row, xend = adj_grid_col_prev, yend = adj_grid_row_prev), alpha = 0.2)


ggplot(df_raw[!is.na(df_raw$site_offset),], aes(x = structure_factor, y = adj_site_offset)) + 
  geom_boxplot() + 
  facet_grid(rows = vars(reward_factor), cols = vars(fitness_step_factor))








df_plot = dplyr::group_by(df_prev, rep_id, trial_id, structure, reward, fitness_step, structure_factor, reward_factor, fitness_step_factor, discovery_index, update, update_prev, ) %>%
  dplyr::summarize(
    update = dplyr::first(update), 
    update_prev = dplyr::first(update_prev), 
    update_offset = dplyr::first(update_offset), 
    discovery_site_idx_prev = dplyr::first(discovery_site_idx_prev),
    structure = dplyr::first(structure), 
    reward = dplyr::first(reward), 
    fitness_step = dplyr::first(fitness_step),
    structure_factor = dplyr::first(structure_factor),
    reward_factor = dplyr::first(reward_factor),
    fitness_step_factor = dplyr::first(fitness_step_factor)
    )



ggplot(df_raw[df_raw$structure == 'cycle',], aes(x = discovery_index, y = update_offset)) + 
  geom_point()


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




# Calculate fraction of first-crosses
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


# Glancing at clustering
df_chain = df_raw[df_raw$structure == 'linear_chain' & !is.na(df_raw$update_prev),]
ggplot(df_chain, aes(x = as.factor(fitness_step), y = abs(site_offset), fill = structure_factor)) + 
  geom_hline(yintercept = 1000, linetype='dashed', alpha = 0.5) + 
  geom_flat_violin( position = position_nudge(x = .2, y = 0), alpha = .8 ) +
  geom_point( mapping=aes(color = structure_factor), position = position_jitter(width = .15), size = .5, alpha = 0.1 ) +
  geom_boxplot( width = .1, outlier.shape = NA, alpha = 0.5 ) + 
  facet_grid(cols = vars(structure_factor), rows = vars(reward_factor)) + 
  scale_y_continuous(limits = c(-1,3601)) +
  scale_color_discrete(guide = 'none') + 
  theme(legend.position = 'bottom') +
  xlab('Fitness step (not to scale)') +
  ylab('Site offset') + 
  labs(fill = 'Graph structure') 
ggsave(paste0(plot_dir, '/linear_chain_site_offset.png'), units = 'in', width = 8, height = 6.5)

ggplot(df_chain, aes(x = abs(site_offset), fill = structure_factor)) + 
  geom_histogram(binwidth=36) + 
  facet_grid(cols = vars(fitness_step_factor), rows = vars(reward_factor)) + 
  scale_color_discrete(guide = 'none') + 
  theme(legend.position = 'bottom') +
  xlab('Site offset') +
  ylab('Count') + 
  labs(fill = 'Graph structure') 
ggsave(paste0(plot_dir, '/linear_chain_site_offset_histogram.png'), units = 'in', width = 8, height = 6.5)

ggplot(df_chain[abs(df_chain$site_offset) < 1200,], aes(x = abs(site_offset), fill = structure_factor)) + 
  geom_histogram(binwidth=36) + 
  facet_grid(cols = vars(fitness_step_factor), rows = vars(reward_factor)) + 
  scale_color_discrete(guide = 'none') + 
  theme(legend.position = 'bottom') +
  xlab('Site offset') +
  ylab('Count') + 
  labs(fill = 'Graph structure') 

df_cycle = df_raw[df_raw$structure == 'cycle' & !is.na(df_raw$update_prev),]
df_cycle$site_offset = apply(df_cycle, 1, find_cycle_dist)

ggplot(df_cycle, aes(x = as.factor(fitness_step), y = abs(site_offset), fill = structure_factor)) + 
  geom_hline(yintercept = 1000, linetype='dashed', alpha = 0.5) + 
  geom_flat_violin( position = position_nudge(x = .2, y = 0), alpha = .8 ) +
  geom_point( mapping=aes(color = structure_factor), position = position_jitter(width = .15), size = .5, alpha = 0.1 ) +
  geom_boxplot( width = .1, outlier.shape = NA, alpha = 0.5 ) + 
  facet_grid(cols = vars(structure_factor), rows = vars(reward_factor)) + 
  scale_y_continuous(limits = c(-1,1801)) +
  scale_color_discrete(guide = 'none') + 
  theme(legend.position = 'bottom') +
  xlab('Fitness step (not to scale)') +
  ylab('Site offset') + 
  labs(fill = 'Graph structure') 
ggsave(paste0(plot_dir, '/cycle_site_offset.png'), units = 'in', width = 8, height = 6.5)
