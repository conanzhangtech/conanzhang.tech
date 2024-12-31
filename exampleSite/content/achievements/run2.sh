#!/bin/bash

# Loop through all directories in the current folder
for dir in */; do
  # Remove the trailing slash to get the directory name
  folder_name=$(basename "$dir")
  
  # Check if feature.jpg exists in the folder
  if [ -f "$dir/feature.jpg" ]; then
    # Rename feature.jpg to <folder_name>-1.jpg
    mv "$dir/feature.jpg" "$dir/${folder_name}-1.jpg"
    echo "Renamed $dir/feature.jpg to $dir/${folder_name}-1.jpg"
  fi
  
  # Check if feature.png exists in the folder
  if [ -f "$dir/feature.png" ]; then
    # Rename feature.png to <folder_name>-1.png
    mv "$dir/feature.png" "$dir/${folder_name}-1.png"
    echo "Renamed $dir/feature.png to $dir/${folder_name}-1.png"
  fi
done

