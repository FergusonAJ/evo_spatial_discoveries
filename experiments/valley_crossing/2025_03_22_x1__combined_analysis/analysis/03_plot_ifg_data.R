rm(list = ls())

library(ggplot2)

plot_dir = '../plots/ifg'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir, recursive = T)
}

df_ifg = read.csv('../data/combined_ifg_data.csv')

df_ifg$structure_str = gsub('_', ' ', df_ifg$structure)
df_ifg$is_peak = df_ifg$dest_node %% 5 == 0

df_peaks = df_ifg[df_ifg$is_peak,]
df_peaks$peak_num = round(df_peaks$dest_node / 5)
df_peaks$time_since_last_discovery = NA
for(structure in unique(df_peaks$structure)){
  structure_mask = df_peaks$structure == structure
  for(rep in unique(df_peaks[structure_mask,]$rep)){
    print(structure)
    print(rep)
  }
  
}

ggplot(df_ifg, aes(x = update_discovered, y = dest_node, group = rep)) + 
  geom_line(alpha = 0.1) +
  facet_wrap(vars(as.factor(structure_str)))

ggplot(df_ifg, aes(x = update_discovered, y = dest_node)) + 
  geom_point(alpha = 0.1) + 
  facet_wrap(vars(as.factor(structure_str)))
