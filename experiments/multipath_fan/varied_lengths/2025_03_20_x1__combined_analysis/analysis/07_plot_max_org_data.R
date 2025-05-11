rm(list = ls())

library(ggplot2)

plot_dir = '../plots/max_org'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir, recursive = T)
}

df_max_org = read.csv('../data/combined_max_org_over_time_data.csv')
df_max_org$gradient_id = df_max_org$dest_node
df_max_org[df_max_org$source_node > df_max_org$dest_node,]$gradient_id = df_max_org[df_max_org$source_node > df_max_org$dest_node,]$source_node
max_gen = 100000
df_final = df_max_org[df_max_org$generation == max_gen,]

ggplot(df_max_org, aes(x = generation, y = fitness, group = rep)) + 
  geom_line(alpha = 0.2) + 
  xlab('Generation') + 
  ylab('Fitness') + 
  facet_wrap(vars(as.factor(structure)))
ggsave(paste0(plot_dir, '/max_fitness_over_time.pdf'), units = 'in', width = 10, height = 8)

ggplot(df_max_org[df_max_org$generation <= 5000,], aes(x = generation, y = fitness, group = rep)) + 
  geom_line(alpha = 0.2) + 
  xlab('Generation') + 
  ylab('Fitness') + 
  facet_wrap(vars(as.factor(structure)))

ggplot(df_final, aes(x = gradient_id)) + 
  geom_density(fill='#0055aa', alpha = 0.2) + 
  xlab('Gradient steepness') + 
  ylab('Density') +
  facet_grid(row = vars(as.factor(structure)))
ggsave(paste0(plot_dir, '/gradient_density.pdf'), units = 'in', width = 6, height = 12)

ggplot(df_final, aes(x = gradient_id)) + 
  geom_density(fill='#0055aa', alpha = 0.2) + 
  xlab('Gradient steepness') + 
  ylab('Density (scale varies per plot)') +
  facet_grid(row = vars(as.factor(structure)), scales = 'free_y') 
ggsave(paste0(plot_dir, '/gradient_density__free_y.pdf'), units = 'in', width = 6, height = 12)


ggplot(df_final, aes(x = gradient_id)) + 
  geom_density(fill='#0055aa', alpha = 0.2) +
  geom_jitter(aes(y = -0.005), width = 0, height = 0.0025, alpha = 0.2) + 
  facet_grid(row = vars(as.factor(structure)), scales = 'free_y') 

ggplot(df_final, aes(x = as.factor(structure), y = gradient_id)) + 
  geom_boxplot(outlier.shape = NA)+ 
  xlab('Spatial structure') + 
  ylab('Gradient steepness')+ 
  scale_y_continuous(limits = c(0,101)) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  geom_jitter(alpha = 0.5)
ggsave(paste0(plot_dir, '/gradient_boxplots.pdf'), units = 'in', width = 8, height = 6)
