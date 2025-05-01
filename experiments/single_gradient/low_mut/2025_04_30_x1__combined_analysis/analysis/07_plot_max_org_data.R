rm(list = ls())

library(ggplot2)

plot_dir = '../plots/max_org'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir, recursive = T)
}

df_max_org = read.csv('../data/combined_max_org_over_time_data.csv')
max_gen = 100000

ggplot(df_max_org, aes(x = generation, y = fitness, group = rep)) + 
  geom_line(alpha = 0.2) + 
  facet_wrap(vars(as.factor(structure))) + 
  xlab('Generation') + 
  ylab('Fitness')
ggsave(paste0(plot_dir, '/max_fitness_over_time.pdf'), units = 'in', width = 8, height = 6)
