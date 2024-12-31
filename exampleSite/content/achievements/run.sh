#!/bin/bash

# Loop through all directories in the current folder
for dir in */; do
  # Remove the trailing slash to get the directory name
  folder_name=$(basename "$dir")
  
  # Check if index.md exists in the folder
  if [ -f "$dir/index.md" ]; then
    # Rename index.md to folder_name.md
    mv "$dir/index.md" "$dir/${folder_name}.md"
    echo "Renamed $dir/index.md to $dir/${folder_name}.md"
  else
    echo "No index.md found in $dir"
  fi
done
