#!/bin/bash

# Define the target directory
target_dir="../../assets/images/achievements/"

# Create the target directory if it doesn't exist
mkdir -p "$target_dir"

# Loop through all directories in the current folder
for dir in */; do
  # Move all .jpg files to the target directory
  if compgen -G "$dir*.jpg" > /dev/null; then
    mv "$dir"*.jpg "$target_dir"
    echo "Moved .jpg files from $dir to $target_dir"
  fi
  
  # Move all .png files to the target directory
  if compgen -G "$dir*.png" > /dev/null; then
    mv "$dir"*.png "$target_dir"
    echo "Moved .png files from $dir to $target_dir"
  fi
  
  # Move all .jpeg files to the target directory
  if compgen -G "$dir*.jpeg" > /dev/null; then
    mv "$dir"*.jpeg "$target_dir"
    echo "Moved .jpeg files from $dir to $target_dir"
  fi
done
