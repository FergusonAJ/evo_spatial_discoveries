rm(list = ls())

library(ggplot2)
library(dplyr)

plot_dir = '../plots/sweeps'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir, recursive = T)
}

df_sweeps = read.csv('../data/combined_sweep_data.csv')

df_sweeps$structure_factor = factor(df_sweeps$structure_str, levels = c(
  '60x60', 
  '30x120',
  '15x240',
  '4x900',
  '3x1200',
  '2x1800',
  '1x3600'
))

df_sweeps$landscape_factor = factor(df_sweeps$landscape, levels = c(
  'Single gradient', 
  'Multipath', 
  'Valley crossing'
))


df_grouped = dplyr::group_by(df_sweeps, rep, structure, gradient, landscape, landscape_factor, structure_factor)
df_summary = dplyr::summarise(df_grouped, count = dplyr::n())


ggplot(df_summary, aes(x = structure_factor, y = count)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter() +
  xlab('Spatial structure') + 
  ylab('Number of sweeps') + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  facet_grid(rows = vars(landscape_factor))
ggsave(paste0(plot_dir, '/total_sweeps.pdf'), units = 'in', width = 8, height = 6)


#ggplot(df_sweeps, aes(x = as.factor(structure), y = Generation)) + 
#  geom_boxplot(outlier.shape = NA) + 
#  geom_jitter(alpha = 0.1)


ggplot(df_sweeps, aes(x=sweep_num, y = Generation, group=rep)) + 
  geom_point(alpha = 0.1) + 
  facet_grid(rows = vars(as.factor(structure)))

ggplot(df_sweeps, aes(x = Generation, y = sweep_num, group=rep)) + 
  geom_line(alpha = 0.1) + 
  facet_grid(rows = vars(as.factor(structure)))

ggplot(df_sweeps, aes(x = Generation)) + 
  geom_histogram(binwidth = 1000) +
  xlab('Generation sweep occurred') + 
  ylab('Count') + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  facet_grid(rows = vars(landscape_factor), cols = vars(structure_factor))
ggsave(paste0(plot_dir, '/sweep_generation_histograms.pdf'), units = 'in', width = 10, height = 8)
