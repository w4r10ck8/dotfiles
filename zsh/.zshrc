# =============================================================================
# ZSH Configuration
# =============================================================================

# Path configuration - ensure system paths are first
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/bin:$PATH"

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Lazy NVM loading (speeds up shell startup)
export NVM_DIR="$HOME/.nvm"
nvm() {
  unfunction nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

# Application configurations
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"

# Oh My Zsh plugins
plugins=(
  git
  bundler
  # dotenv  # Temporarily disabled due to PATH issues
  macos
  rake
  rbenv
  ruby
  zsh-autosuggestions
  f-sy-h
)

# Theme configuration (uncomment if using Powerlevel10k)
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# Aliases
# =============================================================================

# =============================================================================
# Custom FZF Functions
# =============================================================================

# 🚀 Project Switcher - Switch between your projects with fzf
fzf_projects() {
  local projects=(
    "$DEV_PROJECTS/spellbook:p.spellbook"
    "$DEV_PROJECTS/judgement:p.judgement"
    "$DEV_PROJECTS/folio:p.folio"
    "$DEV_PROJECTS/bean-there:p.bt"
    "$DEV_PROJECTS/configs:p.config"
    "$DEV_PROJECTS/advent-of-code:p.adc"
    "$DEV_EXCO/my.fwc:p.fwc"
    "$DEV_EXCO/csp-npm/csp-npm:p.ncp"
    "$DEV_EXCO/script-csp-repairo:p.repair"
  )
  
  local selected=$(printf '%s\n' "${projects[@]}" | \
    awk -F: '{print $2 " → " $1}' | \
    fzf --prompt="🚀 Projects: " \
        --header="Select a project to navigate to" \
        --preview='ls -la {2}' \
        --preview-window=right:50% | \
    awk '{print $1}')
  
  if [[ -n $selected ]]; then
    eval "$selected"
  fi
}

# 📁 Smart cd with fzf - Navigate to any directory quickly
fzf_cd() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git . "${1:-$HOME}" | fzf --prompt="📁 Dir: " --header="Navigate to directory") && cd "$dir"
}

# 📝 File finder with preview - Find and edit files
fzf_edit() {
  local file
  file=$(fzf --prompt="📝 Edit: " \
             --header="Select file to edit" \
             --preview='bat --style=numbers --color=always --line-range :300 {}' \
             --preview-window=right:60%) && nvim "$file"
}

# 🌳 Git branch switcher
fzf_git_branch() {
  local branch
  branch=$(git branch --all | grep -v HEAD | sed 's/^[* ] //' | sed 's/^remotes\///' | sort -u | fzf --prompt="🌳 Branch: " --header="Switch git branch") && git checkout "$branch"
}

# 📊 Git log with fzf
fzf_git_log() {
  git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" | \
  fzf --ansi --no-sort --reverse --tiebreak=index \
      --prompt="📊 Commits: " \
      --header="Browse git history" \
      --preview="git show --color=always {2}" \
      --bind="enter:execute(git show {2} | less -R)"
}

# 🔍 Live grep with fzf
fzf_grep() {
  if command -v rg >/dev/null 2>&1; then
    rg --line-number --no-heading --color=always --smart-case "${1:-}" |
      fzf --ansi \
          --color "hl:-1:underline,hl+:-1:underline:reverse" \
          --delimiter : \
          --prompt="🔍 Search: " \
          --header="Live grep search" \
          --preview 'bat --color=always {1} --highlight-line {2}' \
          --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
          --bind 'enter:become(nvim {1} +{2})'
  else
    echo "ripgrep (rg) not installed. Install with: brew install ripgrep"
  fi
}

# 🏠 Tmux session manager
fzf_tmux() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --prompt="🏠 Tmux: " --header="Select or create tmux session")
  if [[ -n $session ]]; then
    tmux attach-session -t "$session"
  fi
}

# 📦 Package.json script runner
fzf_npm() {
  if [[ -f package.json ]]; then
    local script
    script=$(cat package.json | jq -r '.scripts | keys[]' 2>/dev/null | fzf --prompt="📦 NPM: " --header="Run npm script")
    if [[ -n $script ]]; then
      npm run "$script"
    fi
  else
    echo "No package.json found in current directory"
  fi
}

