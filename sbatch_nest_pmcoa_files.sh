#!/bin/bash

cd /home/lawrimorejg/data/pmcoa

sbatch \
  --job-name=nest_pmcoa_files \
  --output=nest_pmcoa_files_%j.out \
  --error=nest_pmcoa_files_%j.err \
  --time=10-00:00:00 \
  --mem=8G \
  --cpus-per-task=1 \
  --mail-type=ALL \
  /home/lawrimorejg/repos/pmcoa/nest_pmcoa_files.sh /home/lawrimorejg/data/pmcoa
