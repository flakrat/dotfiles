[ -d ~/.local/bin ] && export PATH=~/.local/bin:${PATH}
[ -d ~/.local/lib ] && export LD_LIBRARY_PATH=~/.local/lib:${LD_LIBRARY_PATH}

#[[ ! -v STARSHIP_SHELL || ! -v STARSHIP_SESSION_KEY ]] && eval "$(starship init zsh)"
eval "$(starship init zsh)"

# Load antigen plugin manager
source ~/antigen.zsh

# Load some plugins
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zdharma-continuum/fast-syntax-highlighting
# Make sure to load zsh-history-substring-search AFTER syntax highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen apply

# Load bash completion functions
# https://stackoverflow.com/questions/69675174/bash-completion-does-not-work-in-zsh-oh-my-zsh-because-comp-words-is-not-an-arra
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'r:|[._-]=** r:|=**' 'l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#
# History Settings
HISTSIZE=1000000
SAVEHIST=1000000
setopt  extendedhistory incappendhistorytime appendhistory histignorespace nomatch interactivecomments

# Enable VI mode
bindkey -v
# https://dougblack.io/words/zsh-vi-mode.html
export KEYTIMEOUT=1

# Bind k and j to history-substring-search up and down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Source .zshrc.local to allow for local configuration
if [ -f $HOME/.zshrc.local ]; then
  source $HOME/.zshrc.local
fi

