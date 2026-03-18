#!/bin/bash

# Check if folder argument is provided
if [ -z "$1" ]; then
    echo "Usage: ./run.sh <folder_name>"
    exit 1
fi

FILE=$1
SOURCE="examples/$FILE.lua"
DEST="./main.lua"

# Validation
if [ ! -f "$SOURCE" ]; then
    echo "Error: $SOURCE not found!"
    exit 1
fi

# Initial Sync
cp "$SOURCE" "$DEST"

# Start the watcher in the background
# -q (quiet), -m (monitor), -e modify (event)
inotifywait -q -m -e modify "$SOURCE" | while read -r line; do
    cp "$SOURCE" "$DEST"
    echo "Synced change from $SOURCE at $(date +%H:%M:%S)"
done &

WATCHER_PID=$!

# Run Love2D
echo "Watcher active (PID: $WATCHER_PID). Launching LÖVE..."
love .

kill $WATCHER_PID 2>/dev/null
rm -f "$DEST"