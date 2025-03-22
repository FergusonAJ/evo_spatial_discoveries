rm(list = ls())

library(ggplot2)

plot_dir = '../plots/ifg'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir, recursive = T)
}

df_ifg = read.csv('../data/combined_ifg_data.csv')

df_ifg$structure_str = gsub('_', ' ', df_ifg$structure)

ggplot(df_ifg, aes(x = as.factor(node), y = steps)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter() + 
  xlab('Gradient steepness') + 
  ylab('Maximum step reached (max = 1000)') +
  facet_grid(cols = vars(as.factor(structure_str)))
ggsave(paste0(plot_dir, '/ifg_steps_per_gradient.pdf'), units = 'in', width = 12, height = 6)

ggplot(df_ifg, aes(x = as.factor(node), y = steps)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter() + 
  xlab('Gradient steepness') + 
  ylab('Maximum step reached (max = 1000)') +
  facet_grid(cols = vars(as.factor(structure_str))) + 
  scale_y_log10() 
ggsave(paste0(plot_dir, '/ifg_steps_per_gradient_log_y.pdf'), units = 'in', width = 12, height = 6)

ggplot(df_ifg, aes(x = as.factor(structure_str), y = steps)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter() + 
  xlab('Spatial structure') + 
  ylab('Maximum step reached (max = 1000)') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  facet_grid(rows=vars(as.factor(node)))
ggsave(paste0(plot_dir, '/ifg_steps_per_gradient_faceted.pdf'), units = 'in', width = 6, height = 12)

ggplot(df_ifg[df_ifg$node == 5,], aes(x = as.factor(structure_str), y = steps)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter() + 
  xlab('Spatial structure') + 
  ylab('Maximum step reached (max = 1000)') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  facet_grid(rows=vars(as.factor(node)))
ggsave(paste0(plot_dir, '/ifg_steps_gradient_5.pdf'), units = 'in', width = 6, height = 4)

ggplot(df_ifg[df_ifg$node == 4,], aes(x = as.factor(structure_str), y = steps)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter() + 
  xlab('Spatial structure') + 
  ylab('Maximum step reached (max = 1000)') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  facet_grid(rows=vars(as.factor(node)))
ggsave(paste0(plot_dir, '/ifg_steps_gradient_4.pdf'), units = 'in', width = 6, height = 4)
