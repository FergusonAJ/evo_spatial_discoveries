#! /bin/bash

replace_scripts=1

placement_graphs=(
    toroidal_lattice_3600__60_60.txt
    linear_chain_3600.txt
    star_3600.txt
    cycle_3600.txt             
)

fitness_graphs=(
    graph__reward_1_1__muts_6__change_-0_05__discoveries_77.txt
    graph__reward_1_1__muts_6__change_-0_01__discoveries_77.txt
    graph__reward_1_1__muts_6__change_0_0__discoveries_77.txt
    graph__reward_1_1__muts_6__change_0_01__discoveries_77.txt
    graph__reward_1_1__muts_6__change_0_05__discoveries_77.txt
    graph__reward_2_0__muts_6__change_-0_05__discoveries_77.txt
    graph__reward_2_0__muts_6__change_-0_01__discoveries_77.txt
    graph__reward_2_0__muts_6__change_0_0__discoveries_77.txt
    graph__reward_2_0__muts_6__change_0_01__discoveries_77.txt
    graph__reward_2_0__muts_6__change_0_05__discoveries_77.txt
)

this_dir=$(pwd)
exp_id=1
for p_graph in ${placement_graphs[@]}
do
    p_graph_name=$(echo "$p_graph" | sed -E "s/([[:alpha:]_]+)_3600.+/\1/g")
    #echo "$p_graph_name"
    for f_graph in ${fitness_graphs[@]}
    do
        f_graph_info=$(echo "$f_graph" | sed -E "s/graph__reward_([0-9]+_[0-9]+)__.+__change_(-?[0-9]+_[0-9]+)_.+/\1 \2/g")
        f_graph_reward=$(echo "$f_graph_info" | grep -oP "^\d+_\d+")
        f_graph_step=$(echo "$f_graph_info" | grep -oP "\-?\d+_\d+$")

        if [ "$p_graph_name" = "toroidal_lattice" ] && [ "$f_graph_reward" = "1_1" ]
        then
           continue
        fi 

        #echo "    $f_graph_reward --- $f_graph_step"
        exp_id_zp=$(printf "%02d" $exp_id)
        exp_id=$(( exp_id + 1 ))
        exp_name="2024_11_14_${exp_id_zp}__${p_graph_name}__r_${f_graph_reward}__s_${f_graph_step}"
        echo "Processing: ${exp_name}"
        if ! [ -e ${exp_name}/analysis ]
        then
          cp -r 2024_11_14_00__toroidal_lattice__r_1_1__s_-0_05/analysis ${exp_name}
        fi
        if ! [ ${replace_scripts} -eq 0 ]
        then
          cp 2024_11_14_00__toroidal_lattice__r_1_1__s_-0_05/analysis/*.R ${exp_name}/analysis
        fi
        cd ${exp_name}/analysis
        Rscript 00_analyze_discovery_data.R
        cd ${this_dir}
    done    
done


#cat exp_main.mabe | sed -e "s/((FITNESS_GRAPH))/foo/g"

