#!/bin/bash
#SBATCH --job-name=tcc_joao
#SBATCH --partition=tupi
#SBATCH --nodelist=tupi3
#SBATCH --nodes=1
#SBATCH --time=03:00:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=errors/%x_%j.err

ALGORITHMS=("spark" "pandas" "polars" "modin_dask" "koalas" "vaex")
DATASETS=("small_air" "medium_air" "big_air", "great_air")
PIPELINE_FLAGS=("--pipeline" "--pipeline-step" "")

# Loop over each algorithm
for ALGORITHM in "${ALGORITHMS[@]}"; do
    # Loop over each dataset
    for DATASET in "${DATASETS[@]}"; do
        # Loop over each pipeline flag
        for PIPELINE_FLAG in "${PIPELINE_FLAGS[@]}"; do
            # for rapids, check if the NVIDIA Docker runtime is available
            if docker info --format '{{.Runtimes.nvidia}}' &> /dev/null; then
                RUNTIME="--runtime=nvidia"
            else
                RUNTIME=""
            fi
            docker run \
                $RUNTIME \
                -v "$(pwd)":/app:rw \
                -v "$(pwd)/src":/app/src:ro \
                -v "$(pwd)/datasets":/app/datasets:ro \
                -v "$(pwd)/new_results":/app/new_results:rw \
                df-benchmarks-$ALGORITHM \
                --algorithm $ALGORITHM --dataset $DATASET --locally $PIPELINE_FLAG
        done
    done
done