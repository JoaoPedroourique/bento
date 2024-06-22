#!/bin/bash
#SBATCH --job-name=tcc_joao
#SBATCH --partition=draco
#SBATCH --nodelist=draco2
#SBATCH --nodes=1
#SBATCH --time=06:00:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=errors/%x_%j.err
MACHINE="draco2"
ALGORITHMS=("spark" "vaex")
DATASETS=("70m_no_out" "80m_no_out" "90m_no_out" "full_no_out")
PIPELINE_FLAGS=("--pipeline" "--pipeline-step" "")

# Loop over each algorithm
for PIPELINE_FLAG in "${PIPELINE_FLAGS[@]}"; do
    # Loop over each dataset
    for DATASET in "${DATASETS[@]}"; do
        # Loop over each pipeline flag
        for ALGORITHM in "${ALGORITHMS[@]}"; do
            docker run \
                -v "$(pwd)":/app:rw \
                -v "$(pwd)/src":/app/src:ro \
                -v "$(pwd)/datasets":/app/datasets:ro \
                -v "$(pwd)/new_results":/app/new_results:rw \
                df-benchmarks-$ALGORITHM \
                --algorithm $ALGORITHM --dataset $DATASET --locally $PIPELINE_FLAG --machine $MACHINE
        done
    done
done