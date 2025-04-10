#!/bin/bash

this_dir=$(pwd)
for dir in $(ls | grep 2025_)
do
    echo "$dir"
    if [ ! $dir = "2025_04_03_01__60_60" ]
    then
        cp 2025_04_03_01__60_60__well_mixed/data/scripts/* ${dir}/data/scripts
    fi
    cd $dir/data/scripts
    ./scrape_phylogenetic_data.sh  
    ./scrape_ifg_discoveries.sh    
    ./scrape_sweep_data.sh
    ./scrape_max_org_data.sh
    cd $this_dir
done
