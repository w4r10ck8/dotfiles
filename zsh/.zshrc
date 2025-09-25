# =============================================================================
# ZSH Configuration
# =============================================================================

# Path configuration - ensure system paths are first
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/bin:$PATH"

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Load NVM properly
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Application configurations
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"

# Load NVM properly
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

# Helper functions
tmux_alias(){
  local base_alias="$1"
  alias "t.$base_alias"="$base_alias && tmux"
}

# =============================================================================
# FZF Configuration & Functions
# =============================================================================

# FZF default options with Tokyo Night theme
export FZF_DEFAULT_OPTS="
--color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
--color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
--layout=reverse
--border=rounded
--height=60%
--preview-window=right:50%
--bind='ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'
"

# Use fd for fzf if available (faster than find)
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'
fi

# FZF key bindings and completions
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Custom key bindings (widgets registered after function definitions)
# bindkey '^P' fzf_projects      # Ctrl+P for project switcher  
# bindkey '^F' fzf_edit         # Ctrl+F for file finder
# bindkey '^G' fzf_grep         # Ctrl+G for live grep

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
    "$DEV_EXCO/CustomerPortal:p.cp"
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

# =============================================================================
# FZF Aliases & Key Bindings
# =============================================================================

# Register custom functions as ZLE widgets and bind keys
zle -N fzf_projects
zle -N fzf_edit  
zle -N fzf_grep

# Key bindings for fzf functions
bindkey '^P' fzf_projects      # Ctrl+P for project switcher
bindkey '^F' fzf_edit         # Ctrl+F for file finder
bindkey '^G' fzf_grep         # Ctrl+G for live grep

# Main fzf aliases
alias fp="fzf_projects"           # Project switcher
alias ff="fzf_edit"               # File finder & editor
alias fd="fzf_cd"                 # Directory navigator
alias fg="fzf_grep"               # Live grep search
alias fb="fzf_git_branch"         # Git branch switcher
alias fl="fzf_git_log"            # Git log browser
alias ft="fzf_tmux"               # Tmux session manager
alias fn="fzf_npm"                # NPM script runner
alias fk="fzf_kill"               # Process killer

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
alias ps="pnpm storybook"
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

# Directory aliases (d.*)
alias d.dev="cd $DEV_BASE"
alias d.projects="cd $DEV_PROJECTS"
alias d.exco="cd $DEV_EXCO"

# Helper function for project aliases
project_cd() {
    local path="$1"
    local use_nvm="${2:-false}"
    
    # Ensure proper PATH before any operations  
    export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/homebrew/bin:$PATH"
    
    cd "$path"
    echo "📁 Switched to: $path"
    
    if [[ "$use_nvm" == "true" && -f .nvmrc ]]; then
        echo "� Node version file found, switching Node version..."
        # Try to use nvm directly first, fallback to bash if needed
        if ! nvm use 2>/dev/null; then
            echo "⚠️  NVM direct call failed, trying alternative method..."
            /bin/bash -c "export PATH=\"$PATH\"; source \"$NVM_DIR/nvm.sh\"; nvm use" 2>/dev/null || echo "❌ Could not switch Node version. Run 'nvm use' manually."
        fi
    fi
}

# Simple projects (no NVM)
alias p.config="project_cd '$DEV_PROJECTS/configs'"
alias p.adc="project_cd '$DEV_PROJECTS/advent-of-code'"

# Node projects (with NVM)
alias p.spellbook="project_cd '$DEV_PROJECTS/spellbook' true"
alias p.judgement="project_cd '$DEV_PROJECTS/judgement' true"
alias p.folio="project_cd '$DEV_PROJECTS/folio' true"
alias p.bt="project_cd '$DEV_PROJECTS/bean-there' true"

# Exco projects (with NVM)
alias p.cp="project_cd '$DEV_EXCO/CustomerPortal' true"
alias p.ncp="project_cd '$DEV_EXCO/csp-npm/csp-npm' true"
alias p.repair="project_cd '$DEV_EXCO/script-csp-repairo' true"

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
alias t.p.cp="tmux_project p.cp"
alias t.p.ncp="tmux_project p.ncp"
alias t.p.repair="tmux_project p.repair"

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
  selected=$(find ~/Projects ~/work ~/dev -type d -name ".git" 2>/dev/null | 
    sed 's|/.git||' | 
    sed "s|$HOME|~|" | 
    sort | 
    fzf --header="📁 Select Project" \
        --preview="eza --tree --level=2 --color=always {}" \
        --preview-window=right:50%:wrap)
  
  if [[ -n $selected ]]; then
    # Expand ~ to home directory
    selected=${selected/#\~/$HOME}
    cd "$selected"
    zle reset-prompt
  fi
}
zle -N fzf-project-widget

# FZF function to find files in current directory
function fzf-file-widget() {
  local selected
  selected=$(fd --type f --hidden --follow --exclude .git --exclude node_modules | 
    fzf --header="📄 Select File" \
        --preview="bat --color=always --style=numbers --line-range=:500 {}" \
        --preview-window=right:60%:wrap)
  
  if [[ -n $selected ]]; then
    LBUFFER="${LBUFFER}${selected}"
    zle reset-prompt
  fi
}
zle -N fzf-file-widget

# FZF function to search git commits
function fzf-git-commits() {
  git log --oneline --color=always --all --graph | 
  fzf --ansi --no-sort --reverse --tiebreak=index \
      --header="🔍 Git Commits" \
      --preview="echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs git show --color=always" \
      --preview-window=right:60%:wrap
}

# FZF function to search processes
function fzf-processes() {
  ps aux | 
  fzf --header="🔄 Running Processes" \
      --height=50% \
      --preview="echo {}" \
      --preview-window=down:3:wrap \
      --bind="enter:execute(kill -9 {2})"
}

# Key bindings for FZF widgets
bindkey '^P' fzf-project-widget  # Ctrl+P for projects
bindkey '^F' fzf-file-widget     # Ctrl+F for files

# =============================================================================
# Initialize Tools
# =============================================================================

# Initialize Starship prompt (should be last)
eval "$(starship init zsh)"
