rm(list = ls())

library(ggplot2)

total_trials = 10000

df_all = read.csv('../data/aggregated_discovery_data.csv')

df_discoveries = df_all[grepl('M', df_all$node_name),]
df_prev_discoveries = df_discoveries
df_discoveries$discovery_index = as.numeric(substr(df_discoveries$node_name, 2, 10))
df_discoveries$discovery_link = df_discoveries$discovery_index - 1
df_discoveries[df_discoveries$discovery_index == 1,]$discovery_link = NA
df_prev_discoveries$discovery_index = as.numeric(substr(df_prev_discoveries$node_name, 2, 10))
df_prev_discoveries$discovery_link = df_prev_discoveries$discovery_index
df_merged = merge(df_discoveries, df_prev_discoveries, by = c('rep_id', 'rep_seed', 'trial_id', 'trial_seed', 'discovery_link'), suffixes = c('', '_prev'), all=F, all.x = T)
df_merged$exp_slug = paste0(df_merged$rep_id, '_', df_merged$trial_id)

cross_first = length(unique(df_merged[df_merged$node_name == 'M1',]$exp_slug))
cross_second = length(unique(df_merged[df_merged$node_name == 'M2',]$exp_slug))
cat('Fraction that crossed at least once: ', cross_first, ' / ', total_trials, ' = ', cross_first / total_trials, '\n')
cat('Fraction that crossed twice: ', cross_second, ' / ', total_trials, ' = ', cross_second / total_trials, '\n')
cat('Fraction of first-crossers that crossed twice:', cross_second, ' / ',cross_first, ' = ', cross_second / cross_first, '\n')

df_merged$site_offset = df_merged$discovery_site_idx - df_merged$discovery_site_idx_prev
df_merged$update_offset = df_merged$update - df_merged$update_prev
df_merged[is.na(df_merged$update_prev),]$site_offset = NA
df_merged[is.na(df_merged$update_prev),]$update_offset = NA

processed_data_dir = '../data/processed'
if(!dir.exists(processed_data_dir)){
  dir.create(processed_data_dir)
}
write.csv(df_merged, paste0(processed_data_dir, '/merged_discovery_data.csv'), row.names = F)