# 🎯 Kill process with fzf
fzf_kill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m --prompt="🎯 Kill: " --header="Select process to kill" | awk '{print $2}')
  if [[ -n $pid ]]; then
    echo "$pid" | xargs kill -"${1:-9}"
  fi
}

# FZF aliases
alias fp="fzf_projects"           # Project switcher
alias ff="fzf_edit"               # File finder & editor
alias fcd="fzf_cd"                # Directory navigator
alias fg="fzf_grep"               # Live grep search
alias fb="fzf_git_branch"         # Git branch switcher
alias fl="fzf_git_log"            # Git log browser
alias ft="fzf_tmux"               # Tmux session manager
alias fn="fzf_npm"                # NPM script runner
alias fk="fzf_kill"               # Process killer
alias fps="fzf-processes"         # Process killer (full UI)
alias fnp="fzf-node-ports"        # Node process port killer
alias fgc="fzf-git-commits"       # Git commit browser
alias z.help="zhelp"              # ZSH cheat sheet

# Enhanced directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# General aliases
alias cls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll="eza --color=always --long --git --icons=always"
alias la="eza --color=always --long --git --icons=always --all"
alias lt="eza --color=always --tree --icons=always"
alias or="omz reload"
alias myip='ipconfig getifaddr en0'
alias kode="nvim ."
alias lg="lazygit"

# Configuration file aliases
alias config.zsh="cd ~/ && nvim .zshrc"
alias config.dotfiles="cd ~/dotfiles && nvim ."
alias config.nvim="cd ~/.config/nvim/ && nvim ."
alias config.tmux="cd ~/.config/tmux/ && nvim ."
alias config.aerospace="cd ~/.config/aerospace/ && nvim ."
alias config.starship="cd ~/.config/ && nvim starship.toml"
alias config.ghostty="cd ~/.config/ghostty/ && nvim config"
alias config.lazygit="cd ~/.config/lazygit/ && nvim config"

# Git aliases
alias g.s.cp="git diff --staged | pbcopy" # git staged copy
alias g.s="git diff --staged"            # git staged

# Node version file creation
alias w.nvmrc="node -v > .nvmrc"

# Package manager aliases
# PNPM
alias pd="pnpm dev"
alias pst="pnpm storybook"
alias pt="pnpm test"
alias pv="pnpm validate"
alias pi="pnpm i"
alias pb="pnpm build"

# NPM
alias nd="npm run dev"
alias ns="npm run storybook"
alias nt="npm run test"
alias nv="npm run validate"
alias ni="npm i"
alias nb="npm run build"

# Bun
alias bd="bun run dev"
alias bst="bun run storybook"  # renamed to avoid conflict
alias bt="bun run test"
alias bv="bun run validate"
alias bi="bun i"
alias bb="bun run build"
alias bstart="bun run start"   # renamed for clarity



# =============================================================================
# Project Management System
# =============================================================================

# Base directory paths
DEV_BASE="$HOME/Developer"
DEV_PROJECTS="$DEV_BASE/Projects"
DEV_EXCO="$DEV_BASE/exco-partners"
DEV_ANOOP="$DEV_BASE/anoop"
MUGGLEBORN_PROJECTS="$DEV_BASE/muggleborn.dev"

# Directory aliases (d.*)
alias d.dev="cd $DEV_BASE"
alias d.projects="cd $DEV_PROJECTS"
alias d.exco="cd $DEV_EXCO"
alias d.mbd="cd $MUGGLEBORN_PROJECTS"
alias d.anoop="cd $DEV_ANOOP"

