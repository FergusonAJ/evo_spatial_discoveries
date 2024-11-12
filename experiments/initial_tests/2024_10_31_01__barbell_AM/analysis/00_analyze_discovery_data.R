rm(list = ls())

library(ggplot2)

total_trials = 100000

df_all = read.csv('../data/aggregated_discovery_data.csv')
df_all[df_all$node_name == 'D1',]$node_name = 'M1'
df_all[df_all$node_name == 'D2',]$node_name = 'M2'

df_b = df_all[df_all$node_name %in% c('M1', 'M2'),]

df_1 = df_b[df_b$node_name == 'M1',]
df_2 = df_b[df_b$node_name == 'M2',]

cat('Fraction that crossed at least once: ', nrow(df_1), ' / ', total_trials, ' = ', nrow(df_1) / total_trials, '\n')
cat('Fraction that crossed twice: ', nrow(df_2), ' / ', total_trials, ' = ', nrow(df_2) / total_trials, '\n')
cat('Fraction of first-crossers that crossed twice:', nrow(df_2), ' / ', nrow(df_1), ' = ', nrow(df_2) / nrow(df_1), '\n')

df_merged = merge(df_1, df_2, by = c('rep_id', 'rep_seed', 'trial_id', 'trial_seed'), suffixes = c('_first', '_last'))
df_merged$site_offset = df_merged$discovery_site_idx_last - df_merged$discovery_site_idx_first
df_merged$update_offset = df_merged$update_last - df_merged$update_first

processed_data_dir = '../data/processed'
if(!dir.exists(processed_data_dir)){
  dir.create(processed_data_dir)
}
write.csv(df_merged, paste0(processed_data_dir, '/merged_discovery_data.csv'))


#df_2$first_cross_site = NA
#df_2$first_cross_update = NA
#for (trial_seed in df_2$trial_seed){
#  first_cross = df_1[df_1$trial_seed == trial_seed,]
#  second_cross_site = df_2[df_2$trial_seed == trial_seed,]$discovery_site_idx
#  first_cross$site_diff = abs(first_cross$discovery_site_idx - second_cross_site)
#  first_cross = first_cross[first_cross$site_diff = min(first_cross$site_diff),]
#  df_2[df_2$trial_seed == trial_seed,c('first_cross_site', 'first_cross_update')] = first_cross[1,c('discovery_site_idx', 'update')]
#}
#
#df_2$site_offset = df_2$discovery_site_idx - df_2$first_cross_site
#df_2$update_offset = df_2$update - df_2$first_cross_update

#processed_data_dir = '../data/processed'
#if(!dir.exists(processed_data_dir)){
#  dir.create(processed_data_dir)
#}
#write.csv(df_2, paste0(processed_data_dir, '/matched_discovery_data.csv'))