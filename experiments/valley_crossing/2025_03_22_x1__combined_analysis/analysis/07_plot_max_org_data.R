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
max_gen = 100000
df_final = df_max_org[df_max_org$generation == max_gen,]

ggplot(df_max_org, aes(x = generation, y = fitness, group = rep)) + 
  geom_line(alpha = 0.2) + 
  xlab('Generation') + 
  ylab('Fitness') + 
  facet_wrap(vars(as.factor(structure)))
ggsave(paste0(plot_dir, '/max_fitness_over_time.pdf'), units = 'in', width = 10, height = 8)

ggplot(df_max_org, aes(x = generation, y = valleys_crossed, group = rep)) + 
  geom_line(alpha = 0.2) + 
  xlab('Generation') + 
  ylab('Valleys crossed') + 
  facet_wrap(vars(as.factor(structure)))
ggsave(paste0(plot_dir, '/valleys_crossed_over_time.pdf'), units = 'in', width = 10, height = 8)

ggplot(df_final, aes(x = valleys_crossed)) + 
  geom_density(fill='#0055aa', alpha = 0.2) + 
  xlab('Valleys crossed') + 
  ylab('Density') +
  facet_grid(row = vars(as.factor(structure)))
ggsave(paste0(plot_dir, '/valleys_crossed_density.pdf'), units = 'in', width = 6, height = 12)

ggplot(df_final, aes(x = valleys_crossed)) + 
  geom_density(fill='#0055aa', alpha = 0.2) + 
  xlab('Valleys crossed') + 
  ylab('Density (scale varies per plot)') +
  facet_grid(row = vars(as.factor(structure)), scales = 'free_y') 
ggsave(paste0(plot_dir, '/valleys_crossed_density__free_y.pdf'), units = 'in', width = 6, height = 12)


ggplot(df_final, aes(x = as.factor(structure), y = valleys_crossed)) + 
  geom_boxplot(outlier.shape = NA)+ 
  xlab('Spatial structure') + 
  ylab('Valleys crossed')+ 
  scale_y_continuous(limits = c(0,101)) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  geom_jitter(alpha = 0.5)
ggsave(paste0(plot_dir, '/valleys_crossed_boxplots.pdf'), units = 'in', width = 8, height = 6)


df_grouped = df_max_org
df_grouped$group = floor((df_grouped$rep - 1) / 5)
df_grouped$rep_in_group = (df_grouped$rep - 1) %% 5
ggplot(df_grouped[df_grouped$structure == 'well_mixed',], aes(x = generation, y = valleys_crossed, color = as.factor(rep_in_group))) + 
  geom_line(alpha = 1) + 
  xlab('Generation') + 
  ylab('Valleys crossed') + 
  theme(legend.position = 'bottom') +
  facet_wrap(vars(as.factor(group)))
