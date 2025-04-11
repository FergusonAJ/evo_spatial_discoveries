rm(list = ls())

exp_paths = c(
  '../../single_gradient/gradient_50',
  '../../multipath_fan/varied_lengths',
  '../../valley_crossing/'
)
exp_names = c(
  'Single gradient', 
  'Multipath', 
  'Valley crossing'
)

output_dir = '../data'
if(!dir.exists(output_dir)) dir.create(output_dir, recursive = T)

df_combined = NA
for(exp_id in 1:length(exp_paths)){
  exp_path = exp_paths[exp_id]
  exp_name = exp_names[exp_id]
  cat('Processing:', exp_name, '\n')
  dirs = list.dirs(exp_path, recursive = F)
  exp_analysis_dir = dirs[grepl('_x1_', dirs)]
  sweep_filename = paste0(exp_analysis_dir, '/data/combined_sweep_data.csv')
  df_exp_sweep = read.csv(sweep_filename)
  df_exp_sweep$landscape = exp_name
  if('X' %in% colnames(df_exp_sweep)){
    df_exp_sweep = df_exp_sweep[,setdiff(colnames(df_exp_sweep), 'X')]
  }
  if(!is.data.frame(df_combined)) df_combined = df_exp_sweep
  else df_combined = rbind(df_combined, df_exp_sweep)
}

df_combined$structure_str = gsub('_', ' ', df_combined$structure)

output_filename = paste0(output_dir, '/combined_sweep_data.csv')
write.csv(df_combined, output_filename, row.names = F)
