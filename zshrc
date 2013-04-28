# The following lines were added by compinstall
# 
# remember to ln -s ~/.zshrc ~/.zshrc.zni

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' prompt '%e'
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install

bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

# some env 
export PATH="$PATH:$HOME/.gem/ruby/1.9.1/bin"
export EDITOR="vim"

# aliases
alias ls='ls --color=always'
alias ll='ls -l'

alias grep='grep --color=always'

# GIT ?
export PS1="%d %# "
