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

# Systemd
alias systemctl_list="systemctl list-unit-files --type=service"

# BrightCM Master Node
if [[ "$(hostname -s)" =~ "cheaha-master" ]]; then
  # Uncomment the following line if you don't like systemctl's auto-paging feature:
  # export SYSTEMD_PAGER=
  module load cmsh
  module load slurm

  export PATH=${PATH}:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin:/root/bin
elif [[ "$(hostname -s)" =~ "shealy|login" ]]; then # BrightCM Compute Nodes
  module load rc-base
  alias sacct_full="sacct --format=User,JobID,JobName,account,Start,State,Timelimit,elapsed,NCPUS,NNodes,NTasks,QOS,ReqMem,MaxRss,ExitCode"
elif [[ "$(hostname -s)" =~ "cheaha|compute" ]]; then # Begin Rocks 5.5 Cheaha config
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
alias rpmarch="rpm -qa --queryformat='%{N}-%{V}-%{R}-.%{arch}\n'"
alias vmlist="virsh --connect qemu:///system list"
alias virsh-sys="virsh --connect qemu:///system"
alias proclist='ps auxf | head -n 1 && ps auxf | grep -v "0.[0-9]  0"'
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
export MANPATH="$HOME/local/share/man:${MANPATH}"

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
#  shopt -s checkwinsize
  [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
  # You might want to have e.g. tty in prompt (e.g. more virtual machines)
  # and console windows
  # If you want to do so, just add e.g.
  # if [ "$PS1" ]; then
  #   PS1="[\u@\h:\l \W]\\$ "
  # fi
  # to your custom modification shell script in /etc/profile.d/ directory
fi

if [[ "$(hostname -s)" =~ "rcs-mjh2" ]]; then
  export PATH="/Users/mhanby/bin:/Users/mhanby/local/bin:/Users/mhanby/.local/sbin:/Users/mhanby/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH}"
else
  export PATH="${HOME}/bin:${HOME}/local/bin:${PATH}"
fi
