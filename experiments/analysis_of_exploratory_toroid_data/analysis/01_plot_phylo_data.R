rm(list = ls())

library(ggplot2)
library(cowplot)

plot_dir = '../plots/phylo'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir, recursive = T)
}

df_phylo = read.csv('../data/combined_phylo_data.csv')

df_phylo$structure_factor = factor(df_phylo$structure_str, levels = c(
  '60x60', 
  '30x120',
  '15x240',
  '4x900',
  '3x1200',
  '2x1800',
  '1x3600'
))

df_phylo$landscape_factor = factor(df_phylo$landscape, levels = c(
  'Single gradient', 
  'Multipath', 
  'Valley crossing'
))

df_phylo$group = paste0(df_phylo$landscape, df_phylo$structure, df_phylo$rep)

max_gen = 100000
df_final = df_phylo[df_phylo$Generation == max_gen,]

ggplot(df_final, aes(x = structure_factor, y = phylogenetic_diversity)) + 
  geom_boxplot() + 
  geom_jitter() + 
  ylab('Final phylogenetic diversity') + 
  xlab('Spatial structure') + 
  scale_y_continuous(limits = c(0,NA)) +
  facet_grid(vars(landscape_factor))
ggsave(paste0(plot_dir, '/phylo_diversity_final.pdf'), units = 'in', width = 6, height = 5)

ggplot(df_final, aes(x = landscape_factor, y = phylogenetic_diversity)) + 
  geom_boxplot() + 
  geom_jitter() + 
  ylab('Final phylogenetic diversity') + 
  xlab('Spatial structure') + 
  scale_y_continuous(limits = c(0,NA)) +
  facet_grid(vars(structure_factor))
ggsave(paste0(plot_dir, '/phylo_diversity_final__transpose.pdf'), units = 'in', width = 5, height = 12)
  
ggplot(df_final, aes(x = structure_factor, y = mean_pairwise_distance)) + 
  geom_boxplot() + 
  geom_jitter() + 
  ylab('Final mean pairwise distance') + 
  xlab('Spatial structure') + 
  scale_y_continuous(limits = c(0,NA)) +
  facet_grid(vars(landscape_factor))
ggsave(paste0(plot_dir, '/mean_pairwise_dist_final.pdf'), units = 'in', width = 6, height = 5)

ggplot(df_final, aes(x = landscape_factor, y = mean_pairwise_distance)) + 
  geom_boxplot() + 
  geom_jitter() + 
  ylab('Final mean pairwise distance') + 
  xlab('Spatial structure') + 
  scale_y_continuous(limits = c(0,NA)) +
  facet_grid(vars(structure_factor))
ggsave(paste0(plot_dir, '/mean_pairwise_dist_final__transpose.pdf'), units = 'in', width = 5, height = 12)


row_plots = list()

get_row_plot = function(landscape_name, y_axis_var, y_label){
  ggp_over_time = ggplot(df_phylo[df_phylo$landscape == landscape_name,], aes(x = Generation, y = .data[[y_axis_var]], group = group, color = structure_factor)) + 
    geom_line(alpha=0.1) + 
    #ggtitle('Phylogenetic diversity over time') +
    #theme(plot.title.position = 'panel', plot.title = element_text(hjust=0.5))
    ylab(y_label) + 
    xlab('Generation') +
    scale_y_continuous(limits = c(0,NA))
    #theme(axis.text.x = element_text(margin = margin(b = 10)))
  
  ggp_final = ggplot(df_final[df_final$landscape == landscape_name,], aes(x = structure_factor, y = .data[[y_axis_var]], color = structure_factor)) + 
    geom_boxplot() + 
    geom_jitter(alpha = 0.5) + 
    ylab(paste0('Final ', y_label)) +
    xlab('Spatial structure') + 
    labs(color = 'Spatial structure') +
    #ggtitle('Final phylogenetic diversity') +
    #theme(plot.title.position = 'panel', plot.title = element_text(hjust=0.5)) +
    #theme(axis.text.x = element_text(angle=45, hjust = 1, margin = margin(b = 5))) +
    scale_y_continuous(limits = c(0,NA))
  
  ggp_row = cowplot::plot_grid(
    ggp_over_time + theme(legend.position = 'none'), 
    ggp_final + theme(legend.position = 'none'), 
    nrow = 1, align = 'v', axis = 'tb', 
    rel_widths = c(1, 0.5))
  
  return(ggp_row)
}
  
ggp_tmp = ggplot(df_final[df_final$landscape == 'Single gradient',], aes(x = structure_factor, y = mean_pairwise_distance, color = structure_factor)) + 
    geom_boxplot() + 
    labs(color = 'Spatial structure') +
    geom_jitter(alpha = 0.5) 

ggp_legend = get_legend(ggp_tmp + theme(legend.position = 'bottom'))

cowplot::plot_grid(
  get_row_plot('Single gradient', 'phylogenetic_diversity', 'Phylogenetic diversity'),
  get_row_plot('Multipath', 'phylogenetic_diversity', 'Phylogenetic diversity'),
  get_row_plot('Valley crossing', 'phylogenetic_diversity', 'Phylogenetic diversity'),
  ggp_legend, 
  nrow = 4, 
  rel_heights = c(1, 1, 1, 0.1))
ggsave(paste0(plot_dir, '/combined_phylo_diversity.pdf'), units = 'in', width = 10, height = 12)

cowplot::plot_grid(
  get_row_plot('Single gradient', 'mean_pairwise_distance', 'Mean pairwise distance'),
  get_row_plot('Multipath', 'mean_pairwise_distance', 'Mean pairwise distance'),
  get_row_plot('Valley crossing', 'mean_pairwise_distance', 'Mean pairwise distance'),
  ggp_legend, 
  nrow = 4, 
  rel_heights = c(1, 1, 1, 0.1))
ggsave(paste0(plot_dir, '/combined_mean_pairwise_distance.pdf'), units = 'in', width = 10, height = 12)

