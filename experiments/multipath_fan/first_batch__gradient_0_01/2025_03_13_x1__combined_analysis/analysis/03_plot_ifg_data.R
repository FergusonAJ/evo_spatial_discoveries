rm(list = ls())

library(ggplot2)

df_ifg = read.csv('../data/combined_ifg_data.csv')

ggplot(df_ifg, aes(x = as.factor(node), y = steps)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter() + 
  scale_y_log10() +
  facet_grid(rows = vars(as.factor(structure)), cols=vars(as.factor(gradient)))

ggplot(df_ifg, aes(x = as.factor(node), y = steps)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter() + 
  scale_y_log10() +
  facet_grid(cols = vars(as.factor(structure)), rows=vars(as.factor(gradient)))

ggplot(df_ifg, aes(x = as.factor(node), y = steps)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter() + 
  facet_grid(cols = vars(as.factor(structure)), rows=vars(as.factor(gradient)))
