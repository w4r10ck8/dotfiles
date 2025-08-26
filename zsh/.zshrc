export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"

plugins=(
  git
  bundler
  dotenv
  macos
  rake
  rbenv
  ruby
  zsh-autosuggestions
  f-sy-h
)
# ZSH_THEME="powerlevel10k/powerlevel10k"
source $ZSH/oh-my-zsh.sh

# Aliases

tmux_alias(){
  local base_alias="$1"
  alias "t.$base_alias"="$base_alias && tmux"
}
alias cls="colorls"
alias or="omz reload"

alias config.zsh="cd ~/ && nvim .zshrc"
alias config.dotfiles="cd ~/dotfiles && nvim ."
alias config.nvim="cd ~/.config/nvim/ && nvim ."
alias config.tmux="cd ~/.config/tmux/ && nvim ."
alias config.aerospace="cd ~/.config/aerospace/ && nvim ."
alias config.starship="cd ~/.config/ && nvim starship.toml"
alias config.ghostty="cd ~/.config/ghostty/ && nvim config"
alias config.lazygit="cd ~/.config/lazygit/ && nvim config"

alias kode="nvim ."
alias w.nvmrc="node -v > .nvmrc"
alias lg="lazygit"
alias g.s.cp="git diff --staged | pbcopy" # g: git, s: stage, cp: copy
alias g.s="git diff --staged" # g: git, s: stage, cp: copy

alias fz="fzf"
alias myip='ipconfig getifaddr en0'

## pnpm aliases
alias pd="pnpm dev"
alias ps="pnpm storybook"
alias pt="pnpm test"
alias pv="pnpm validate"
alias pi="pnpm i"
alias pb="pnpm build"

## pnpm aliases
alias nd="npm dev"
alias ns="npm storybook"
alias nt="npm test"
alias v="npm validate"
alias pi="npm i"
alias nb="npm build"

## bun aliases
alias bd="bun dev"
alias bs="bun storybook"
alias bt="bun test"
alias bv="bun validate"
alias bi="bun i"
alias bb="bun build"



## Project's aliases
alias projects="cd ~/Developer/Projects"
alias w.prj="cd ~/Developer/Exco_Partners/"
alias p.config='cd ~/Developer/Projects/configs/'
alias p.spellbook="cd ~/Developer/Projects/spellbook/ && nvm use"
alias p.judgement="cd ~/Developer/Projects/judgement/ && nvm use"
alias p.cp="~/Developer/Exco_Partners/CustomerPortal && nvm use"
alias p.folio="~/Developer/Projects/folio/ && nvm use"
alias p.bt="~/Developer/Projects/bean-there/ && nvm use"
alias p.ncp="~/Developer/Exco_Partners/csp-npm/ && nvm use"
alias p.adc="~/Developer/Projects/advent-of-code/"

## Tmux Aliases
tmux_aliases=(p.spellbook p.judgement p.cp p.folio p.bt p.ncp)
for alias_name in "${tmux_aliases[@]}"; do
  tmux_alias "$alias_name"
done

# Tokens
# export GITHUB_OAUTH_TOKEN= # github token
# export GITHUB_TOKEN=${GITHUB_OAUTH_TOKEN}
# export NPM_TOKEN= # npm token

# Paths
# export ANDROID_HOME=~/Library/Android/sdk
# export ANDROID_SDK_ROOT=~/Library/Android/sdk
# export ANDROID_AVD_HOME=~/.android/avd


eval "$(starship init zsh)"