# Helper function for project aliases with enhanced messaging
project_cd() {
    local path="$1"
    local use_nvm="${2:-false}"
    
    # Check if directory exists
    if [[ ! -d "$path" ]]; then
        echo "❌ \033[91mDirectory not found:\033[0m $path"
        return 1
    fi
    
    cd "$path"
    echo "📁 \033[92mSwitched to:\033[0m \033[94m$path\033[0m"
    
    # Check for various project files and show info
    if [[ -f "package.json" ]]; then
        # Pure zsh parsing using parameter expansion
        local json_content=$(< package.json)
        local project_name="Unknown"
        local project_version="Unknown"
        
        # Extract name using zsh parameter expansion
        if [[ $json_content =~ '"name"[[:space:]]*:[[:space:]]*"([^"]+)"' ]]; then
            project_name=${match[1]}
        fi
        
        # Extract version using zsh parameter expansion  
        if [[ $json_content =~ '"version"[[:space:]]*:[[:space:]]*"([^"]+)"' ]]; then
            project_version=${match[1]}
        fi
        
        echo "📦 \033[93mNode.js project:\033[0m $project_name \033[90mv$project_version\033[0m"
    fi
    
    if [[ -f "Cargo.toml" ]]; then
        echo "🦀 \033[93mRust project detected\033[0m"
    fi
    
    if [[ -f "go.mod" ]]; then
        echo "🐹 \033[93mGo project detected\033[0m"
    fi
    
    if [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]] || [[ -f "setup.py" ]]; then
        echo "🐍 \033[93mPython project detected\033[0m"
    fi
    
    # Handle NVM switching with better messaging
    if [[ "$use_nvm" == "true" && -f .nvmrc ]]; then
        # Read .nvmrc file using built-in shell functionality
        local required_version
        read -r required_version < .nvmrc 2>/dev/null || required_version="Unknown"
        # Clean up the version string using parameter expansion
        required_version=${required_version//[^a-zA-Z0-9.]/}
        [[ -n "$required_version" ]] || required_version="Unknown"
        echo "🔄 \033[96mNode version file found, switching to Node $required_version...\033[0m"
        
        # Clean PATH temporarily to ensure system commands work
        local old_path="$PATH"
        export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/homebrew/bin"
        
        # Show our enhanced message first
        echo "🔍 \033[96mFound .nvmrc with version <$required_version>\033[0m"
        
        # Try to use nvm (it should already be loaded in the shell)
        if command -v nvm >/dev/null 2>&1 && nvm use >/dev/null 2>&1; then
            # Restore PATH and get version info
            export PATH="$old_path"
            local current_version=$(nvm current 2>/dev/null)
            local npm_version=$(npm --version 2>/dev/null)
            
            if [[ -n "$current_version" && -n "$npm_version" ]]; then
                echo "🚀 \033[92mNow using node $current_version (npm v$npm_version)\033[0m"
                echo "✅ \033[92mSuccessfully switched to Node $current_version\033[0m"
            else
                echo "✅ \033[92mSuccessfully switched to Node $required_version\033[0m"
            fi
        else
            # Restore PATH and show error
            export PATH="$old_path"
            echo "❌ \033[91mCould not switch to Node $required_version. Please run 'nvm use' manually.\033[0m"
        fi
    fi
    
    # Show git branch if in a git repository
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git branch --show-current 2>/dev/null)
        local git_changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        if [[ -n "$branch" ]]; then
            if [[ "$git_changes" -gt 0 ]]; then
                echo "🌿 \033[93mGit branch:\033[0m \033[94m$branch\033[0m \033[91m($git_changes changes)\033[0m"
            else
                echo "🌿 \033[93mGit branch:\033[0m \033[94m$branch\033[0m \033[92m(clean)\033[0m"
            fi
        fi
    fi
}

# Simple projects (no NVM)
alias p.config="project_cd '$DEV_PROJECTS/configs'"
alias p.adc="project_cd '$DEV_PROJECTS/advent-of-code'"

# Node projects (with NVM)
alias p.judgement="project_cd '$DEV_PROJECTS/judgement' true"
alias p.bt="project_cd '$DEV_PROJECTS/bean-there' true"
alias p.an="project_cd '$DEV_PROJECTS/azure-nimbus' true"

# Muggleborn.dev project (with NVM)
alias p.spellbook="project_cd '$MUGGLEBORN_PROJECTS/spellbook' true"
alias p.folio="project_cd '$MUGGLEBORN_PROJECTS/folio' true"
alias p.howler="project_cd '$MUGGLEBORN_PROJECTS/howler' true"
alias p.obliviate="project_cd '$MUGGLEBORN_PROJECTS/obliviate' true"
alias p.gringotts="project_cd '$MUGGLEBORN_PROJECTS/gringotts' true"

# Exco projects (with NVM)
alias p.fwc="project_cd '$DEV_EXCO/my.fwc' true"
alias p.ncp="project_cd '$DEV_EXCO/csp-npm/csp-npm' true"
alias p.repair="project_cd '$DEV_EXCO/script-csp-repairo' true"

