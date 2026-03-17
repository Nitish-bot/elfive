#!/bin/bash

# 1. Check if a folder name was provided
if [ -z "$1" ]; then
    echo "Usage: ./run.sh <folder_name>"
    exit 1
fi

FOLDER_NAME=$1
TARGET_FILE="$FOLDER_NAME/main.lua"

# 2. Check if the folder and main.lua exist
if [ ! -f "$TARGET_FILE" ]; then
    echo "Error: '$TARGET_FILE' not found."
    exit 1
fi

# 3. Copy main.lua to the current directory (root)
cp "$TARGET_FILE" ./main.lua

# 4. Run Love2D
# Note: '.' tells Love to run the current directory
love .

# 5. Clean up: Delete the main.lua from root after Love exits
rm ./main.lua