#!/bin/bash
#SBATCH --job-name=tcc_joao
#SBATCH --partition=tupi
#SBATCH --nodelist=tupi3
#SBATCH --nodes=1
#SBATCH --time=01:00:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=errors/%x_%j.err

# Define an array of algorithms
ALGORITHMS=("koalas" "pandas" "polars" "modin_dask" "vaex" "spark")
DATASET="small_air"

# Loop over each algorithm
for ALGORITHM in "${ALGORITHMS[@]}"; do
	# for rapids, check if the NVIDIA Docker runtime is available
	if docker info --format '{{.Runtimes.nvidia}}' &> /dev/null; then
		RUNTIME="--runtime=nvidia"
	else
		RUNTIME=""
	fi
    docker run \
        -v "$(pwd)":/app:rw \
        -v "$(pwd)/src":/app/src:ro \
        -v "$(pwd)/datasets":/app/datasets:ro \
        -v "$(pwd)/results":/app/results:rw \
        df-benchmarks-$ALGORITHM \
        --algorithm $ALGORITHM --dataset $DATASET --locally
done