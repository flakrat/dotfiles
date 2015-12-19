# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#ZSH_THEME="xiong-chiamiov"
ZSH_THEME="cobalt2"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH="/Users/mhanby/local/bin:/Users/mhanby/.local/sbin:/Users/mhanby/.local/bin:/usr/local/sbin:/Users/mhanby/.local/sbin:/Users/mhanby/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

# http://stackoverflow.com/questions/103944/real-time-history-export-amongst-bash-terminal-windows/3055135#3055135
srvr=`hostname -s`
if [[ "$(hostname -s)" =~ "cheaha|compute" ]]; then
  HISTFILE="$HOME/.zsh_history_cheaha"
else
  HISTFILE="$HOME/.zsh_history_${srvr}"
fi
HISTCONTROL=ignoredups:erasedups  # no duplicate entries
HISTSIZE=SAVEHIST=100000          # big big history
HISTFILESIZE=100000               # big big history
#HISTTIMEFORMAT='%F %T '           # Include history time stamps
#shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
#HISTFILE=/home/mhanby/.zsh_history_$(hostname -s)
#HISTSIZE=SAVEHIST=10000
setopt sharehistory
setopt extendedhistory

# Set VI mode (i.e. BASH equiv of set -o vi)
bindkey -v

# Hightlight pattern in command output (unlike grep that only returns the matches)
# http://unix.stackexchange.com/questions/366/convince-grep-to-output-all-lines-not-just-those-with-matches
# Ex: /usr/bin/rbd --help | highlight showmapped
highlight () {
  perl -pe "s/$1/\e[1;31;43m$&\e[0m/g"
}
ihighlight () {
  perl -pe "s/$1/\e[1;31;43m$&\e[0m/ig"
}

