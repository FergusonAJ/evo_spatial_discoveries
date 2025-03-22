rm(list = ls())

library(ggplot2)

total_trials = 10000

df_mapping = read.csv('../../mapping.csv')
wd = getwd()
wd_parts = strsplit(wd, '/')[[1]]
exp_name = wd_parts[length(wd_parts) - 1]
clique_size = df_mapping[df_mapping$exp_name == exp_name,]$pct_per_clique
chain_size = df_mapping[df_mapping$exp_name == exp_name,]$pct_chain

df_all = read.csv('../data/aggregated_discovery_data.csv')
df_all$clique_size = clique_size
df_all$chain_size = chain_size

df_b = df_all[df_all$node_name %in% c('M1', 'M2'),]

df_1 = df_b[df_b$node_name == 'M1',]
df_2 = df_b[df_b$node_name == 'M2',]

cross_first = length(unique(df_1$trial_seed))
cross_second = length(unique(df_2$trial_seed))

cat('Fraction that crossed at least once: ', cross_first, ' / ', total_trials, ' = ', cross_first / total_trials, '\n')
cat('Fraction that crossed twice: ', cross_second, ' / ', total_trials, ' = ', cross_second / total_trials, '\n')
cat('Fraction of first-crossers that crossed twice:', cross_second, ' / ',cross_first, ' = ', cross_second / cross_first, '\n')

df_merged = merge(df_1, df_2, by = c('rep_id', 'rep_seed', 'trial_id', 'trial_seed'), suffixes = c('_first', '_last'), all=T)
df_merged$site_offset = df_merged$discovery_site_idx_last - df_merged$discovery_site_idx_first
df_merged$update_offset = df_merged$update_last - df_merged$update_first

processed_data_dir = '../data/processed'
if(!dir.exists(processed_data_dir)){
  dir.create(processed_data_dir)
}
write.csv(df_merged, paste0(processed_data_dir, '/merged_discovery_data.csv'), row.names = F)


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
