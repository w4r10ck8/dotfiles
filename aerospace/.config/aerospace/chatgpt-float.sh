#!/bin/bash

# ChatGPT Window Manager
# This script helps manage ChatGPT windows - making quick text boxes float
# while keeping main windows in workspace 6

echo "🤖 Managing ChatGPT windows..."

# Get all ChatGPT windows
chatgpt_windows=$(aerospace list-windows --monitor all --app-bundle-id com.openai.chat --format '%{window-id}|%{window-title}' 2>/dev/null)

if [ -z "$chatgpt_windows" ]; then
    echo "ℹ️  No ChatGPT windows found"
    exit 0
fi

echo "Found ChatGPT windows:"
echo "$chatgpt_windows" | while IFS='|' read -r window_id window_title; do
    echo "  🪟 ID: $window_id - Title: $window_title"
    
    # Check if this looks like a quick text box based on title patterns
    if echo "$window_title" | grep -iE "(quick|input|text|prompt|search|^$)" > /dev/null; then
        echo "    🏃 Making floating (detected as quick text box)"
        aerospace layout --window-id "$window_id" floating 2>/dev/null
    else
        echo "    📋 Moving to workspace 6 (detected as main window)"
        aerospace move-node-to-workspace --window-id "$window_id" 6 2>/dev/null
    fi
done

echo "✅ ChatGPT window management complete!"
