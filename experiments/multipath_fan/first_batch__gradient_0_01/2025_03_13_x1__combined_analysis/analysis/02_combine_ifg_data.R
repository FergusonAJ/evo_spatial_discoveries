rm(list = ls())

df_chain_0_001_ifg = read.csv('../../2025_03_07_01__linear_chain__0_001__phylo/data/combined_ifg_discovery_data.csv')
df_chain_0_001_ifg$gradient = 0.001
df_chain_0_001_ifg$structure = 'linear_chain'

df_grid_0_001_ifg = read.csv('../../2025_03_07_02__toroidal_lattice__0_001__phylo/data/combined_ifg_discovery_data.csv')
df_grid_0_001_ifg$gradient = 0.001
df_grid_0_001_ifg$structure = 'toroidal_grid'

df_chain_0_1_ifg = read.csv('../../2025_03_07_03__linear_chain__0_1__phylo/data/combined_ifg_discovery_data.csv')
df_chain_0_1_ifg$gradient = 0.1
df_chain_0_1_ifg$structure = 'linear_chain'

df_grid_0_1_ifg = read.csv('../../2025_03_07_04__toroidal_lattice__0_1__phylo/data/combined_ifg_discovery_data.csv')
df_grid_0_1_ifg$gradient = 0.1
df_grid_0_1_ifg$structure = 'toroidal_grid'

df_chain_0_01_ifg = read.csv('../../2025_03_07_05__linear_chain_0_01__phylo/data/combined_ifg_discovery_data.csv')
df_chain_0_01_ifg$gradient = 0.01
df_chain_0_01_ifg$structure = 'linear_chain'

df_grid_0_01_ifg = read.csv('../../2025_03_07_06__toroidal_lattice__0_01__phylo/data/combined_ifg_discovery_data.csv')
df_grid_0_01_ifg$gradient = 0.01
df_grid_0_01_ifg$structure = 'toroidal_grid'

df_all_ifg = rbind(df_chain_0_001_ifg, df_grid_0_001_ifg, df_chain_0_1_ifg, df_grid_0_1_ifg, df_chain_0_01_ifg, df_grid_0_01_ifg)
write.csv(df_all_ifg, '../data/combined_ifg_data.csv')
