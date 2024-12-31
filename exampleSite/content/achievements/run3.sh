#!/bin/bash

# Loop through all directories in the current folder
for dir in */; do
  # Remove the trailing slash to get the directory name
  folder_name=$(basename "$dir")
  
  # Check if credential1.jpg exists in the folder
  if [ -f "$dir/credential1.jpg" ]; then
    # Rename credential1.jpg to <folder_name>-2.jpg
    mv "$dir/credential1.jpg" "$dir/${folder_name}-2.jpg"
    echo "Renamed $dir/credential1.jpg to $dir/${folder_name}-2.jpg"
  fi

  # Check if credential1.png exists in the folder
  if [ -f "$dir/credential1.png" ]; then
    # Rename credential1.png to <folder_name>-2.png
    mv "$dir/credential1.png" "$dir/${folder_name}-2.png"
    echo "Renamed $dir/credential1.png to $dir/${folder_name}-2.png"
  fi
done
