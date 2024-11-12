rm(list = ls())

total_trials = 100000

df_all = read.csv('../data/aggregated_discovery_data.csv')

df_b = df_all[df_all$node_name %in% c('B1', 'B2'),]

df_1 = df_b[df_b$node_name == 'B1',]
df_2 = df_b[df_b$node_name == 'B2',]

cat('Fraction that crossed at least once: ', nrow(df_1), ' / ', total_trials, ' = ', nrow(df_1) / total_trials)
cat('Fraction that crossed twice: ', nrow(df_2), ' / ', total_trials, ' = ', nrow(df_2) / total_trials)
cat('Fraction of first-crossers that crossed twice:', nrow(df_2), ' / ', nrow(df_1), ' = ', nrow(df_2) / nrow(df_1))


df_2$first_cross_site = NA
df_2$first_cross_update = NA
for (trial_seed in df_2$trial_seed){
  first_cross = df_1[df_1$trial_seed == trial_seed,]
  df_2[df_2$trial_seed == trial_seed,c('first_cross_site', 'first_cross_update')] = first_cross[1,c('discovery_site_idx', 'update')]
}

processed_data_dir = '../data/processed'
if(!dir.exists(processed_data_dir)){
  dir.create(processed_data_dir)
}


df_2$site_offset = df_2$discovery_site_idx - df_2$first_cross_site
df_2$update_offset = df_2$update - df_2$first_cross_update

write.csv(df_2, paste0(processed_data_dir, '/matched_discovery_data.csv'))

