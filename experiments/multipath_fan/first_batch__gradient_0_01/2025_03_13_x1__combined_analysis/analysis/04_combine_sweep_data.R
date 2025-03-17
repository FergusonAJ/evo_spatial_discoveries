rm(list = ls())

df_combined = NA
gradient = 0.01

for(dir in list.dirs('../..', recursive = F)){
  print(dir)
  exp_id = strsplit(dir, '_')[[1]][4]
  if(grepl('x', exp_id)){
    print('Skipping!')
    next
  }
  structure = strsplit(dir, '__')[[1]][-1]
  print(structure)
  df_dir = read.csv(paste0(dir, '/data/combined_sweep_data.csv'))
  df_dir$gradient = gradient
  df_dir$structure = structure
  if(is.data.frame(df_combined)){
    df_combined = rbind(df_combined, df_dir)
  } else {
    df_combined = df_dir
  }
}

df_combined$sweep_num = NA
for(structure in unique(df_combined$structure)){
  structure_mask = df_combined$structure == structure
  for(rep in unique(df_combined[structure_mask,]$rep)){
    rep_mask = df_combined$rep == rep & structure_mask
    df_combined[rep_mask,]$sweep_num = 1:sum(rep_mask)
  }
}

write.csv(df_combined, '../data/combined_sweep_data.csv', row.names = F)
