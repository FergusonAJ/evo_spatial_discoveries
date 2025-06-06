rm(list = ls())

library(ggplot2)

plot_dir = '../plots/max_org'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir, recursive = T)
}

df_max_org = read.csv('../data/combined_max_org_over_time_data.csv')
df_max_org$gradient_id = df_max_org$dest_node
df_max_org$valleys_crossed = round(log(x = df_max_org$fitness, base = 1.5))
df_max_org[df_max_org$source_node > df_max_org$dest_node,]$gradient_id = df_max_org[df_max_org$source_node > df_max_org$dest_node,]$source_node
df_max_org$structure_str = gsub('_', 'x', df_max_org$structure)
df_max_org$structure_factor = factor(df_max_org$structure_str, levels = c(
  '60x60',
  '30x120',
  '15x240',
  '4x900',
  '3x1200',
  '2x1800',
  '1x3600'
))

max_gen = 100000
df_final = df_max_org[df_max_org$generation == max_gen,]

ggplot(df_max_org, aes(x = generation, y = fitness, group = rep)) + 
  geom_line(alpha = 0.2) + 
  xlab('Generation') + 
  ylab('Fitness') + 
  facet_wrap(vars(structure_factor))
ggsave(paste0(plot_dir, '/max_fitness_over_time.pdf'), units = 'in', width = 10, height = 8)

ggplot(df_max_org, aes(x = generation, y = valleys_crossed, group = rep)) + 
  geom_line(alpha = 0.2) + 
  xlab('Generation') + 
  ylab('Valleys crossed') + 
  facet_wrap(vars(structure_factor))
ggsave(paste0(plot_dir, '/valleys_crossed_over_time.pdf'), units = 'in', width = 10, height = 8)

ggplot(df_final, aes(x = valleys_crossed)) + 
  geom_density(fill='#0055aa', alpha = 0.2) + 
  xlab('Valleys crossed') + 
  ylab('Density') +
  facet_grid(row = vars(structure_factor))
ggsave(paste0(plot_dir, '/valleys_crossed_density.pdf'), units = 'in', width = 6, height = 12)

ggplot(df_final, aes(x = valleys_crossed)) + 
  geom_density(fill='#0055aa', alpha = 0.2) + 
  xlab('Valleys crossed') + 
  ylab('Density (scale varies per plot)') +
  facet_grid(row = vars(structure_factor), scales = 'free_y') 
ggsave(paste0(plot_dir, '/valleys_crossed_density__free_y.pdf'), units = 'in', width = 6, height = 12)


ggplot(df_final, aes(x = structure_factor, y = valleys_crossed)) + 
  geom_boxplot(outlier.shape = NA)+ 
  xlab('Spatial structure') + 
  ylab('Valleys crossed')+ 
  scale_y_continuous(limits = c(0,101)) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  geom_jitter(alpha = 0.5)
ggsave(paste0(plot_dir, '/valleys_crossed_boxplots.pdf'), units = 'in', width = 8, height = 6)

df_summary = df_max_org[df_max_org$valleys_crossed == 100,] %>% 
  dplyr::group_by(structure, structure_factor, rep) %>% 
  dplyr::summarize(generation_reached = min(generation))

df_summary_summary = df_summary %>%
  dplyr::group_by(structure_factor, structure) %>%
  dplyr::summarise(count = dplyr::n())


ggplot(df_summary, aes(x = structure_factor, y = generation_reached)) + 
  geom_boxplot(outlier.shape = NA)+ 
  xlab('Spatial structure') + 
  ylab('Generations to cross 100 valleys')+ 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  geom_jitter(alpha = 0.5)
ggsave(paste0(plot_dir, '/gens_to_100_valleys__zoomed.pdf'), units = 'in', width = 8, height = 6)

ggplot(df_summary, aes(x = structure_factor, y = generation_reached)) + 
  geom_boxplot(outlier.shape = NA)+ 
  geom_jitter(alpha = 0.5) + 
  geom_text(data = df_summary_summary, aes(y = 5000, label = paste0('N = ', count))) +
  xlab('Spatial structure') + 
  ylab('Generations to cross 100 valleys')+ 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(limits = c(0, 102000), breaks=seq(0,100000,25000))
ggsave(paste0(plot_dir, '/gens_to_100_valleys.pdf'), units = 'in', width = 8, height = 6)
