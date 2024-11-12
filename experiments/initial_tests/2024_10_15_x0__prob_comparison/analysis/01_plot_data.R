rm(list = ls())

library(ggplot2)

df_plot = read.csv('../data/processed/combined_data.csv')

plot_dir = '../plots'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir)
}

run_scatterplots = T
if(run_scatterplots){
  # All plots at once
  ggplot(df_plot, aes(x = site_offset, y = update_offset)) + 
    geom_point(alpha = 0.01) + 
    facet_wrap(vars(condition_factor))
  ggsave(paste0(plot_dir, '/scatterplots_all.png'), units = 'in', width = 8, height = 6)
  
  # All plots at once, free y axes
  ggplot(df_plot, aes(x = site_offset, y = update_offset)) + 
    geom_point(alpha = 0.01, size = 0.5) + 
    facet_wrap(vars(condition_factor), scales = 'free_y')
  ggsave(paste0(plot_dir, '/scatterplots_all_free_y.png'), units = 'in', width = 8, height = 6)
  
  # Only the adaptive momentum data
  ggplot(df_plot[df_plot$prob == 1,], aes(x = site_offset, y = update_offset)) + 
    geom_point(alpha = 0.01) + 
    annotate('text', x = -750, y = 4000, label = paste0('N = ', sum(df_plot$prob == 1))) +
    facet_wrap(vars(condition_factor))
  ggsave(paste0(plot_dir, '/scatterplots_adaptive_momentum.png'), units = 'in', width = 8, height = 6)
  
  # Only the 33% prob data
  ggplot(df_plot[df_plot$prob == 0.33,], aes(x = site_offset, y = update_offset)) + 
    annotate('text', x = -750, y = 175, label = paste0('N = ', sum(df_plot$prob == 0.33))) +
    facet_wrap(vars(condition_factor))
  ggsave(paste0(plot_dir, '/scatterplots_prob_0_33.png'), units = 'in', width = 8, height = 6)
  
  # Only the 1% prob data
  ggplot(df_plot[df_plot$prob == 0.01,], aes(x = site_offset, y = update_offset)) + 
    geom_point(alpha = 0.01) + 
    annotate('text', x = -750, y = 525, label = paste0('N = ', sum(df_plot$prob == 0.01))) +
    facet_wrap(vars(condition_factor))
  ggsave(paste0(plot_dir, '/scatterplots_prob_0_01.png'), units = 'in', width = 8, height = 6)
  
  # Only the 0.1% prob data
  ggplot(df_plot[df_plot$prob == 0.001,], aes(x = site_offset, y = update_offset)) + 
    geom_point(alpha = 0.01) + 
    annotate('text', x = -750, y = 2400, label = paste0('N = ', sum(df_plot$prob == 0.001))) +
    facet_wrap(vars(condition_factor))
  ggsave(paste0(plot_dir, '/scatterplots_prob_0_001.png'), units = 'in', width = 8, height = 6)
  
  # Only the 0.01% prob data
  ggplot(df_plot[df_plot$prob == 0.0001,], aes(x = site_offset, y = update_offset)) + 
    geom_point(alpha = 0.01) + 
    annotate('text', x = -750, y = 4800, label = paste0('N = ', sum(df_plot$prob == 0.0001))) +
    facet_wrap(vars(condition_factor))
  ggsave(paste0(plot_dir, '/scatterplots_prob_0_0001.png'), units = 'in', width = 8, height = 6)

}

ggplot(df_plot, aes(x = site_offset)) + 
  geom_histogram(binwidth = 40) + 
  facet_wrap(vars(condition_factor), ncol = 1, scales = 'free_y')
ggsave(paste0(plot_dir, '/site_distribution.png'), units = 'in', width = 4, height = 8)

ggplot(df_plot, aes(x = abs(site_offset))) + 
  geom_histogram(binwidth = 20) + 
  facet_wrap(vars(condition_factor), ncol = 1, scales = 'free_y')
ggsave(paste0(plot_dir, '/site_abs_distribution.png'), units = 'in', width = 4, height = 8)

ggplot(df_plot, aes(x = abs(site_offset))) + 
  geom_histogram(binwidth = 20) + 
  facet_wrap(vars(condition_factor), ncol = 1)
ggsave(paste0(plot_dir, '/site_abs_distribution_set_y.png'), units = 'in', width = 4, height = 8)

ggplot(df_plot, aes(x = update_offset)) + 
  geom_histogram(binwidth=50) + 
  facet_wrap(vars(condition_factor), ncol = 1, scales = 'free_y')
ggsave(paste0(plot_dir, '/updates_distribution.png'), units = 'in', width = 4, height = 8)

ggplot(df_plot, aes(x = update_offset)) + 
  geom_histogram(binwidth=50) + 
  facet_wrap(vars(condition_factor), ncol = 1)
ggsave(paste0(plot_dir, '/updates_distribution_set_y.png'), units = 'in', width = 4, height = 8)

ggplot(df_plot, aes(x = site_offset, y = update_offset)) + 
  geom_bin_2d(aes(fill = after_stat(density)), binwidth = c(100, 250)) + 
  facet_wrap(vars(condition_factor))

ggplot(df_plot[df_plot$prob == 0.33,], aes(x = site_offset, y = update_offset)) + 
  geom_bin_2d(binwidth = c(10, 5)) + 
  facet_wrap(vars(condition_factor)) 

ggplot(df_plot[df_plot$prob == 0.33,], aes(x = site_offset, y = update_offset)) + 
  geom_bin_2d(binwidth = c(10, 5)) + 
  facet_wrap(vars(condition_factor))  + 
  scale_fill_continuous(limits = c(100, 600))

ggplot(df_plot[df_plot$prob == 0.001,], aes(x = site_offset, y = update_offset)) + 
  geom_bin_2d(binwidth = c(10, 5)) + 
  facet_wrap(vars(condition_factor))  + 
  scale_fill_continuous(limits = c(10, 60))

ggplot(df_plot[df_plot$prob == 0.01,], aes(x = site_offset, y = update_offset)) + 
  geom_bin_2d(binwidth = c(10, 5)) + 
  facet_wrap(vars(condition_factor))  + 
  scale_fill_continuous(limits = c(10, 200))
