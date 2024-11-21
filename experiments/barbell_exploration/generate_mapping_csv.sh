#! /bin/bash

placement_graphs=(
    barbell_3600__10_80_10.txt  
    barbell_3600__25_50_25.txt  
    barbell_3600__40_10_40.txt 
    barbell_3600__45_5_45.txt 
    barbell_3600__5_90_5.txt
)

fitness_graphs=(
    graph__reward_1_1__muts_6__change_-0_05__discoveries_2.txt
    graph__reward_1_1__muts_6__change_-0_01__discoveries_2.txt
    graph__reward_1_1__muts_6__change_0_0__discoveries_2.txt
    graph__reward_1_1__muts_6__change_0_01__discoveries_2.txt
    graph__reward_1_1__muts_6__change_0_05__discoveries_2.txt
    graph__reward_2_0__muts_6__change_-0_05__discoveries_2.txt
    graph__reward_2_0__muts_6__change_-0_01__discoveries_2.txt
    graph__reward_2_0__muts_6__change_0_0__discoveries_2.txt
    graph__reward_2_0__muts_6__change_0_01__discoveries_2.txt
    graph__reward_2_0__muts_6__change_0_05__discoveries_2.txt
)

output_file=mapping.csv
echo "exp_name,exp_id,exp_id_padded,placement_file,pct_per_clique,pct_chain" > $output_file

this_dir=$(pwd)
exp_id=5
for p_graph in ${placement_graphs[@]}
do
    p_graph_name=$(echo "$p_graph" | sed -E "s/([[:alpha:]_]+)_3600.+/\1/g")
    #echo "$p_graph_name"
    for f_graph in ${fitness_graphs[@]}
    do
        f_graph_info=$(echo "$f_graph" | sed -E "s/graph__reward_([0-9]+_[0-9]+)__.+__change_(-?[0-9]+_[0-9]+)_.+/\1 \2/g")
        f_graph_reward=$(echo "$f_graph_info" | grep -oP "^\d+_\d+")
        f_graph_step=$(echo "$f_graph_info" | grep -oP "\-?\d+_\d+$")

        exp_id_zp=$(printf "%02d" $exp_id)
        exp_id=$(( exp_id + 1 ))
        exp_name="2024_11_20_${exp_id_zp}__${p_graph_name}__r_${f_graph_reward}__s_${f_graph_step}"
        map_parts=$(echo "${p_graph}" | grep -oP "\d+_\d+_\d+")
        clique_size=$(echo "${map_parts}" | grep -oP "^\d+")
        chain_size=$(echo "${map_parts}" | grep -oP "^\d+_\d+" | grep -oP "\d+$")

        echo "${exp_name},${exp_id},${exp_id_zp},${p_graph},${clique_size},${chain_size}" >> $output_file

    done    
done


#cat exp_main.mabe | sed -e "s/((FITNESS_GRAPH))/foo/g"

