rm(list = ls())

library(ggplot2)

df_plot = read.csv('../data/processed/matched_discovery_data.csv')

ggplot(df_plot, aes(x = site_offset, y = update_offset)) + 
  geom_point(alpha = 0.01)

ggplot(df_plot, aes(x = abs(site_offset), y = update_offset)) + 
  geom_point(alpha = 0.01)

ggplot(df_plot, aes(x = site_offset)) + 
  geom_histogram(binwidth = 50)

ggplot(df_plot, aes(x = abs(site_offset), y = update_offset)) + 
  geom_vline(xintercept = 500, alpha = 0.5, linetype = 'dashed') + 
  geom_vline(xintercept = 1000, alpha = 0.5) + 
  geom_point(alpha = 0.01)

ggplot(df_plot, aes(x = update_offset)) + 
  geom_vline(xintercept = 1000, alpha = 0.5) + 
  geom_vline(xintercept = 1000 * (7/6), alpha = 0.5, linetype = 'dashed') + 
  geom_vline(xintercept = 500, alpha = 0.5, linetype = 'dashed') + 
  geom_histogram(binwidth = 50)
