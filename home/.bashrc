# .bashrc
set -o vi

export SHELL=`which bash`

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
#####shopt -s checkwinsize

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

# Rados Block Device
alias rbd='/usr/bin/rbd rbd --id nova --keyring ~/ceph.client.nova.keyring '

# Hightlight pattern in command output (unlike grep that only returns the matches)
# http://unix.stackexchange.com/questions/366/convince-grep-to-output-all-lines-not-just-those-with-matches
# Ex: /usr/bin/rbd --help | highlight showmapped
highlight () {
  perl -pe "s/$1/\e[1;31;43m$&\e[0m/g"
}
ihighlight () {
  perl -pe "s/$1/\e[1;31;43m$&\e[0m/ig"
}

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

if [ -f "/usr/bin/lsb_release" ]; then
#  if [[ "$(facter osfamily)" == "RedHat" && "$(facter lsbmajdistrelease)" -lt 6 ]]; then
  if [ "$(lsb_release -r | awk '{print $2}' | awk -F. '{print $1}')" -lt 6 ]; then
    export EDITOR="/home/mhanby/local/bin/vim"
  else
    export EDITOR="/usr/bin/vim"
  fi
fi

# Systemd
alias systemctl_list="systemctl list-unit-files --type=service"

# BrightCM Master Node
if [[ "$(hostname -s)" =~ "cheaha-master" ]]; then
  # Uncomment the following line if you don't like systemctl's auto-paging feature:
  # export SYSTEMD_PAGER=
  module load cmsh
  module load slurm

  export PATH=${PATH}:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin:/root/bin
elif [[ "$(hostname -s)" =~ login|c[0-9][0-9][0-9][0-9] ]]; then # BrightCM Compute Nodes
  . /etc/profile.d/modules.sh
   module load rc-base
   alias sacct_full="sacct --format=User,JobID,JobName,account,Start,State,Timelimit,elapsed,NCPUS,NNodes,NTasks,QOS,ReqMem,MaxRss,ExitCode,NodeList"
