
# zplug (via nixpkgs)
source ~/.nix-profile/share/zplug/init.zsh

# Plugins
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"

if ! zplug check; then
  zplug install
fi

zplug load

########################
## Prompt
########################

fpath+=($HOME/.nix-profile/share/zsh/site-functions)

autoload -U promptinit; promptinit
prompt pure


########################
## Environment variables
########################

set -o vi

export VISUAL=nvim
export EDITOR=nvim
export TERM="tmux-256color"

export BROWSER="firefox"

########################
## History
########################

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

