rm(list = ls())

library(ggplot2)
library(dplyr)

df_sweeps = read.csv('../data/combined_sweep_data.csv')
df_grouped = dplyr::group_by(df_sweeps, rep, structure, gradient)
df_summary = dplyr::summarise(df_grouped, count = dplyr::n())


ggplot(df_summary, aes(x = as.factor(structure), y = count)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter()

ggplot(df_sweeps, aes(x = as.factor(structure), y = Generation)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter(alpha = 0.1)


ggplot(df_sweeps, aes(x=sweep_num, y = Generation, group=rep)) + 
  geom_line(alpha = 0.1) + 
  facet_grid(rows = vars(as.factor(structure)))
