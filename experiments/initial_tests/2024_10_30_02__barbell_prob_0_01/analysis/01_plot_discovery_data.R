rm(list = ls())

library(ggplot2)

df_plot = read.csv('../data/processed/merged_discovery_data.csv')

ggplot(df_plot, aes(x = discovery_site_idx_first)) + 
  geom_histogram(binwidth = 5)

ggplot(df_plot, aes(x = discovery_site_idx_last)) + 
  geom_histogram(binwidth = 5)

ggplot(df_plot, aes(x = discovery_site_idx_first, y = discovery_site_idx_last)) + 
  geom_point(alpha = 0.01, size = 1)

ggplot(df_plot, aes(x = discovery_site_idx_first, y = site_offset)) + 
  geom_point(alpha = 0.01, size = 1)

ggplot(df_plot, aes(x = discovery_site_idx, y = first_cross_site)) + 
  geom_bin_2d(binwidth = c(25,25))

ggplot(df_plot, aes(x = site_offset, y = update_offset)) + 
  geom_point(alpha = 0.01)

ggplot(df_plot, aes(x = site_offset, y = update_offset)) + 
  geom_bin_2d(binwidth=c(20,20))

ggplot(df_plot, aes(x = abs(site_offset), y = update_offset)) + 
  geom_point(alpha = 0.01)

ggplot(df_plot, aes(x = site_offset)) + 
  geom_histogram(binwidth = 50)
