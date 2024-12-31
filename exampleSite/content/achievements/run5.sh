#!/bin/bash

# Loop through all directories in the current folder
for dir in */; do
  # Remove the trailing slash to get the directory name
  folder_name=$(basename "$dir")
  
  # Check if there are any .md files in the folder
  if compgen -G "$dir*.md" > /dev/null; then
    # Move all .md files out of the folder to the current directory
    mv "$dir"*.md ./
    echo "Moved .md files from $dir to the current directory"
  fi

  # Wait for 5 seconds before deleting the folder
  sleep 5

  # Delete the folder after moving the files
  rm -rf "$dir"
  echo "Deleted folder $dir"
done
