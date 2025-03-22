rm(list = ls())

dir_names = list.dirs('../..', recursive = F)
dir_names = dir_names[file.exists(paste0(dir_names, '/00_prepare_evolution_jobs.sb'))]
dir_names = dir_names[dir_names != '../../template']

extract_r = function(dir_name){
  rx_r = regexpr('r_(\\d+)_(\\d+)', dir_name, perl=T)
  r_starts = attr(rx_r, 'capture.start')
  r_lengths = attr(rx_r, 'capture.length')
  r_main = substr(dir_name, r_starts[1], r_starts[1] + r_lengths[1] - 1)
  r_decimal = substr(dir_name, r_starts[2], r_starts[2] + r_lengths[2] - 1)
  r = as.numeric(r_main) + as.numeric(r_decimal) / (10 ^ nchar(r_decimal))
  return(r)
}

extract_s = function(dir_name){
  rx_s = regexpr('s_-?(\\d+)_(\\d+)', dir_name, perl=T)
  s_starts = attr(rx_s, 'capture.start')
  s_lengths = attr(rx_s, 'capture.length')
  s_main = substr(dir_name, s_starts[1], s_starts[1] + s_lengths[1] - 1)
  s_decimal = substr(dir_name, s_starts[2], s_starts[2] + s_lengths[2] - 1)
  s = as.numeric(s_main) + as.numeric(s_decimal) / (10 ^ nchar(s_decimal))
  rx_sign_check = regexpr('s_-(\\d+)_(\\d+)', dir_name, perl=T)
  if(rx_sign_check != -1){
    s = s * -1
  }
  return(s)
}

extract_structure = function(dir_name){
  rx = regexpr('\\d{4}_\\d\\d_\\d\\d_\\d\\d__(.+)__r_\\d', dir_name, perl=T)
  starts = attr(rx, 'capture.start')
  lengths = attr(rx, 'capture.length')
  name = substr(dir_name, starts[1], starts[1] + lengths[1] - 1)
  return(name)  
}

df_combined = NA

for(dir_name in dir_names){
  cat(dir_name, '\n') 
  r = extract_r(dir_name)
  s = extract_s(dir_name)
  structure = extract_structure(dir_name)
  cat(r, ' ', s, ' ', structure, '\n')
  df_tmp = read.csv(paste0(dir_name, '/data/processed/merged_discovery_data.csv'))
  df_tmp$reward = r
  df_tmp$fitness_step = s
  df_tmp$structure = structure
  if(!is.data.frame(df_combined)){
    df_combined = df_tmp
  } else {
    df_combined = rbind(df_combined, df_tmp)
  }
}

processed_data_dir = '../data/processed'
if(!dir.exists(processed_data_dir)){
  dir.create(processed_data_dir, recursive = T)
}
write.csv(df_combined, paste0(processed_data_dir, '/combined_discovery_data.csv'), row.names = F)
