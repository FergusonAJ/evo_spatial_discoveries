rm(list = ls())

library(ggplot2)

df_phylo = read.csv('../data/combined_phylo_data.csv')
max_gen = 100000
df_final = df_phylo[df_phylo$Generation == max_gen,]

ggplot(df_phylo, aes(x = Generation, y = phylogenetic_diversity, group = rep)) + 
  geom_line(alpha=0.1) + 
  facet_grid(rows=vars(as.factor(structure)), cols = vars(as.factor(gradient)))

ggplot(df_phylo, aes(x = Generation, y = mean_pairwise_distance, group = rep)) + 
  geom_line(alpha=0.1) + 
  facet_grid(rows=vars(as.factor(structure)), cols = vars(as.factor(gradient)))

ggplot(df_final, aes(x = as.factor(structure), y = phylogenetic_diversity)) + 
  geom_boxplot() + 
  geom_jitter() + 
  facet_grid(cols = vars(as.factor(gradient)))
  

ggplot(df_final, aes(x = as.factor(structure), y = mean_pairwise_distance)) + 
  geom_boxplot() + 
  geom_jitter() +
  facet_grid(cols = vars(as.factor(gradient)))
