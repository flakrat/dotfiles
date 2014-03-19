# .bashrc
set -o vi

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [[ "$(hostname -s)" =~ "cheaha|compute" ]]; then
  export PATH="/share/apps/atlab/sbin:${PATH}"
# Begin CHEAHA config
  #export MODULEPATH=$HOME/.modulefiles:$MODULEPATH
  . /etc/profile.d/modules.sh
  alias qstatall="qstat -u \*"
  alias hostmem="qhost | grep compute | grep -v verari | sort | awk '{print \$1 \"\t\t\" \$6}' | sort -n -r -k2"
  alias updatefirmware="for host in \$(qstat -f -s r | grep -v scalemp | grep -v verari | grep d\$ | awk '{print \$1}' | awk -F@ '{print \$2}' | awk -F. '{print \$1}'); do read -p \"Update \$host firmware: (y/n)\"; if [ \$REPLY = 'y' ]; then echo sudo ssh \$host \"/share/apps/atlab/bin/update-node-firmware.sh bootstrap\"; else echo 'Skipping firmware update'; fi; done"
  alias downhosts='qstat -f | grep -v cheaha-compute-1-3 | grep -v scalemp | egrep [du]$'
  alias downhosts_min="qstat -f | grep -v cheaha-compute-1-3 | grep -v scalemp | egrep [du]\$ | awk '{print \$1}' | awk -F@ '{print \$2}' | awk -F. '{print \$1}'"
  alias downhosts_unreachmin="qstat -f | grep u\$ | awk '{print \$1}' | awk -F@ '{print \$2}' | awk -F. '{print \$1}'"
  alias downhosts_dismin="qstat -f | grep d\$ | awk '{print \$1}' | awk -F@ '{print \$2}' | awk -F. '{print \$1}'"
  alias downhosts_queue='qstat -f | grep -v cheaha-compute-1-3 | grep -v scalemp | egrep [du]$ | cut -d" " -f 1 | perl -pi -e "s/^(.*)\..*/\1/g"'
  alias qstatgen2="qstat -f -u \* -s r -q all.q"
  alias qstatgen3="qstat -f -u \* -s r -q sipsey.q"
  alias queryusers="for user in \$(grep -v ^# /etc/auto.home | grep -v ^\* | awk '{print \$1}'| sort); do if [ ! \"\$(w | grep \$user | awk '{print \$1}' | uniq)\" ]; then if [ ! \"\$(qstat -u \$user -s r | grep \$user)\" ]; then        echo \$user; sudo time rsync -a --delete /export/home.old/\$user/ /export/home/\$user/ ; sudo mv /export/home.old/\$user /export/home.old/archived/; fi; fi; done"
#  module load lammpi/lam-7.1-gnu
  export PATH=/share/apps/atlab/bin:${PATH}
# End CHEAHA config
fi

# User specific aliases and functions
alias rpmarch="rpm -qa --queryformat='%{N}-%{V}-%{R}-.%{arch}\n'"
alias vmlist="virsh --connect qemu:///system list"
alias virsh-sys="virsh --connect qemu:///system"
alias proclist='ps auxf | grep -v "0.[0-9]  0"'
function vmlist-remote() { virsh --connect qemu+ssh://$1/system list; }
function virsh-sys-remote() { virsh --connect qemu+ssh://$1/system; }
function downhosts_qstat() { for host in $(downhosts_queue|egrep -v 'cheaha-compute-1-[3,5]|verari-compute-0-9'); do qstat -u \* -s r -q $host; done }
function downhosts_disable() { for host in $(downhosts_queue|egrep -v 'cheaha-compute-1-[3,5]|verari-compute-0-9'); do qmod -d $host; done }
function downhosts_qmod() { for host in `qstat -f | grep -v cheaha-compute-1-3 | grep -v scalemp | egrep [du]$ | awk '{print $1}' | awk -F@ '{print $2}' | awk -F. '{print $1}'` ; do sudo ssh $host 'if [ ! -d /scratch/user/mhanby ]; then echo $(hostname -s) : Lustre not mounted; mount -a ; else echo qmod -e sipsey.q@$(hostname -s); ls -d /scratch/user/mhanby > /dev/null; fi'; done }
#function downhosts_min() { qstat -f | grep -v cheaha-compute-1-3 | grep -v scalemp | egrep [du]\$ | awk '{print \$1}' | awk -F@ '{print \$2}' | awk -F. '{print \$1}' }
#function blazerid_query() { blazerid_query.rb --username $1 | egrep -i -A1 "displayname|uabemployeedepartment|mail|uid|eduPersonPrimaryAffiliation:"; }

# nixCraft (on Facebook) calc recipe
# Usage: calc "10+2"
#   Pi:  calc "scale=10; 4*a(1)"
# Temperature: calc "30 * 1.8 + 32"
#              calc "(86 - 32)/1.8"
calc() { echo "$*" | bc -l; }

# Ruby
export RUBYVER=`ruby --version | cut -d" " -f 2 | cut -d. -f 1,2`
export GEM_HOME=$HOME/.ruby/lib/ruby/gems/${RUBYVER}
export RUBYLIB=$HOME/.ruby/lib/ruby:$HOME/.ruby/lib/site_ruby/${RUBYVER}:${RUBYLIB}

# Colorful prompt
if [ "$TERM" == "xterm-256color" ] || [ "$TERM" == "xterm" ] ; then
  export PS1="\[\033[32m\]\w\n\[\033[1;31m\]\u@\h \[\033[0m\]: \[\033[35m\]\d \t \[\033[0m\]: \[\e[1;34m\]\W\[\033[0m\] $ \[\033[0m\]"
else
  export PS1='[\u@\h \W]\$ '
fi

# Set the gnome-terminal title. This is an attempt to fix the issue where gnome terminal doesn't always update on its own
# This works when starting a new shell (i.e. ssh to a node), but doesn't work when exiting that node
# The problem is essentially gnome-terminal isn't refreshing the tab title when bouncing around to different nodes
#export PROMPT_COMMAND='echo -en "\033]0;${USER}@$(hostname -s)\a"'
# are we an interactive shell?
if [ "$PS1" ]; then
  if [ -z "$PROMPT_COMMAND" ]; then
    case $TERM in
    xterm*)
      if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
          PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
      else
          PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
      fi
      ;;
    screen)
      if [ -e /etc/sysconfig/bash-prompt-screen ]; then
          PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
      else
          PROMPT_COMMAND='printf "\033]0;%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
      fi
      ;;
    *)
      [ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default
      ;;
    esac
  fi
  # Turn on parallel history
#  shopt -s histappend
#  history -a
  # Turn on checkwinsize
  shopt -s checkwinsize
  [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
  # You might want to have e.g. tty in prompt (e.g. more virtual machines)
  # and console windows
  # If you want to do so, just add e.g.
  # if [ "$PS1" ]; then
  #   PS1="[\u@\h:\l \W]\\$ "
  # fi
  # to your custom modification shell script in /etc/profile.d/ directory
fi

# http://stackoverflow.com/questions/103944/real-time-history-export-amongst-bash-terminal-windows/3055135#3055135
srvr=`hostname -s`
if [[ "$(hostname -s)" =~ "cheaha|compute" ]]; then
  export HISTFILE="$HOME/.bash_history_cheaha"
else
  export HISTFILE="$HOME/.bash_history_${srvr}"
fi
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
export HISTTIMEFORMAT='%F %T '           # Include history time stamps
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

export PATH="$HOME/local/bin:$PATH"