# Anoop's projects
alias p.anoop="project_cd '$DEV_ANOOP' true"
alias p.modak-fiji="project_cd '$DEV_ANOOP/anoop-modak-group-fiji' true"

# Tmux variants for Node/Exco projects  
tmux_project() {
    local project_alias="$1"
    eval "$project_alias"
    if [[ $? -eq 0 ]]; then
        tmux new-session -s "$(basename $(pwd))" 2>/dev/null || tmux attach-session -t "$(basename $(pwd))"
    fi
}

alias t.p.spellbook="tmux_project p.spellbook"
alias t.p.judgement="tmux_project p.judgement"  
alias t.p.folio="tmux_project p.folio"
alias t.p.bt="tmux_project p.bt"
alias t.p.fwc="tmux_project p.fwc"
alias t.p.ncp="tmux_project p.ncp"
alias t.p.repair="tmux_project p.repair"
alias t.p.ad="tmux_project p.ad"

# =============================================================================
# Environment Variables & Tokens
# =============================================================================

# Uncomment and add your tokens when needed
# export GITHUB_OAUTH_TOKEN=""
# export GITHUB_TOKEN="${GITHUB_OAUTH_TOKEN}"
# export NPM_TOKEN=""

# Android development paths (uncomment if needed)
# export ANDROID_HOME="$HOME/Library/Android/sdk"
# export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
# export ANDROID_AVD_HOME="$HOME/.android/avd"

# =============================================================================
# FZF Integration & Custom Functions
# =============================================================================

# Initialize fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Set FZF colors to Tokyo Night theme
export FZF_DEFAULT_OPTS="
  --color=fg:#c0caf5,bg:#1a1b26,hl:#7aa2f7
  --color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
  --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
  --border --height 60% --layout=reverse
  --prompt='❯ ' --pointer='❯' --marker='❯'
  --bind 'ctrl-a:select-all'
  --bind 'ctrl-y:execute-silent(echo {} | pbcopy)'
  --bind 'ctrl-e:execute(echo {+} | xargs -o nvim)'
  --bind 'ctrl-v:execute(code {+})'
"

