rm(list = ls())

library(ggplot2)

plot_dir = '../plots/ifg'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir, recursive = T)
}

df_ifg = read.csv('../data/combined_ifg_data.csv')

df_ifg$structure_str = gsub('_', ' ', df_ifg$structure)

ggplot(df_ifg[df_ifg$node == 1,], aes(x = as.factor(structure_str), y = steps)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter() + 
  xlab('Maximum step discovered') + 
  ylab('Update discovered') + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  scale_y_continuous(limits = c(0, NA))
ggsave(paste0(plot_dir, '/ifg_steps_discovered.pdf'), units = 'in', width = 6, height = 4)

ggplot(df_ifg[df_ifg$node == 1,], aes(x = as.factor(structure_str), y = update_discovered)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter() + 
  xlab('Spatial structure') + 
  ylab('Update discovered') + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  scale_y_continuous(limits = c(0, 100000))
ggsave(paste0(plot_dir, '/ifg_discovery_time.pdf'), units = 'in', width = 6, height = 4)
