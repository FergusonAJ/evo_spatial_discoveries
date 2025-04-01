#!/bin/bash

this_dir=$(pwd)
for dir in $(ls | grep 2025_)
do
    echo "$dir"
    if [ ! $dir = "2025_03_16_01__well_mixed" ]
    then
        cp 2025_03_16_01__well_mixed/data/scripts/scrape_max_org_data.sh ${dir}/data/scripts
    fi
    cd $dir/data/scripts
    ./scrape_max_org_data.sh
    cd $this_dir
done
