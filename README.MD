#DSST's PMC OA Code Repository

## Introduction

DSST is attempting to create an update and upgrade of the paper: "Assessment of transparency indicators across the biomedical literature: How open is open?" In order to do this, we need to download the PubMed Central Open Access (PMCOA) XML collection. This repo is to preserve code to work with the PMCOA data.

## Downloading the dataset

The PMCOA data is stored as txt and xml files. In the original paper only the XML files for the commerical and non-commerical licensed papers were used. The bash script `download_pmcoa.sh` will use `lftp` to download all the filelist CSVs and the tarballed XML files.

## Extracting the dataset

@joshlawrimore needs to write the code for this.

## Analyzing the dataset

@joshlawrimore need to write the code to run the old rtransparent version from the original paper on this set to validate old numbers from paper and from previous work in DSST.

