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

    # Calculate the replicate's seed
    SEED_BASE=$( exp_name_to_seed ${EXP_NAME} )
    rep_seed=$( echo "$dir_name" | sed -E 's/0*([1-9]+0*)/\1/' )
    echo "Scraping rep: ${dir_name}"
    SEED=$(( SEED_BASE + (rep_seed * 10000) ))

    output_file=${output_dir}/${dir_name}.csv

    # Scrape the data
    python3 _helper_discovery.py ${full_name}/combined_output.txt ${dir_name} ${SEED} > \
        ${output_file}
    if [ ${is_agg_file_initialized} -eq 0 ]
    then
        cat ${output_file} > ${agg_file}
        is_agg_file_initialized=1
    else
        num_lines=$( wc -l ${output_file} | grep -oP "^\d+")
        tail -n $(( num_lines - 1)) ${output_file} >> ${agg_file}
    fi
done
