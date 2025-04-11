rm(list = ls())

exp_paths = c(
  '../../toroids_single_gradient/gradient_50',
  '../../toroids_multipath',
  '../../toroids_valley_crossing'
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
  max_org_filename = paste0(exp_analysis_dir, '/data/combined_max_org_over_time_data.csv')
  df_exp_max_org = read.csv(max_org_filename)
  df_exp_max_org$landscape = exp_name
  if('X' %in% colnames(df_exp_max_org)){
    df_exp_max_org = df_exp_max_org[,setdiff(colnames(df_exp_max_org), 'X')]
  }
  if(!is.data.frame(df_combined)) df_combined = df_exp_max_org
  else df_combined = rbind(df_combined, df_exp_max_org)
}

df_combined$structure_str = gsub('_', 'x', df_combined$structure)

output_filename = paste0(output_dir, '/combined_max_org_data.csv')
write.csv(df_combined, output_filename, row.names = F)
