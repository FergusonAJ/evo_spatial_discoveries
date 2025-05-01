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
  ifg_filename = paste0(exp_analysis_dir, '/data/combined_ifg_data.csv')
  df_exp_ifg = read.csv(ifg_filename)
  df_exp_ifg$landscape = exp_name
  if(!'source_node' %in% colnames(df_exp_ifg)){
    df_exp_ifg$source_node = 0
  }
  if('node' %in% colnames(df_exp_ifg)){
    df_exp_ifg$dest_node = df_exp_ifg$node
    df_exp_ifg = df_exp_ifg[,setdiff(colnames(df_exp_ifg), 'node')]
  }
  if('steps' %in% colnames(df_exp_ifg)){
    df_exp_ifg$num_steps = df_exp_ifg$steps
    df_exp_ifg = df_exp_ifg[,setdiff(colnames(df_exp_ifg), 'steps')]
  }
  if('X' %in% colnames(df_exp_ifg)){
    df_exp_ifg = df_exp_ifg[,setdiff(colnames(df_exp_ifg), 'X')]
  }
  if(!is.data.frame(df_combined)) df_combined = df_exp_ifg
  else df_combined = rbind(df_combined, df_exp_ifg)
}

df_combined$structure_str = gsub('_', ' ', df_combined$structure)

output_filename = paste0(output_dir, '/combined_ifg_data.csv')
write.csv(df_combined, output_filename, row.names = F)