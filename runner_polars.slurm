#!/bin/bash
#SBATCH --job-name=tcc_joao
#SBATCH --partition=tupi
#SBATCH --nodelist=tupi3
#SBATCH --nodes=1
#SBATCH --time=00:10:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=errors/%x_%j.err

docker run -d \
	--cpuset-cpus="0-1" \
	-v "$(pwd)":/app:rw \
	-v "$(pwd)/src":/app/src:ro \
	-v "$(pwd)/datasets":/app/datasets:ro \
	-v "$(pwd)/results":/app/results:rw \
	df-benchmarks-polars \
	--algorithm polars --dataset medium_air --locally --cpu-limit 1