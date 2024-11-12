rm(list = ls())

df_am = read.csv('../../2024_10_13_01__adaptive_momentum/data/processed/matched_discovery_data.csv')
df_prob_0_5 = read.csv('../../2024_10_15_01__beneficial_prob_0_5/data/processed/matched_discovery_data.csv')
df_prob_0_01 = read.csv('../../2024_10_15_02__beneficial_prob_0_01/data/processed/matched_discovery_data.csv')
df_prob_0_001 = read.csv('../../2024_10_15_03__beneficial_prob_0_001/data/processed/matched_discovery_data.csv')
df_prob_0_0001 = read.csv('../../2024_10_15_04__beneficial_prob_0_0001/data/processed/matched_discovery_data.csv')

df_am$is_benficial = F
df_am$prob = 1
df_am$condition = 'Adaptive Momentum (no adaptive path)'

df_prob_0_5$is_benficial = T
df_prob_0_5$prob = 0.33
df_prob_0_5$condition = '33% prob of adaptive path'

df_prob_0_01$is_benficial = T
df_prob_0_01$prob = 0.01
df_prob_0_01$condition = '1% prob of adaptive path'

df_prob_0_001$is_benficial = T
df_prob_0_001$prob = 0.001
df_prob_0_001$condition = '0.1% prob of adaptive path'

df_prob_0_0001$is_benficial = T
df_prob_0_0001$prob = 0.0001
df_prob_0_0001$condition = '0.01% prob of adaptive path'

condition_levels = c(
  '33% prob of adaptive path',
  '1% prob of adaptive path',
  '0.1% prob of adaptive path',
  '0.01% prob of adaptive path',
  'Adaptive Momentum (no adaptive path)'
)

df_all = rbind(df_am, df_prob_0_5, df_prob_0_01, df_prob_0_001, df_prob_0_0001)
df_all$condition_factor = factor(df_all$condition, levels = condition_levels)

processed_data_dir = '../data/processed'
if(!dir.exists(processed_data_dir)){
  dir.create(processed_data_dir, showWarnings = F, recursive = T)
}
write.csv(df_all, paste0(processed_data_dir, '/combined_data.csv'))
