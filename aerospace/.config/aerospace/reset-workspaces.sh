#!/bin/bash

# AeroSpace Workspace Reset Script
# This script moves all windows back to their designated workspaces
# and follows focus to the workspace of the currently focused window

echo "🚀 Resetting all windows to their designated workspaces..."

# Store the currently focused window before moving
current_focused_window=$(aerospace list-windows --focused --format '%{window-id}' 2>/dev/null)
current_focused_app=$(aerospace list-windows --focused --format '%{app-bundle-id}' 2>/dev/null)

# Function to safely move windows
move_windows() {
    local app_id=$1
    local workspace=$2
    local app_name=$3
    
    window_ids=$(aerospace list-windows --monitor all --app-bundle-id "$app_id" --format '%{window-id}' 2>/dev/null)
    if [ -n "$window_ids" ]; then
        echo "📱 Moving $app_name windows to workspace $workspace"
        echo "$window_ids" | xargs -I {} aerospace move-node-to-workspace --window-id {} "$workspace" 2>/dev/null
        
        # If this app contains the currently focused window, remember its target workspace
        if [ "$app_id" = "$current_focused_app" ]; then
            target_workspace=$workspace
        fi
    fi
}

# Move apps to their designated workspaces
move_windows "com.microsoft.VSCode" 1 "VS Code"
move_windows "com.apple.Terminal" 1 "Terminal"
move_windows "com.googlecode.iterm2" 1 "iTerm2"
move_windows "com.mitchellh.ghostty" 1 "Ghostty"
move_windows "com.openai.chat" 2 "ChatGPT"
move_windows "com.anthropic.claudefordesktop" 2 "Claude"
move_windows "com.apple.finder" 3 "Finder"
move_windows "com.apple.Preview" 3 "Preview"
move_windows "com.apple.QuickTimePlayerX" 3 "QuickTime Player"
move_windows "md.obsidian" 4 "Obsidian"
move_windows "company.thebrowser.Browser" 5 "Arc Browser"
move_windows "com.google.Chrome" 5 "Chrome"
move_windows "com.apple.Music" 7 "Music"
move_windows "com.spotify.client" 7 "Spotify"
move_windows "com.microsoft.teams2" 8 "Microsoft Teams"

# Set floating apps to floating layout
echo "🏃 Setting floating apps to floating layout"
aerospace list-windows --monitor all --app-bundle-id cc.ffitch.shottr --format '%{window-id}' 2>/dev/null | xargs -I {} aerospace layout --window-id {} floating 2>/dev/null || true
aerospace list-windows --monitor all --app-bundle-id com.superduper.superwhisper --format '%{window-id}' 2>/dev/null | xargs -I {} aerospace layout --window-id {} floating 2>/dev/null || true

# Follow focus to the workspace where the current window was moved
if [ -n "$target_workspace" ]; then
    echo "🎯 Following focus to workspace $target_workspace (where your current app moved)"
    sleep 0.2  # Small delay to ensure windows have moved
    aerospace workspace "$target_workspace"
fi

echo "✅ Workspace reset complete!"
echo ""
echo "📋 Workspace Layout:"
echo "   1: Code + Terminal (VS Code, Ghostty, iTerm2)"
echo "   2: AI (ChatGPT, Claude)"
echo "   3: File Management (Finder, Preview, QuickTime)"
echo "   4: Obsidian"
echo "   5: Web Browsers (Arc, Chrome)"
echo "   7: Media (Music, Spotify)"
echo "   8: Communication (Teams)"
