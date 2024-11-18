rm(list = ls())

library(ggplot2)

df_plot = read.csv('../data/processed/combined_discovery_data.csv')

df_plot$x_first = df_plot$discovery_site_idx_first %% 60
df_plot$y_first = floor(df_plot$discovery_site_idx_first / 60)
df_plot$x_last = df_plot$discovery_site_idx_last %% 60
df_plot$y_last = floor(df_plot$discovery_site_idx_last / 60)


toroidal_distance = function(d){
  x1 = d[1]
  y1 = d[2]
  x2 = d[3]
  y2 = d[4]
  shortest_dist = min(
    (y2 - y1)^2 + (x2 - x1)^2,
    (y2 - 60 - y1)^2 + (x2 - x1)^2,
    (y2 - 60 - y1)^2 + (x2 - 60 - x1)^2,
    (y2 - 60 - y1)^2 + (x2 + 60 - x1)^2,
    (y2 - y1)^2 + (x2 - 60 - x1)^2,
    (y2 - y1)^2 + (x2 + 60 - x1)^2,
    (y2 + 60 - y1)^2 + (x2 - x1)^2,
    (y2 + 60 - y1)^2 + (x2 - 60 - x1)^2,
    (y2 + 60 - y1)^2 + (x2 + 60 - x1)^2
  )
  return(sqrt(shortest_dist))
}

closest_x = function(d){
  x1 = d[1]
  y1 = d[2]
  x2 = d[3]
  y2 = d[4]
  cur_dist = abs(x2 - x1)
  if(cur_dist > abs(x2 - 60 - x1)){
    return(x2 - 60)
  }
  if(cur_dist > abs(x2 + 60 - x1)){
    return(x2 + 60)
  }
  return(x2)
}

closest_y = function(d){
  x1 = d[1]
  y1 = d[2]
  x2 = d[3]
  y2 = d[4]
  cur_dist = abs(y2 - y1)
  if(cur_dist > abs(y2 - 60 - y1)){
    return(y2 - 60)
  }
  if(cur_dist > abs(y2 + 60 - y1)){
    return(y2 + 60)
  }
  return(y2)
}

df_plot$distance = apply(df_plot[,c('x_first', 'y_first', 'x_last', 'y_last')], 1, toroidal_distance)
df_plot$adj_x_last = apply(df_plot[,c('x_first', 'y_first', 'x_last', 'y_last')], 1, closest_x)
df_plot$adj_y_last = apply(df_plot[,c('x_first', 'y_first', 'x_last', 'y_last')], 1, closest_y)

ggplot(df_plot, aes(x = distance)) + 
  geom_histogram(binwidth=1) + 
  facet_grid(rows = vars(fitness_step))

