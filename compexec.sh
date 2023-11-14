#!/bin/bash

# Check if an argument (file) is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

# Check if the provided argument is a file
if [ -f "$1" ]; then
  # Use the 'basename' command to extract and print the file name
  filename=$(basename "$1")
  gfortran $filename -o out.a
  ./out.a
else
  echo "Error: '$1' is not a valid file."
  exit 1
fi
