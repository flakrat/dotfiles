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
antigen apply

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'r:|[._-]=** r:|=**' 'l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle :compinstall filename '/home/mhanby_/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTSIZE=1000000
SAVEHIST=1000000
#setopt extendedhistory incappendhistorytime appendhistory extendedglob nomatch
setopt  extendedhistory incappendhistorytime appendhistory histignorespace nomatch interactivecomments

bindkey -v

# https://dougblack.io/words/zsh-vi-mode.html
export KEYTIMEOUT=1

# Source .zshrc.local to allow for local configuration
if [ -f $HOME/.zshrc.local ]; then
  source $HOME/.zshrc.local
fi

