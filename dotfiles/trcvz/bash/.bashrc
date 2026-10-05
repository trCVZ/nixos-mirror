#!/usr/bin/env bash
# ~/.bashrc — interactive Bash configuration
# This file is *sourced*, not executed; the shebang above is kept only
# so editors/tooling can detect the filetype and apply syntax highlighting.

# ======================================
# Interactive shell only
# ======================================
case $- in
    *i*) ;;
      *) return ;;
esac

# ======================================
# XDG Base Directory
# ======================================
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# ======================================
# User directories
# (fallback only — prefer xdg.userDirs via home-manager / xdg-user-dirs,
#  which will already export these; ":-" avoids overriding them here)
# ======================================
export XDG_DESKTOP_DIR="${XDG_DESKTOP_DIR:-$HOME/Desktop}"
export XDG_DOCUMENTS_DIR="${XDG_DOCUMENTS_DIR:-$HOME/Documents}"
export XDG_DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"
export XDG_MUSIC_DIR="${XDG_MUSIC_DIR:-$HOME/Music}"
export XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
export XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR:-$HOME/Videos}"

# ======================================
# Editor
# ======================================
if command -v nvim &>/dev/null; then
    export EDITOR="nvim"
elif command -v vim &>/dev/null; then
    export EDITOR="vim"
else
    export EDITOR="nano"
fi
export VISUAL="$EDITOR"

# ======================================
# Pager
# ======================================
export PAGER="less"
export LESS='-R -F -X'
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

# Colored man pages (via less)
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# ======================================
# History
# ======================================
export HISTFILE="$XDG_STATE_HOME/bash/history"
mkdir -p "$XDG_STATE_HOME/bash" "$XDG_STATE_HOME/less"

HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL="ignoreboth:erasedups"
HISTTIMEFORMAT="%F %T "
HISTIGNORE="ls:ll:la:pwd:clear:history:cd:exit"

# ======================================
# Bash options
# ======================================
shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s histappend
shopt -s cmdhist
shopt -s globstar
shopt -s extglob
shopt -s no_empty_cmd_completion

# ======================================
# Readline / completion behaviour
# ======================================
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "set colored-stats on"
bind "set colored-completion-prefix on"
bind "set mark-symlinked-directories on"
# bash-completion is best enabled declaratively on NixOS via
# home-manager: programs.bash.enableCompletion = true;
# so it is not sourced manually here.

# ======================================
# Colour / capability detection
# ======================================
color_prompt=
if [[ -t 1 ]] && tput setaf 1 &>/dev/null; then
    color_prompt=yes
fi

set_title=
case "$TERM" in
    xterm*|rxvt*|alacritty*|kitty*|foot*|screen*|tmux*)
        set_title=yes
        ;;
esac

# ======================================
# Prompt helpers
# ======================================
__last_exit_code=0

__save_prompt_state() {
    __last_exit_code=$?
    history -a
    history -n
}

# Single fast path: at most 2 git invocations instead of 4-5.
__git_prompt() {
    local branch porcelain symbols=""
    branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) \
        || branch=$(git rev-parse --short HEAD 2>/dev/null) \
        || return
    porcelain=$(git status --porcelain 2>/dev/null)
    grep -q '^[MADRC]' <<<"$porcelain" && symbols+="+"   # staged
    grep -q '^.[MD]'   <<<"$porcelain" && symbols+="*"   # unstaged
    grep -q '^??'      <<<"$porcelain" && symbols+="?"   # untracked
    printf '  %s%s' "$branch" "$symbols"
}

# PS1 is rebuilt fully on every prompt so that dynamic colours
# (exit status, git segment) stay correctly wrapped in \[ \] markers.
__build_prompt() {
    local git_info status_symbol status_color

    git_info=$(__git_prompt)

    if [[ $__last_exit_code -eq 0 ]]; then
        status_symbol="✓"
        status_color='\[\e[1;32m\]'
    else
        status_symbol="✗ $__last_exit_code"
        status_color='\[\e[1;31m\]'
    fi

    if [[ -n "$color_prompt" ]]; then
        PS1='\n'
        PS1+='\[\e[1;34m\]\u@\h\[\e[0m\] '
        PS1+='\[\e[1;32m\]\w\[\e[0m\]'
        PS1+="\[\e[1;35m\]${git_info}\[\e[0m\]"
        PS1+='\n'
        PS1+="${status_color}${status_symbol}\[\e[0m\] "
        PS1+='\[\e[1;36m\]❯\[\e[0m\] '
    else
        PS1="\n\u@\h \w${git_info}\n${status_symbol} > "
    fi

    if [[ -n "$set_title" ]]; then
        PS1='\[\e]0;\u@\h: \w\a\]'"$PS1"
    fi
}

PROMPT_COMMAND="__save_prompt_state; __build_prompt"

# ======================================
# Aliases
# ======================================
#alias ls='ls --color=auto'
alias ll='ls -lh --color=auto'
#alias la='ls -lAh --color=auto'
#alias grep='grep --color=auto'
#alias diff='diff --color=auto'
#alias ..='cd ..'
#alias ...='cd ../..'
#alias mkdir='mkdir -pv'
#alias rm='rm -I'
#alias cp='cp -i'
#alias mv='mv -i'
#alias reload='exec "$BASH"'


# Redirige les données de logiciels tiers vers les répertoires XDG,
# d'après le tableau "Support" de la page ArchWiki "XDG Base Directory".
# À sourcer depuis ~/.bashrc (après la section "XDG Base Directory").
#
# Rappel des 3 catégories du wiki :
#   Supported  -> l'appli regarde déjà le bon chemin XDG, il suffit d'y
#                 déplacer les anciennes données (aucune variable requise).
#   Partial    -> l'appli a besoin qu'on lui indique le chemin via une
#                 variable d'environnement (ci-dessous).
#   Hardcoded  -> aucune relocalisation supportée en amont ; rien à faire.

# --- Rust : cargo / rustup ------------------------------------------
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# --- Docker CLI -------------------------------------------------------
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# --- GitHub Copilot CLI -----------------------------------------------
export COPILOT_HOME="$XDG_CONFIG_HOME/copilot"

# --- Java : uniquement les préférences utilisateur ---------------------
# (~/.java/fonts reste hardcodé en amont, rien à faire pour ça)
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"

# --- Maven (~/.m2) ------------------------------------------------------
export MAVEN_OPTS="-Dmaven.repo.local=$XDG_DATA_HOME/maven/repository"
export MAVEN_ARGS="--settings $XDG_CONFIG_HOME/maven/settings.xml"

# --- Jupyter (couvre les anciennes et nouvelles versions de jupyter-core) --
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_PLATFORM_DIRS="1"

# --- Node.js : historique du REPL ----------------------------------------
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"

# --- npm : fichier de config utilisateur ---------------------------------
# (le contenu de prefix/cache/logs-dir est généré par xdg-migrate.sh)
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# --- Python : historique REPL (nécessite Python >= 3.13) ----------------
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"

# --- redis-cli ------------------------------------------------------------
export REDISCLI_HISTFILE="$XDG_DATA_HOME/redis/rediscli_history"
export REDISCLI_RCFILE="$XDG_CONFIG_HOME/redis/redisclirc"

# --- TeX Live ---------------------------------------------------------------
export TEXMFHOME="$XDG_DATA_HOME/texmf"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"

# --- X11 Compose (accents / caractères spéciaux) ---------------------------
export XCOMPOSEFILE="$XDG_CONFIG_HOME/X11/xcompose"
export XCOMPOSECACHE="$XDG_CACHE_HOME/X11/xcompose"
