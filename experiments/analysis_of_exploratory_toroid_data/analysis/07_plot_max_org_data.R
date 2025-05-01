rm(list = ls())

library(ggplot2)
library(cowplot)

plot_dir = '../plots/max_org'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir, recursive = T)
}

df_max_org = read.csv('../data/combined_max_org_data.csv')
df_max_org$valleys_crossed = NA
df_max_org[df_max_org$landscape == 'Valley crossing',]$valleys_crossed = round(log(x = df_max_org[df_max_org$landscape == 'Valley crossing',]$fitness, base = 1.5))
max_gen = 100000

df_max_org$group = paste0(df_max_org$landscape, '_', df_max_org$structure, '_', df_max_org$rep)

df_max_org$structure_factor = factor(df_max_org$structure_str, levels = c(
  '60x60', 
  '30x120',
  '15x240',
  '4x900',
  '3x1200',
  '2x1800',
  '1x3600'
))

df_max_org$landscape_factor = factor(df_max_org$landscape, levels = c(
  'Single gradient', 
  'Multipath', 
  'Valley crossing'
))

df_final = df_max_org[df_max_org$generation == max_gen,]

ggplot(df_max_org, aes(x = generation, y = fitness, group = rep)) + 
  geom_line(alpha = 0.2) + 
  facet_grid(rows = vars(landscape_factor), cols = vars(structure_factor), scales = 'free_y') + 
  xlab('Generation') + 
  ylab('Fitness')
ggsave(paste0(plot_dir, '/max_fitness_over_time.pdf'), units = 'in', width = 8, height = 6)


ggplot(df_max_org[df_max_org$landscape != 'Valley crossing',], aes(x = generation, y = fitness, group = rep)) + 
  geom_line(alpha = 0.2) + 
  facet_grid(rows = vars(landscape_factor), cols = vars(structure_factor)) + 
  xlab('Generation') + 
  ylab('Fitness')

get_row_plot = function(landscape_name, y_axis_var, y_label){
  ggp_over_time = ggplot(df_max_org[df_max_org$landscape == landscape_name,], aes(x = generation, y = .data[[y_axis_var]], group = group, color = structure_factor)) + 
    geom_line(alpha=0.1) + 
    #ggtitle('max_orggenetic diversity over time') +
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
    #ggtitle('Final max_orggenetic diversity') +
    #theme(plot.title.position = 'panel', plot.title = element_text(hjust=0.5)) +
    #theme(axis.text.x = element_text(angle=45, hjust = 1, margin = margin(b = 5))) +
    scale_y_continuous(limits = c(0,NA))
  ggp_final
  
  ggp_legend = get_legend(ggp_final + theme(legend.position = 'bottom'))
  
  ggp_row = cowplot::plot_grid(
    ggp_over_time + theme(legend.position = 'none'), 
    ggp_final + theme(legend.position = 'none'), 
    nrow = 1, align = 'v', axis = 'tb', 
    rel_widths = c(1, 0.5))
  
  return(ggp_row)
}


ggp_tmp = ggplot(df_final[df_final$landscape == 'Single gradient',], aes(x = structure_factor, y = fitness, color = structure_factor)) + 
    geom_boxplot() + 
    geom_jitter(alpha = 0.5) + 
    labs(color = 'Spatial structure')

ggp_legend = get_legend(ggp_tmp + theme(legend.position = 'bottom'))

cowplot::plot_grid(
  get_row_plot('Single gradient', 'fitness', 'Fitness'),
  get_row_plot('Multipath', 'fitness', 'Fitness'),
  get_row_plot('Valley crossing', 'valleys_crossed', 'Valleys crossed'),
  ggp_legend, 
  nrow = 4, 
  rel_heights = c(1, 1, 1, 0.1))
ggsave(paste0(plot_dir, '/combined_max_org_plots.pdf'), units = 'in', width = 10, height = 12)
