rm(list = ls())

df_prob_0_001 = read.csv('../../2024_10_30_01__barbell_prob_0_001/data/processed/merged_discovery_data.csv')
df_prob_0_001$is_beneficial = T
df_prob_0_001$prob = 0.001
df_prob_0_001$condition = '0.1% prob of adaptive path'

df_prob_0_01 = read.csv('../../2024_10_30_02__barbell_prob_0_01/data/processed/merged_discovery_data.csv')
df_prob_0_01$is_beneficial = T
df_prob_0_01$prob = 0.01
df_prob_0_01$condition = '1% prob of adaptive path'

df_am = read.csv('../../2024_10_31_01__barbell_AM/data/processed/merged_discovery_data.csv')
df_am$is_beneficial = F
df_am$prob = 1
df_am$condition = 'Adaptive Momentum (no adaptive path)'

df_neutral = read.csv('../../2024_10_31_02__barbell_neutral/data/processed/merged_discovery_data.csv')
df_neutral$is_beneficial = F
df_neutral$prob = 0.33
df_neutral$condition = '33% prob of neutral path'


condition_levels = c(
  '33% prob of neutral path',
  '1% prob of adaptive path',
  '0.1% prob of adaptive path',
  'Adaptive Momentum (no adaptive path)'
)

df_all = rbind(df_am, df_neutral, df_prob_0_01, df_prob_0_001)
df_all$condition_factor = factor(df_all$condition, levels = condition_levels)

processed_data_dir = '../data/processed'
if(!dir.exists(processed_data_dir)){
  dir.create(processed_data_dir, showWarnings = F, recursive = T)
}
write.csv(df_all, paste0(processed_data_dir, '/combined_data.csv'))
