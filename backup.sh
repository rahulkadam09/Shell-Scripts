#!/bin/bash

# Usage: ./backup.sh /root/datafile /root/backup

display_usage() {
    echo "Usage: $0 <source_dir_or_file> <backup_dir>"
}

# Validate arguments
if [ "$#" -ne 2 ]; then
    display_usage
    exit 1
fi

source_dir="$1"
backup_dir="$2"
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
backup_file="${backup_dir}/backup_${timestamp}.zip"

# Check source
if [ ! -e "$source_dir" ]; then
    echo "Error: Source does not exist: $source_dir"
    exit 1
fi

# Check zip installation
if ! command -v zip >/dev/null 2>&1; then
    echo "Error: zip is not installed. Run: sudo apt install zip"
    exit 1
fi

# Create backup directory
mkdir -p "$backup_dir" || exit 1

# Create backup
if zip -r "$backup_file" "$source_dir" >/dev/null; then
    echo "Backup generated successfully: $backup_file"
else
    echo "Error: Backup failed."
    rm -f "$backup_file"
    exit 1
fi

# Keep only the 3 newest timestamped backups
mapfile -t backups < <(
    find "$backup_dir" -maxdepth 1 -type f \
        -name 'backup_*.zip' -printf '%f\n' | sort -r
)

if [ "${#backups[@]}" -gt 3 ]; then
    echo "Performing rotation: keeping 3 backups"

    for backup in "${backups[@]:3}"; do
        rm -f -- "$backup_dir/$backup"
        echo "Removed: $backup"
    done
fi

echo "Backup and rotation completed."
