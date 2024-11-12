rm(list = ls())

library(ggplot2)

df_plot = read.csv('../data/processed/merged_discovery_data.csv')

ggplot(df_plot, aes(x = discovery_site_idx_first)) + 
  geom_histogram(binwidth = 25) + 
  scale_x_continuous(limits = c(0,1000))

ggplot(df_plot, aes(x = discovery_site_idx_last)) + 
  geom_histogram(binwidth = 25) + 
  scale_x_continuous(limits = c(0,1000))

ggplot(df_plot, aes(x = discovery_site_idx_first, y = discovery_site_idx_last)) + 
  geom_abline(slope = 1, intercept = 0, linetype = 'dashed', alpha = 0.5) + 
  geom_point(alpha = 0.25, size = 1)  + 
  scale_x_continuous(limits = c(0,1000)) +
  scale_y_continuous(limits = c(0,1000))

ggplot(df_plot, aes(x = discovery_site_idx_first, y = discovery_site_idx_last)) + 
  geom_bin_2d(binwidth = c(25,25)) + 
  scale_x_continuous(limits = c(0,1000)) +
  scale_y_continuous(limits = c(0,1000))

ggplot(df_plot, aes(x = site_offset, y = update_offset)) + 
  geom_point(alpha = 0.1)

ggplot(df_plot, aes(x = site_offset, y = update_offset)) + 
  geom_bin_2d(binwidth=c(25,125))

ggplot(df_plot, aes(x = abs(site_offset), y = update_offset)) + 
  geom_point(alpha = 0.1)

ggplot(df_plot, aes(x = site_offset)) + 
  geom_histogram(binwidth = 50)

ggplot(df_plot, aes(x = abs(site_offset))) + 
  geom_histogram(binwidth = 50)

