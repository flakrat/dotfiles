# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# The following lines were added by compinstall

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
setopt extendedhistory incappendhistorytime appendhistory nomatch

bindkey -v
# End of lines configured by zsh-newuser-install

# Enable DEBUG
#set -x

#export POWERLEVEL9K_MODE='awesome-fontconfig'
export POWERLEVEL9K_MODE='nerdfont-complete'

# Disable the right prompt, sucks for copy and paste into tickets
export POWERLEVEL9K_DISABLE_RPROMPT=true
# Default Left and Right prompts, I'm combining them bc I routinely copy and paste from the
# command line into notes / support tickets and the RPROMT doesn't paste well
#         POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
#         POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon status context date time dir virtualenv vcs newline)

# Set the date format for the prompt to YYYYMMDD format (default is %D{%d.%m.%y})
POWERLEVEL9K_DATE_FORMAT='%D{%Y%m%d}'

export TERMINFO="/usr/share/terminfo"
#export TERM="xterm-256color"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# Fish-like fast/unobtrusive autosuggestions for zsh
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# general-purpose command-line fuzzy finder
zinit light junegunn/fzf

# Feature rich syntax highlighting for Zsh
zinit light zdharma/fast-syntax-highlighting

# Load a theme
min_zsh_ver="5.1"
PS1="READY >" # provide a nice prompt till the theme loads
zinit ice wait'!' lucid
if (( ${ZSH_VERSION%.*} >= ${min_zsh_ver%.*} )); then
  zinit ice depth=1; zinit light romkatv/powerlevel10k
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
else
  # Use PowerLevel9k theme when running ZSH version -le 5.0
  zinit ice depth=1; zinit light Powerlevel9k/powerlevel9k
fi

# Source .zshrc.local to allow for local configuration
if [ -f $HOME/.zshrc.local ]; then
  source $HOME/.zshrc.local
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

