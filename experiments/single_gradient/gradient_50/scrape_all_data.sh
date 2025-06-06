#!/bin/bash

this_dir=$(pwd)
for dir in $(ls | grep 2025_)
do
    echo "$dir"
    if [ ! $dir = "2025_03_16_01__well_mixed" ]
    then
        cp 2025_03_16_01__well_mixed/data/scripts/* ${dir}/data/scripts
    fi
    cd $dir/data/scripts
    ./scrape_phylogenetic_data.sh  
    ./scrape_ifg_discoveries.sh    
    ./scrape_sweep_data.sh
    cd $this_dir
done