# Set FZF to use fd for file search (faster and respects .gitignore)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# FZF function to find and switch to project directories
function fzf-project-widget() {
  local selected
  selected=$(find ~/Projects ~/work ~/dev ~/Developer -type d -name ".git" 2>/dev/null |
    sed 's|/.git||' |
    sed "s|$HOME|~|" |
    sort |
    fzf --header="📁 Select Project to Switch To" \
        --prompt="❯ " \
        --preview="eza --tree --level=2 --color=always {} 2>/dev/null || ls -la {}" \
        --preview-window=right:50%:wrap \
        --height=80%)

  if [[ -n $selected ]]; then
    selected=${selected/#\~/$HOME}
    local use_nvm="false"
    [[ -f "$selected/.nvmrc" ]] && use_nvm="true"
    project_cd "$selected" "$use_nvm"
    zle reset-prompt
  else
    echo "🚫 \033[90mProject selection cancelled\033[0m"
    zle reset-prompt
  fi
}
zle -N fzf-project-widget

# FZF function to find files in current directory with enhanced messaging
function fzf-file-widget() {
  echo "🔍 \033[96mSearching for files in current directory...\033[0m"
  
  local selected
  selected=$(fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .DS_Store | 
    fzf --header="📄 Select File to Insert in Command Line" \
        --prompt="❯ " \
        --preview="bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || head -20 {}" \
        --preview-window=right:60%:wrap \
        --height=80%)
  
  if [[ -n $selected ]]; then
    echo "📄 \033[92mSelected file:\033[0m \033[94m$selected\033[0m"
    LBUFFER="${LBUFFER}${selected}"
    zle reset-prompt
  else
    echo "🚫 \033[90mFile selection cancelled\033[0m"
    zle reset-prompt
  fi
}
zle -N fzf-file-widget

# FZF function to search git commits with enhanced messaging
function fzf-git-commits() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ \033[91mNot in a git repository\033[0m"
    return 1
  fi
  
  echo "🔍 \033[96mSearching git commits...\033[0m"
  
  local selected
  selected=$(git log --oneline --color=always --all --graph | 
    fzf --ansi --no-sort --reverse --tiebreak=index \
        --header="🔍 Git Commits - Press Enter to View Details" \
        --prompt="❯ " \
        --preview="echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs git show --color=always" \
        --preview-window=right:60%:wrap \
        --height=80%)
  
  if [[ -n $selected ]]; then
    local commit_hash=$(echo "$selected" | grep -o '[a-f0-9]\{7\}' | head -1)
    echo "📝 \033[92mSelected commit:\033[0m \033[94m$commit_hash\033[0m"
    git show "$commit_hash"
  else
    echo "🚫 \033[90mCommit selection cancelled\033[0m"
  fi
}

# FZF function to search and manage processes
function fzf-processes() {
  echo "🔍 \033[96mSearching running processes...\033[0m"
  
  local selected
  selected=$(ps aux | grep -v grep | 
    fzf --header="🔄 Running Processes - Press Enter to Kill Process" \
        --prompt="❯ " \
        --height=70% \
        --preview="echo 'Process Details:'; echo {}; echo ''; echo 'Use Enter to kill this process'" \
        --preview-window=down:4:wrap)
  
  if [[ -n $selected ]]; then
    local pid=$(echo "$selected" | awk '{print $2}')
    local process_name=$(echo "$selected" | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}')
    
    echo "⚠️  \033[93mAbout to kill process:\033[0m"
    echo "   PID: \033[94m$pid\033[0m"
    echo "   Process: \033[94m$process_name\033[0m"
    echo -n "❓ \033[96mAre you sure? (y/N):\033[0m "
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      if kill -9 "$pid" 2>/dev/null; then
        echo "✅ \033[92mProcess $pid killed successfully\033[0m"
      else
        echo "❌ \033[91mFailed to kill process $pid\033[0m"
      fi
    else
      echo "🚫 \033[90mProcess kill cancelled\033[0m"
    fi
  else
    echo "🚫 \033[90mProcess selection cancelled\033[0m"
  fi
}

# 🔴 Kill Node process by port with fzf
function fzf-node-ports() {
  local entry
  entry=$(lsof -i -P -n | grep LISTEN | grep -i node |
    awk '{printf "%-8s %-10s %s\n", $9, $2, $1}' |
    fzf --header="PORT         PID        PROCESS" \
        --header-first \
        --prompt="❯ " \
        --height=50%)

  if [[ -n $entry ]]; then
    local pid=$(echo "$entry" | awk '{print $2}')
    local port=$(echo "$entry" | awk '{print $1}')
    echo "🔴 Killing Node process on $port (PID $pid)..."
    kill -9 "$pid" && echo "✅ Killed PID $pid" || echo "❌ Failed to kill PID $pid"
  fi
}

# Quick directory info function with emojis
function qinfo() {
  echo "📂 \033[93mCurrent Directory Info:\033[0m"
  echo "   📍 \033[94mLocation:\033[0m $(pwd)"
  echo "   📊 \033[94mFiles:\033[0m $(find . -maxdepth 1 -type f | wc -l | tr -d ' ') files, $(find . -maxdepth 1 -type d | wc -l | tr -d ' ') directories"
  
  if [[ -f "package.json" ]]; then
    local project_name=$(command jq -r '.name // "Unknown"' package.json 2>/dev/null || echo "Unknown")
    echo "   📦 \033[93mNode.js project:\033[0m $project_name"
  fi
  
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local branch=$(git branch --show-current 2>/dev/null)
    local git_changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    echo "   🌿 \033[93mGit:\033[0m branch \033[94m$branch\033[0m, $git_changes changes"
  fi
  
  if [[ -f ".nvmrc" ]]; then
    local required_version
    read -r required_version < .nvmrc 2>/dev/null || required_version="Unknown"
    required_version=${required_version//[^a-zA-Z0-9.]/}
    echo "   🔄 \033[96mNode version required:\033[0m $required_version"
  fi
}

# Enhanced ls with project info
function lsp() {
  echo "📁 \033[93mDirectory Contents:\033[0m"
  eza --color=always --long --git --icons=always --group-directories-first "$@"
  
  echo ""
  qinfo
}

# Git status with enhanced messaging
function gstatus() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ \033[91mNot in a git repository\033[0m"
    return 1
  fi
  
  echo "🌿 \033[93mGit Status:\033[0m"
  git status --short --branch
  
  local ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
  local behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
  
  if [[ "$ahead" -gt 0 ]]; then
    echo "⬆️  \033[92m$ahead commits ahead of remote\033[0m"
  fi
  
  if [[ "$behind" -gt 0 ]]; then
    echo "⬇️  \033[93m$behind commits behind remote\033[0m"
  fi
  
  if [[ "$ahead" -eq 0 && "$behind" -eq 0 ]]; then
    echo "✅ \033[92mUp to date with remote\033[0m"
  fi
}

# Quick npm/yarn commands with messaging
function ndev() {
  if [[ -f "package.json" ]]; then
    echo "🚀 \033[96mStarting development server...\033[0m"
    npm run dev
  else
    echo "❌ \033[91mNo package.json found in current directory\033[0m"
  fi
}

function nbuild() {
  if [[ -f "package.json" ]]; then
    echo "🏗️  \033[96mBuilding project...\033[0m"
    npm run build
  else
    echo "❌ \033[91mNo package.json found in current directory\033[0m"
  fi
}

function ntest() {
  if [[ -f "package.json" ]]; then
    echo "🧪 \033[96mRunning tests...\033[0m"
    npm run test
  else
    echo "❌ \033[91mNo package.json found in current directory\033[0m"
  fi
}

# 📋 Searchable ZSH cheat sheet
function zhelp() {
  local cheatsheet selected
  cheatsheet=$(cat <<'EOF'
fp                 Project switcher (static list)
Ctrl+P             Project switcher (finds all .git dirs)
ff                 Find and edit a file in nvim
Ctrl+F             Insert file path into command line
fcd                Navigate to any directory
fg                 Live grep search (opens result in nvim)
fb                 Switch git branches
fl                 Browse git log
ft                 Attach to tmux session
fn                 Run npm script
fk                 Kill a process (all processes)
fps                Kill a process (all processes, full UI)
fnp                Kill a Node process by port
fgc                Browse git commits
qinfo              Quick info: dir, git branch, node version
lsp                ls + qinfo combined
gstatus            Git status with ahead/behind counts
ndev               npm run dev (with messaging)
nbuild             npm run build (with messaging)
ntest              npm run test (with messaging)
config.zsh         Edit .zshrc
config.dotfiles    Open ~/dotfiles in nvim
config.nvim        Open nvim config
config.tmux        Open tmux config
config.aerospace   Open aerospace config
config.starship    Edit starship.toml
config.ghostty     Edit ghostty config
config.lazygit     Edit lazygit config
g.s                git diff --staged
g.s.cp             git diff --staged | pbcopy
lg                 lazygit
d.dev              ~/Developer
d.projects         ~/Developer/Projects
d.exco             ~/Developer/exco-partners
d.mbd              ~/Developer/muggleborn.dev
p.spellbook        muggleborn.dev/spellbook
p.folio            muggleborn.dev/folio
p.howler           muggleborn.dev/howler
p.fwc              exco-partners/my.fwc
p.ncp              exco-partners/csp-npm
p.repair           exco-partners/script-csp-repairo
p.judgement        Projects/judgement
p.bt               Projects/bean-there
t.p.*              Same as p.* but opens in tmux session
pd / nd / bd       dev
pt / nt / bt       test
pb / nb / bb       build
pv / nv / bv       validate
pi / ni / bi       install
pst / ns / bst     storybook
EOF
)

  selected=$(echo "$cheatsheet" | \
    fzf --header-first \
        --header="  COMMAND                DESCRIPTION  (Enter to copy)" \
        --prompt="❯ Search: " \
        --height=80%)

  if [[ -n $selected ]]; then
    local cmd=$(echo "$selected" | awk '{print $1}')
    echo "$cmd" | pbcopy
    echo "📋 Copied: $cmd"
  fi
}

# Key bindings for FZF widgets
bindkey '^P' fzf-project-widget  # Ctrl+P for projects
bindkey '^F' fzf-file-widget     # Ctrl+F for files

# =============================================================================
# Initialize Tools
# =============================================================================

# Initialize Starship prompt (should be last)
eval "$(starship init zsh)"
