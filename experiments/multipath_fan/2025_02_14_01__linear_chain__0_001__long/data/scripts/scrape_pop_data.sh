#!/bin/bash
IS_VERBOSE=0

# Grab global variables and helper functions
# Root directory -> The root level of the repo, should be directory just above 'experiments'
REPO_ROOT_DIR=$(pwd | grep -oP ".+(?=/experiments/)")
if [ ! ${IS_VERBOSE} -eq 0 ]
then
  echo "[VERBOSE] Found repo root dir: ${REPO_ROOT_DIR}"
  echo "[VERBOSE] Loading global config and helper functions..."
fi
. ${REPO_ROOT_DIR}/config_global.sh
. ${REPO_ROOT_DIR}/global_shared_files/helper_functions.sh

# Extract info about this experiment
EXP_NAME=$( get_cur_exp_name )
EXP_REL_PATH=$( get_cur_relative_exp_path )
EXP_ROOT_DIR=${REPO_ROOT_DIR}/${EXP_REL_PATH}
if [ ! ${IS_VERBOSE} -eq 0 ]
then
  echo "[VERBOSE] Experiment name: ${EXP_NAME}"
  echo "[VERBOSE] Experiment path (relative): ${EXP_REL_PATH}"
  echo "[VERBOSE] Experiment root dir (not relative): ${EXP_ROOT_DIR}"
  echo ""
fi

# Grab references to the various directories used in setup
MABE_DIR=${REPO_ROOT_DIR}/MABE2
#MABE_EXTRAS_DIR=${REPO_ROOT_DIR}/MABE2_extras
SCRATCH_EXP_DIR=${SCRATCH_ROOT_DIR}/${EXP_REL_PATH}
SCRATCH_REP_DIR=${SCRATCH_EXP_DIR}/reps
if [ ! ${IS_VERBOSE} -eq 0 ]
then
  echo ""
  echo "[VERBOSE] MABE dir: ${MABE_DIR}"
  echo "[VERBOSE] Global shared file dir: ${GLOBAL_FILE_DIR}"
  echo "[VERBOSE] Scratch directories:"
  echo "[VERBOSE]     Main exp dir: ${SCRATCH_EXP_DIR}"
  echo "[VERBOSE]     Scratch reps dir: ${SCRATCH_REP_DIR}"
fi

output_dir=../reps
mkdir -p ${output_dir}
is_agg_file_initialized=0
agg_file=../aggregated_discovery_data.csv
for dir_name in $( ls ${SCRATCH_REP_DIR} )
do
    full_name=${SCRATCH_REP_DIR}/${dir_name}
    if ! [ -d $full_name ]
    then
        continue
    fi
    echo "Scraping rep: ${dir_name}"
    
    output_file=${output_dir}/${dir_name}.csv
    echo "node_1,node_2,steps,gen,rep_id" > ${output_file}
    for file in $(ls ${full_name}/pop_gen*)
    do
        gen=$(echo "$file" | grep -oP "\d+\.pop" | grep -oP "\d+")
        sed -E "s/\[[[:space:]]([[:digit:]]+)[[:space:]]+([[:digit:]]+)[[:space:]]+([[:digit:]]+)[[:space:]]+\]/\1,\2,\3,${gen},${dir_name}/g" < ${file} >> ${output_file}
    done
    # Calculate the replicate's seed
    #SEED_BASE=$( exp_name_to_seed ${EXP_NAME} )
    #rep_seed=$( echo "$dir_name" | sed -E 's/0*([1-9]+0*)/\1/' )
    #SEED=$(( SEED_BASE + (rep_seed * 10000) ))
    #trial_seed=$((SEED + trial_id))
    #sort ${full_name}/final_pop_${trial_id}.pop | uniq -c | sort -nr | sed -E "s/^[[:space:]]+([[:digit:]]+)[[:space:]]+(.+)/${dir_name},${trial_id},\1,\"\2\",${trial_seed}/g" >> ${output_file}
    #input_file=${full_name}/pop_gen_1000.pop
    #sed -E "s/\[[[:space:]]([[:digit:]]+)[[:space:]]+([[:digit:]]+)[[:space:]]+([[:digit:]]+)[[:space:]]+\]/\1,\2,\3,99900,001/g" < ${input_file}
done
