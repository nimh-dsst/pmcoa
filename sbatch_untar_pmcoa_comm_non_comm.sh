#!/bin/bash

#SBATCH --job-name=untar_pmcoa_comm_non_comm
#SBATCH --output=untar_pmcoa_comm_non_comm.out
#SBATCH --error=untar_pmcoa_comm_non_comm.err
#SBATCH --time=10:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1GB
#SBATCH --mail-type=ALL

TARGET_DIR="${1}"
sh untar_pmcoa_comm_noncomm.sh "$TARGET_DIR"
