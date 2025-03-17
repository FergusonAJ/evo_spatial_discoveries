rm(list = ls())

df_chain_0_001_phylo = read.csv('../../2025_03_07_01__linear_chain__0_001__phylo/data/combined_phylogenetic_data.csv')
df_chain_0_001_phylo$gradient = 0.001
df_chain_0_001_phylo$structure = 'linear_chain'

df_grid_0_001_phylo = read.csv('../../2025_03_07_02__toroidal_lattice__0_001__phylo/data/combined_phylogenetic_data.csv')
df_grid_0_001_phylo$gradient = 0.001
df_grid_0_001_phylo$structure = 'toroidal_grid'

df_chain_0_1_phylo = read.csv('../../2025_03_07_03__linear_chain__0_1__phylo/data/combined_phylogenetic_data.csv')
df_chain_0_1_phylo$gradient = 0.1
df_chain_0_1_phylo$structure = 'linear_chain'

df_grid_0_1_phylo = read.csv('../../2025_03_07_04__toroidal_lattice__0_1__phylo/data/combined_phylogenetic_data.csv')
df_grid_0_1_phylo$gradient = 0.1
df_grid_0_1_phylo$structure = 'toroidal_grid'

df_chain_0_01_phylo = read.csv('../../2025_03_07_05__linear_chain_0_01__phylo/data/combined_phylogenetic_data.csv')
df_chain_0_01_phylo$gradient = 0.01
df_chain_0_01_phylo$structure = 'linear_chain'

df_grid_0_01_phylo = read.csv('../../2025_03_07_06__toroidal_lattice__0_01__phylo/data/combined_phylogenetic_data.csv')
df_grid_0_01_phylo$gradient = 0.01
df_grid_0_01_phylo$structure = 'toroidal_grid'

df_all_phylo = rbind(df_chain_0_001_phylo, df_grid_0_001_phylo, df_chain_0_1_phylo, df_grid_0_1_phylo, df_chain_0_01_phylo, df_grid_0_01_phylo)
write.csv(df_all_phylo, '../data/combined_phylo_data.csv')
