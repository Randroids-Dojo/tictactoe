#!/bin/bash

# Simple script to serve the web export of the TicTacToe game
# This avoids browser security restrictions when opening files directly

# Check if we have http-server installed
if ! command -v http-server &> /dev/null; then
    echo "http-server is not installed. Would you like to install it? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        npm install -g http-server
    else
        echo "Please install http-server or another web server to serve the game."
        exit 1
    fi
fi

# Navigate to export directory
cd export/web || {
    echo "Error: export/web directory not found."
    echo "Please export the game first using the Godot Editor."
    exit 1
}

# Start http-server
echo "Starting web server at http://localhost:8080"
echo "Open this URL in your browser to play the game"
echo "Press Ctrl+C to stop the server"
http-server -p 8080 --cors