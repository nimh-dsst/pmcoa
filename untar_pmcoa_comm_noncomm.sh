#!/bin/bash

# Script to extract .tar.gz files into their own folders
# Usage: ./extract_targz.sh [directory_path]

# Set the directory to process (default to current directory if not specified)
TARGET_DIR="${1:-.}"

# Check if the directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# Change to the target directory
cd "$TARGET_DIR" || exit 1

echo "Processing .tar.gz files in: $(pwd)"

# Counter for processed files
processed=0

# Iterate over all .tar.gz files in the directory
for file in *.tar.gz; do
    # Check if the glob pattern matched any files
    if [ ! -f "$file" ]; then
        echo "No .tar.gz files found in the current directory."
        break
    fi
    
    # Get the base name without .tar.gz extension
    base_name="${file%.tar.gz}"
    
    # Create directory with the same name as the tar.gz file
    if [ ! -d "$base_name" ]; then
        echo "Creating directory: $base_name"
        mkdir -p "$base_name"
    else
        echo "Directory already exists: $base_name"
    fi
    
    # Extract the tar.gz file into the created directory
    echo "Extracting $file into $base_name/"
    if tar -xzf "$file" -C "$base_name"; then
        echo "Successfully extracted $file"
        ((processed++))
    else
        echo "Error: Failed to extract $file"
    fi
    
    echo "---"
done

echo "Processing complete. Extracted $processed .tar.gz files."
