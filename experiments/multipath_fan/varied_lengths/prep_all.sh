#!/bin/bash

this_dir=$(pwd)
for dir in $(ls | grep 2025_)
do
    echo "$dir"
    cd $dir
    ./00_prepare_evolution_jobs.sb
    cd $this_dir
done
