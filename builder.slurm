#!/bin/bash
#SBATCH --job-name=tcc_joao
#SBATCH --partition=tupi
#SBATCH --nodelist=tupi3
#SBATCH --nodes=1
#SBATCH --time=00:30:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

docker build --rm -t df-benchmarks -f install/Dockerfile .
docker build  --rm -t df-benchmarks-modin_dask -f install/Dockerfile.modin_dask .
docker build  --rm -t df-benchmarks-pandas -f install/Dockerfile.pandas .
docker build  --rm -t df-benchmarks-polars -f install/Dockerfile.polars .
docker build  --rm -t df-benchmarks-koalas -f install/Dockerfile.koalas .