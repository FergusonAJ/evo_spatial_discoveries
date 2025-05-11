rm(list = ls())

library(ggplot2)
library(dplyr)

plot_dir = '../plots/sweeps'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir, recursive = T)
}

df_sweeps = read.csv('../data/combined_sweep_data.csv')

df_grouped = dplyr::group_by(df_sweeps, rep, structure, gradient)
df_summary = dplyr::summarise(df_grouped, count = dplyr::n())

df_sweeps$structure_str = gsub('_', ' ', df_sweeps$structure)
df_summary$structure_str = gsub('_', ' ', df_summary$structure)


ggplot(df_summary, aes(x = as.factor(structure_str), y = count)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter() +
  xlab('Spatial structure') + 
  ylab('Number of sweeps') + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave(paste0(plot_dir, '/total_sweeps.pdf'), units = 'in', width = 8, height = 6)

ggplot(df_summary[df_summary$structure != 'star' & df_summary$structure != 'wheel',], aes(x = as.factor(structure_str), y = count)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter() +
  xlab('Spatial structure') + 
  ylab('Number of sweeps') + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave(paste0(plot_dir, '/total_sweeps__no_star_or_wheel.pdf'), units = 'in', width = 8, height = 6)


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
  facet_wrap(vars(as.factor(structure_str)))
ggsave(paste0(plot_dir, '/sweep_generation_histograms.pdf'), units = 'in', width = 10, height = 8)
