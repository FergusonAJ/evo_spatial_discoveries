rm(list = ls())

df = read.csv('phylogenetic_data.csv')
df$prev_mrca_depth = c(-1, df$mrca_depth[1:(nrow(df) - 1)])
df_sweeps = df[df$mrca_depth != df$prev_mrca_depth,]
write.csv(df_sweeps, 'sweeps.csv', row.names=F)

