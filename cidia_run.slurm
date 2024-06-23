#!/bin/bash
#SBATCH --job-name=tcc_joao
#SBATCH --partition=cidia
#SBATCH --nodelist=cidia
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=errors/%x_%j.err
MACHINE="cidia"
ALGORITHMS=("spark" "vaex" "polars" "pandas" "modin_dask")
DATASETS=("small_no_out" "medium_no_out" "big_no_out" "great_no_out" "40m_no_out" "50m_no_out" "60m_no_out" "70m_no_out" "80m_no_out" "90m_no_out" "full_no_out")
PIPELINE_FLAGS=("--pipeline" "--pipeline-step" "")

for i in {1..3}; do
    echo "Iteration $i"
    for PIPELINE_FLAG in "${PIPELINE_FLAGS[@]}"; do
        for DATASET in "${DATASETS[@]}"; do
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
done