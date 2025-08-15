#!/bin/bash

# SLURM job script for organizing PMCOA XML files
# Usage: sbatch nest_pmcoa_files.sh /path/to/csv/directory


# Check if directory argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <csv_directory>"
    echo "Example: $0 /home/lawrimorejg/data/pmcoa"
    exit 1
fi

CSV_DIR="$1"
ROOT_OUTPUT_DIR="pmcoa_xmls_nested"
ERROR_LOG="missing_files.log"
MAX_FILES_PER_DIR=4096 #reported in Serghiou et al.

# Function to print progress with timestamp
log_progress() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to get current file count in a directory
get_file_count() {
    local dir="$1"
    if [ -d "$dir" ]; then
        find "$dir" -type f -name "*.xml" | wc -l
    else
        echo "0"
    fi
}

# Function to get next available subdirectory
get_next_subdir() {
    local base_dir="$1"
    local counter=1
    
    while true; do
        local subdir="${base_dir}/batch_$(printf "%04d" $counter)"
        local file_count=$(get_file_count "$subdir")
        
        if [ "$file_count" -lt "$MAX_FILES_PER_DIR" ]; then
            echo "$subdir"
            return 0
        fi
        ((counter++))
    done
}

# Initialize
log_progress "Starting PMCOA XML file organization"
log_progress "CSV directory: $CSV_DIR"
log_progress "Output directory: $ROOT_OUTPUT_DIR"
log_progress "Max files per subdirectory: $MAX_FILES_PER_DIR"

# Create root output directory
mkdir -p "$ROOT_OUTPUT_DIR"
log_progress "Created root output directory"

# Clear error log
> "$ERROR_LOG"
log_progress "Cleared error log"

# Find all CSV files
log_progress "Searching for CSV files..."
csv_files=($(find "$CSV_DIR" -name "*.filelist.csv" -type f))
total_csv_files=${#csv_files[@]}

log_progress "Found $total_csv_files CSV files to process"

# Debug: Show first few CSV files
log_progress "First 3 CSV files found:"
for i in {0..2}; do
    if [ $i -lt $total_csv_files ]; then
        log_progress "  $((i+1)): ${csv_files[$i]}"
    fi
done

# Initialize counters
total_files_processed=0
total_files_copied=0
total_files_missing=0
current_subdir=""

# Process each CSV file
for ((i=0; i<total_csv_files; i++)); do
    csv_file="${csv_files[$i]}"
    
    # Extract directory name from CSV filename
    # Remove .filelist.csv suffix and get the base name
    csv_basename=$(basename "$csv_file")
    source_dir_name="${csv_basename%.filelist.csv}"
    
    log_progress "Processing CSV $((i+1))/$total_csv_files: $csv_basename"
    log_progress "  Source directory: $source_dir_name"
    
    # Check if source directory exists
    source_dir="$CSV_DIR/$source_dir_name"
    log_progress "  Checking if source directory exists: $source_dir"
    if [ ! -d "$source_dir" ]; then
        log_progress "  WARNING: Source directory $source_dir does not exist"
        echo "$source_dir" >> "$ERROR_LOG"
        continue
    fi
    
    log_progress "  Source directory exists, checking CSV file..."
    
    # Check if CSV file is readable
    if [ ! -r "$csv_file" ]; then
        log_progress "  ERROR: Cannot read CSV file $csv_file"
        continue
    fi
    
    log_progress "  CSV file is readable, starting to process lines..."
    
    # Read CSV file, skip header, process each line
    # Use tail to skip header and process each line
    line_count=0
    while IFS=',' read -r article_file rest_of_line; do
        # Skip empty lines
        if [ -z "$article_file" ]; then
            continue
        fi
        
        # Skip header line (contains "Article File")
        if [[ "$article_file" == *"Article File"* ]]; then
            continue
        fi
        
        ((line_count++))
        
        # Construct full source path
        source_path="$source_dir/$article_file"
        
        # Check if file exists
        if [ ! -f "$source_path" ]; then
            log_progress "  Missing file: $source_path"
            echo "$source_path" >> "$ERROR_LOG"
            ((total_files_missing++))
            continue
        fi
        
        # Get or create target subdirectory
        if [ -z "$current_subdir" ] || [ "$(get_file_count "$current_subdir")" -ge "$MAX_FILES_PER_DIR" ]; then
            current_subdir=$(get_next_subdir "$ROOT_OUTPUT_DIR")
            mkdir -p "$current_subdir"
            log_progress "  Created new subdirectory: $current_subdir"
        fi
        
        # Copy file to target directory
        target_path="$current_subdir/$(basename "$article_file")"
        
        # Use cp with progress indicator for large files
        if cp "$source_path" "$target_path" 2>/dev/null; then
            ((total_files_copied++))
            
            # Print progress every 100 files
            if [ $((total_files_copied % 100)) -eq 0 ]; then
                log_progress "  Copied $total_files_copied files so far"
            fi
        else
            log_progress "  ERROR: Failed to copy $source_path"
            echo "$source_path FILE NOT COPIED to $target_path" >> "$ERROR_LOG"
            ((total_files_missing++))
        fi
        
        ((total_files_processed++))
        
    done < "$csv_file"
    
    log_progress "  Processed $line_count lines from $csv_basename"
done

# Final summary
log_progress "=== PROCESSING COMPLETE ==="
log_progress "Total files processed: $total_files_processed"
log_progress "Total files successfully copied: $total_files_copied"
log_progress "Total files missing/errors: $total_files_missing"
log_progress "Output directory: $ROOT_OUTPUT_DIR"
log_progress "Error log: $ERROR_LOG"

# Show directory structure
log_progress "=== DIRECTORY STRUCTURE ==="
if [ -d "$ROOT_OUTPUT_DIR" ]; then
    for subdir in "$ROOT_OUTPUT_DIR"/batch_*; do
        if [ -d "$subdir" ]; then
            file_count=$(get_file_count "$subdir")
            log_progress "  $(basename "$subdir"): $file_count XML files"
        fi
    done
fi

log_progress "Script completed successfully!"
