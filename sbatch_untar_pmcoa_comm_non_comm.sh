#!/bin/bash

sbatch --time=10:00:00 --mem=8GB --mail-type=ALL untar_pmcoa_comm_noncomm.sh "/home/lawrimorejg/data/pmcoa"
