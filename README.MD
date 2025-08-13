#DSST's PMC OA Code Repository

## Introduction

DSST is attempting to create an update and upgrade of the paper: "Assessment of transparency indicators across the biomedical literature: How open is open?" In order to do this, we need to download the PubMed Central Open Access (PMCOA) XML collection. This repo is to preserve code to work with the PMCOA data.

## Downloading the dataset

The PMCOA data is stored as txt and xml files. In the original paper only the XML files for the commerical and non-commerical licensed papers were used. The bash script `download_pmcoa.sh` will use `lftp` to download all the filelist CSVs and the tarballed XML files.

## Extracting the dataset

The `untar_pmcoa_comm_noncomm.sh` BASH script will serially unpack all the the .tar.gz in a given directory. However, the SBATCH parameters were not parsed by biowulf in the original script so only a partial unpacking occured (see `slurm-64691156.out`). @joshlawrimore added the `--skip-old-files` to the script and corrected the `sbatch_untar_pmcoa_comm_non_comm.sh` submission script (see `slurm-64727597.out`)

@joshlawrimore is hoping the `--skip-old-files` will correctly process the iterrupted tar.gz file: `oa_comm_xml.PMC010xxxxxx.baseline.2025-06-26.tar.gz` but this shoudl be confirmed after extraction is finished.

## Analyzing the dataset

@joshlawrimore need to write the code to run the old rtransparent version from the original paper on this set to validate old numbers from paper and from previous work in DSST.