elif [[ "$(hostname -s)" =~ cheaha|compute ]]; then # Begin Rocks 5.5 Cheaha config
  #eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`
  export PATH="/sbin:/usr/sbin:/share/apps/atlab/sbin:${PATH}"
  export EDITOR="/home/mhanby/local/bin/vim"
  . /etc/profile.d/modules.sh
  export MODULEPATH=/share/apps/tools/easybuild/modules/all:$MODULEPATH
  export EASYBUILD_INSTALLPATH=/share/apps/tools/easybuild
  # Print the job script (including path) for a specified job
  # If you want to cat the file in a single command use -E to sudo:
  # sudo -E cat $(jobscript 12345)
  function jobscript() {
    if [[ $# -eq 0 ]] ; then
      echo 'Must provide an JobID'
      exit 0
    fi
    qstat -j $1 | egrep ^'sge_o_workdir|script_file' | sort -r | tr '\n' ' ' | awk '{print $2 "/" $4}'
  }
  # qstat a users job(s) to get useful details
    function user_job_details()  {
    for job in $(qstat -u $1 | grep ^" [0-9]" | awk '{print $1}'); do
      echo -----------------------------------------------------;
      qstat -j $job | egrep ^"cwd|script_file|job_number|job_name|owner|usage|hard resource_list|parallel";
    done
    echo -----------------------------------------------------;
  }
  # qstat a specific jobid for useful details
  function job_details()  {
    echo -----------------------------------------------------;
    qstat -j $1 | egrep ^"cwd|script_file|job_number|job_name|owner|usage|hard resource_list|parallel";
    echo -----------------------------------------------------;
  }
  # downhosts displays compute nodes with SGE status a,u,d
  function downhosts()              { qstat -f | grep -v concurjob | grep -v cheaha-compute-[0,1]-3 | grep -v cheaha-compute-0-4 | grep -v verari | grep -v scalemp | egrep [du]$ | sed s/interactive-comp/interactive-compute-0-1/ ; }
  function downhosts_min()          { downhosts | awk '{print $1}' | awk -F@ '{print $2}' | awk -F. '{print $1}'; }
  function downhosts_min_disabled() { downhosts | egrep d$ | awk '{print $1}' | awk -F@ '{print $2}' | awk -F. '{print $1}'; }
  function downhosts_min_unreach()  { downhosts | egrep u$ | awk '{print $1}' | awk -F@ '{print $2}' | awk -F. '{print $1}'; }
  function downhosts_queue          { downhosts | cut -d" " -f 1 | perl -pi -e "s/^(.*)\..*/\1/g"; }
  # This function displays jobs assigned to compute nodes returned by downhosts()
  function downhosts_qstat()        { for host in $(downhosts_queue); do qstat -u \* -f -s r -q $host; done }
#  for job in $(downhosts_qstat | grep ^" [0-9]" | awk '{print $1}'); do echo $job; qstat -j $job | egrep "^parallel|virtual_free|maxvmem"; done
  function downhosts_job_details()  { 
    for job in $(downhosts_qstat | grep ^" [0-9]" | awk '{print $1}'); do
      echo -----------------------------------------------------;
      qstat -j $job | egrep ^"cwd|script_file|job_number|job_name|owner|usage|hard resource_list|parallel";
    done
    echo -----------------------------------------------------;
  }

  # Disables hosts marked as unreachable by SGE
  function downhosts_disable()      { for host in $(downhosts_queue); do qmod -d $host; done }
  # This function ssh's to each downhost, checks a known good Lustre path, if the path fails it attempts to mount Lustre
  # if it succeeds, it displays the qmod -e command needed to enable the compute node in SGE
  function downhosts_enable()       { 
    for host in `downhosts_min | grep -v cheaha-compute-0-3 | grep -v cloud` ; do 
      sudo ssh $host 'if [ ! -d /scratch/user/mhanby ]; then echo "$(hostname -s) : Lustre not mounted"; mount -a ; else echo "qmod -e `qstat -f | grep $(hostname -s) | head -n 1 | perl -pe "s/@.*//"`@$(hostname -s)"; ls -d /scratch/user/mhanby > /dev/null; fi';
    done
  }
  # I used to use downhosts_qmod as the function name, copying function downhosts_enable to support my brain backward compatibility
  downhosts_qmod=$(declare -f downhosts_enable)                                                                                               
  downhosts_qmod=${downhosts_qmod#*\{}
  downhosts_qmod=${downhosts_qmod%\}}
  eval "downhosts_qmod () { $downhosts_qmod }"
  # Function to reset hosts that are unreachable via ssh. reset-down-hosts.sh uses ipmi - https://gitlab.uabgrid.uab.edu/mhanby/atlab/blob/master/scripts/reset-down-hosts.sh
  function downhosts_off()       { for host in $(downhosts_min) ; do ~/bin/reset-down-hosts.sh -t $host -c off; sleep 0; done }
  function downhosts_on()        { for host in $(downhosts_min) ; do ~/bin/reset-down-hosts.sh -t $host -c on; sleep 0; done }
  function downhosts_status()    { for host in $(downhosts_min) ; do ~/bin/reset-down-hosts.sh -t $host -c status; sleep 0; done }
  function downhosts_reset()     { for host in $(downhosts_min) ; do ~/bin/reset-down-hosts.sh -t $host -c reset; sleep 0; done }

  # Cheaha aliases
  alias qstatall="qstat -u \*"
  alias hostmem="qhost | grep compute | grep -v verari | sort | awk '{print \$1 \"\t\t\" \$6}' | sort -n -r -k2"
  alias updatefirmware="for host in \$(qstat -f -s r | grep -v scalemp | grep -v verari | grep d\$ | awk '{print \$1}' | awk -F@ '{print \$2}' | awk -F. '{print \$1}'); do read -p \"Update \$host firmware: (y/n)\"; if [ \$REPLY = 'y' ]; then echo sudo ssh \$host \"/share/apps/atlab/bin/update-node-firmware.sh bootstrap\"; else echo 'Skipping firmware update'; fi; done"
  alias qstatgen2="qstat -f -u \* -s r -q all.q"
  alias qstatgen3="qstat -f -u \* -s r -q sipsey.q"
  alias queryusers="for user in \$(grep -v ^# /etc/auto.home | grep -v ^\* | awk '{print \$1}'| sort); do if [ ! \"\$(w | grep \$user | awk '{print \$1}' | uniq)\" ]; then if [ ! \"\$(qstat -u \$user -s r | grep \$user)\" ]; then        echo \$user; sudo time rsync -a --delete /export/home.old/\$user/ /export/home/\$user/ ; sudo mv /export/home.old/\$user /export/home.old/archived/; fi; fi; done"
#  module load lammpi/lam-7.1-gnu
  export PATH=/share/apps/atlab/bin:${PATH}
fi # End CHEAHA config

# Host agnostic alias and functions
alias igrep="grep -i"
alias rpmarch="rpm -qa --queryformat='%{N}-%{V}-%{R}-.%{arch}\n'"
alias vmlist="virsh --connect qemu:///system list"
alias virsh-sys="virsh --connect qemu:///system"
alias proclist='ps -eo user,pid,ppid,pcpu,pmem,stat,start_time,etime,cmd --sort=-pcpu,-pmem | egrep -v "  [0-9].[0-9]  [0-1].[0-9] "'
function vmlist-remote() { virsh --connect qemu+ssh://$1/system list; }
function virsh-sys-remote() { virsh --connect qemu+ssh://$1/system; }
# Sort processes by top virtmem usage
function proc-by-virtmem() { ps -e -o pid,vsz,comm= | sort -r -n -k 2; }

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
if [ "$TERM" == "xterm-256color" ] || [ "$TERM" == "xterm" ] || [ "$TERM" == "screen" ] ; then
  export PS1="\[\033[32m\]\w\n\[\033[1;31m\]\u@\h \[\033[0m\]: \[\033[33m\]\d \t \[\033[0m\]: \[\e[1;34m\]\W\[\033[0m\] $ \[\033[0m\]"
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
elif [[ "$(hostname -s)" =~ "shealy|c[0-9][0-9][0-9][0-9]" ]]; then
  HISTFILE="$HOME/.zsh_history_compute"
else
  export HISTFILE="$HOME/.bash_history_${srvr}"
fi
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
export HISTTIMEFORMAT='%F %T '           # Include history time stamps
#####shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

export PATH="$HOME/local/bin:${PATH}"
export MANPATH="$HOME/local/share/man:${MANPATH}"

# Hightlight pattern in command output (unlike grep that only returns the matches)
# http://unix.stackexchange.com/questions/366/convince-grep-to-output-all-lines-not-just-those-with-matches
# Ex: /usr/bin/rbd --help | highlight showmapped
highlight () {
  perl -pe "s/$1/\e[1;31;43m$&\e[0m/g"
}
ihighlight () {
  perl -pe "s/$1/\e[1;31;43m$&\e[0m/ig"
}

# iTerm2 / 3 Shell Integration
#test -e ${HOME}/.iterm2_shell_integration.bash && source ${HOME}/.iterm2_shell_integration.bash

# Git Stuff
# Don't use the pager for 'git diff', i.e. dump it all out to the terminal at once
alias gitdiff='git --no-pager diff'

# https://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html
alias mountpretty='mount |column -t'
alias datepretty='date +"%Y%m%d_%H%M%S"'
alias ports='netstat -tulanp'
#alias wakeupnas01='/usr/bin/wakeonlan 00:11:32:11:15:FC'
#alias wakeupnas02='/usr/bin/wakeonlan 00:11:32:11:15:FD'
#alias wakeupnas03='/usr/bin/wakeonlan 00:11:32:11:15:FE'
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist
## pass options to free ## 
alias meminfo='free -m -l -t'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
 
## Get server cpu info ##
alias cpuinfo='lscpu'
 
## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##
 
## get GPU ram on desktop / laptop## 
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'
## grep without comments
alias nocomment='grep -Ev '\''^(#|$)'\'''
alias lt='ls -alrt'
alias tf='tail -f '
alias psg='ps auxf | grep '
alias fastping='ping -c 5 -s.2'
mcd () {
  mkdir -p $1;
  cd $1
}

