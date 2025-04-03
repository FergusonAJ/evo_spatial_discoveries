rm(list = ls())

library(ggplot2)

plot_dir = '../plots/phylo'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir, recursive = T)
}

df_phylo = read.csv('../data/combined_phylo_data.csv')
max_gen = 100000

df_phylo$structure_str = gsub('_', ' ', df_phylo$structure)
df_final = df_phylo[df_phylo$Generation == max_gen,]

ggplot(df_phylo, aes(x = Generation, y = phylogenetic_diversity, group = rep)) + 
  geom_line(alpha=0.1) + 
  ylab('Phylogenetic diversity') + 
  xlab('Generation') +
  facet_wrap(vars(as.factor(structure_str)))
ggsave(paste0(plot_dir, '/phylo_diversity_over_time.pdf'), units = 'in', width = 10, height = 8)

ggplot(df_phylo, aes(x = Generation, y = mean_pairwise_distance, group = rep)) + 
  geom_line(alpha=0.1) + 
  ylab('Mean pairwise distance') + 
  xlab('Generation') +
  facet_wrap(vars(as.factor(structure_str)))
ggsave(paste0(plot_dir, '/mean_pairwise_dist_over_time.pdf'), units = 'in', width = 10, height = 8)

ggplot(df_final, aes(x = as.factor(structure), y = phylogenetic_diversity)) + 
  geom_boxplot() + 
  geom_jitter() + 
  ylab('Final phylogenetic diversity') + 
  xlab('Spatial structure') + 
  theme(axis.text.x = element_text(angle=45, hjust = 1)) + 
  scale_y_continuous(limits = c(0,NA))
ggsave(paste0(plot_dir, '/phylo_diversity_final.pdf'), units = 'in', width = 6, height = 5)
  
ggplot(df_final, aes(x = as.factor(structure), y = mean_pairwise_distance)) + 
  geom_boxplot() + 
  geom_jitter() + 
  ylab('Final mean pairwise distance') + 
  xlab('Spatial structure') + 
  scale_y_continuous(limits = c(0,NA)) +
  theme(axis.text.x = element_text(angle=45, hjust = 1))
ggsave(paste0(plot_dir, '/mean_pairwise_dist_final.pdf'), units = 'in', width = 6, height = 5)
