# Enable DEBUG
#set -x

# Path to your oh-my-zsh installation.
#export ZSH=${HOME}/.oh-my-zsh

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
export TERM="xterm-256color"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

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
plugins=(git zsh-autosuggestions)  ## Disabled zsh-syntax-highlighting due to poor perfomance when pasting

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

#source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

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

# https://stackoverflow.com/questions/11670935/comments-in-command-line-zsh
# Allow comments on the command line, without this you'll get errors like:
## $ #this is a comment
##   zsh: command not found: #this
setopt interactivecomments

# https://superuser.com/questions/352788/how-to-prevent-a-command-in-the-zshell-from-being-saved-into-history
# Don't log certain commands to history file (lines that start with a comment, ^#,
#   or a space, ^ , etc... by overriding builting func zshaddhistory()
function zshaddhistory() {
  emulate -L zsh
  if ! [[ "$1" =~ "(^#\s+|^\s+#|^ |^ykchalresp|--password)" ]] ; then
      print -sr -- "${1%%$'\n'}"
      fc -p
  else
      return 1
  fi
}

# http://stackoverflow.com/questions/103944/real-time-history-export-amongst-bash-terminal-windows/3055135#3055135
srvr=`hostname -s`
if [[ "$(hostname -s)" =~ "c[0-9][0-9][0-9][0-9]" ]]; then
  HISTFILE="$HOME/.zsh_history_cheaha_compute"
elif [[ "$(hostname -s)" =~ "cheaha-master" ]]; then
  HISTFILE="$HOME/.zsh_history_cheaha_master"
else
  HISTFILE="$HOME/.zsh_history_${srvr}"
fi

alias history="history 1"         # default history only displays last 16 entries
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

# https://dougblack.io/words/zsh-vi-mode.html
# By default, there is a 0.4 second delay after you hit the <ESC> key and when the mode change is registered. 
# This results in a very jarring and frustrating transition between modes. Let's reduce this delay to 0.1 seconds
export KEYTIMEOUT=1

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

# Dell commands
alias servicetag="/opt/dell/srvadmin/bin/omreport chassis info | grep 'Service Tag' | awk '{print \$5}'"

# All cluster nodes
if [[ "$(hostname -s)" =~ "cheaha-master|login|c[0-9][0-9][0-9][0-9]" ]]; then # BrightCM Compute Nodes
  ## Begin GPFS
  alias mmlsquota_scratch='mmlsquota -v -j scratch BigGreen --block-size=auto'
  alias mmlsquota_user='mmlsquota -u $USER BigGreen:user --block-size=auto'
  mmlsquota_project () {
    mmlsquota -v -j $1 BigGreen --block-size auto
  }
  ## End GPFS

  ## Begin Slurm aliases
  # WIP - Hold all pending jobs for user
#  function scontrol_hold_user () {
#    if [[ "$1" == "" ]]; then
#      echo "No user specified!"
#      #exit 1
#    else
#      user=$1
#      script=/tmp/holduser-$user-$(date "+%Y.%m.%d-%H.%M.%S")
#      echo '#!/bin/bash' > $script
#      squeue --user=$user -h -o "sudo /cm/shared/apps/slurm/current/bin/scontrol hold %i" >> $script
#      chmod +x $script
#      echo "The following script will now be executed to hold pending jobs: $script"
#      /bin/bash $script
#    fi
#  }
  alias scontrol_admin="sudo /cm/shared/apps/slurm/current/bin/scontrol"
  alias scancel_admin="sudo /cm/shared/apps/slurm/current/bin/scancel"
  alias sacctmgr_admin="sudo /cm/shared/apps/slurm/current/bin/sacctmgr"
  alias sinfo_gres='sinfo -o "%15N %10c %10m  %25f %10G"'
  alias sinfo_downhosts="sinfo --states=down --noheader -N | awk '{print \$1}' | sort | uniq"
  slurm_disable_user () {
    sudo /cm/shared/apps/slurm/current/bin/sacctmgr modify user $1 set maxjobs=0
  }
  slurm_enable_user () {
    sudo /cm/shared/apps/slurm/current/bin/sacctmgr modify user $1 set maxjobs=-1
  }
  sinfo_drained_reason () {
    for node in $(sinfo --states=drain --noheader -N | awk '{print $1}' | sort | uniq); do
      scontrol show node $node | egrep "NodeName|mem|Reason"
    done
  }
  scontrol_undrain_all () {
    for node in $(sinfo --states=drain --noheader | awk '{print $6}' | sort | uniq); do
      sudo /cm/shared/apps/slurm/current/bin/scontrol update NodeName="$node" State=undrain
    done
  }
  alias sinfo_drained="sinfo --states=drain --noheader -N | awk '{print \$1}' | sort | uniq"
  #alias sacct_full="sacct --allusers --format=User,JobID,JobName,account,Start,End,State,Timelimit,elapsed,NCPUS,NNodes,NTasks,QOS,ReqMem,MaxRss,ExitCode,NodeList"
  alias sacct_full="sacct --allusers --format=User,JobID,JobName,Partition,State,Submit,TimeLimit,Start,End,Elapsed,ReqCPU,ReqMem,MaxRSS,MaxVMSize,NNodes,NTasks,Reservation,NodeList"
  alias squeue_full='squeue --format "%.8i %.9P %.8j %.8u %.6D %.4C %.6Q %.4t %.11M %.16S %.16L %.16e %.14R %.14Z %.25o"'
  alias squeue_full2='squeue --format "%.8i %.9P %.8j %.8u %.6D %.4C %.4t %.11M %.16S %.16L %.16e %.14R %Z %o"'
  alias squeue_full3='squeue -O "jobid,partition,name,username,tres,state,reasonlist,starttime,timeleft,workdir"'
  alias squeue_jobscript='squeue --format "%.10i %.12u %o"'
  alias squeue_jobdir='squeue --format "%.10i %.12u %Z"'
  alias squeue_jobstarttime='squeue --format "%.10i %.12u %S"'
  alias squeue_jobendtime='squeue --format "%.10i %.12u %e"'
  alias squeue_jobruntime='squeue --format "%.10i %.12u %M"'
  alias squeue_jobtimeleft='squeue --format "%.10i %.12u %L"'
  #alias squeue_full='squeue --format "%.18i %.9P %.8j %.8u %.8C %.8t %.8b %.10M %.12l %.12L %.6D %.35Z %R"'
  ## End Slurm aliases

  ## Nvidia GPU Cuda stuff
  alias nvidia-query="nvidia-smi --query-gpu=gpu_name,gpu_bus_id,vbios_version --format=csv"

  # lsof alternative because lsof hangs when a file system (NSF usually) is unresponsive
  function lsof_alt() {
    for FD in /proc/*/fd/*; do
      readlink $FD 2> /dev/null | grep ^/$1 ;
    done
  }
  # Alias to display the current number of allocated cpu cores
  alias used_cores='sinfo -a -o "%C"'
#  function used_cores()  {
#    n=0;
#    for cpus in $(squeue --all --noheader --states=running --format "%.6C" ); do
#      let n=$n+cpus;
#    done ;
#    echo $n
#  }
fi
# End All cluster nodes

# BrightCM Master Node
if [[ "$(hostname -s)" =~ "cheaha-master" ]]; then
  # Uncomment the following line if you don't like systemctl's auto-paging feature:
  # export SYSTEMD_PAGER=
  module load cmsh
  #module load rc-base
  #module load slurm

  # Cheaha-master aliases
  alias downhosts='cmsh -c "device status | grep DOWN"'
  alias ansible_root='sudo /usr/bin/ansible -i ~mhanby/.ansible/hosts'
  alias reboot_computenodes='sudo /usr/bin/ansible -i ~mhanby/.ansible/hosts computenodes -a "/sbin/shutdown -r +1" --one-line'

  export PATH=${PATH}:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin:/root/bin
  export PATH=${PATH}:/usr/lpp/mmfs/bin
elif [[ "$(hostname -s)" =~ "shealy|login[0-9][0-9]|c[0-9][0-9][0-9][0-9]" ]]; then # BrightCM Compute Nodes
  #module load rc-base
elif [[ "$(hostname -s)" =~ "compute" ]]; then # Begin Rocks 5.5 Cheaha config
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
  for job in $(downhosts_qstat | grep ^" [0-9]" | awk '{print $1}'); do echo $job; qstat -j $job | egrep "^parallel|virtual_free|maxvmem"; done
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
alias proclist='ps -eo user,pid,ppid,pcpu,pmem,stat,start_time,etime,cmd --sort=-pcpu,-pmem | egrep -v "  0.[0-9]  0.[0-9] "'
alias memlist='ps -eo user,pid,ppid,cmd:75,%mem,%cpu --sort=-%mem | head -n 15'
alias topmem="ps aux --sort=-%mem | awk 'NR<=10{print \$0}'"
function vmlist-remote() { virsh --connect qemu+ssh://$1/system list; }
function virsh-sys-remote() { virsh --connect qemu+ssh://$1/system; }
# Sort processes by top virtmem usage
function proc-by-virtmem() { ps -e -o pid,vsz,comm= | sort -r -n -k 2; }

function proclog() {
  for n in {1..90}; do
    out="$HOME/log/$(hostname -s)_proclist_$(date +%Y%m%d).log"
    curday="$(date +%Y%m%d)"
    while [ $(date +%Y%m%d) -le $curday ]; do 
      echo "======   $(date)   ======" | tee -a $out;
      proclist | egrep -v 'gnome-shell|desktop|firefox|slideshow|netdata|polkitd|sftp-server|notty|mhanby|screensaver|mmfsd' | tee -a $out;
      sleep 60;
    done;
    gzip $out;
  done
}

# Retrieve serial numbers for the DDN SFA controllers
function serialnum() {
  echo "SFA1:"
  ssh user@sfa1 "show enc al" | grep "Production serial numb"
  echo "SFA2:"
  ssh user@sfa2 "show enc al" | grep "Production serial numb"
}


# Set the tab title
# http://tldp.org/HOWTO/Xterm-Title-4.html
#  precmd ()   a function which is executed just before each prompt
#  chpwd ()    a function which is executed whenever the directory is changed
#  \e          escape sequence for escape (ESC)
#  \a          escape sequence for bell (BEL)
#  %n          expands to $USERNAME
#  %m          expands to hostname up to first '.'
#  %~          expands to directory, replacing $HOME with '~'
#
case $TERM in
    xterm*)
        precmd () {print -Pn "\e]0;%n@%m: %~\a"}
        ;;
esac

# Fail2ban Aliases
alias banlist-sshd='sudo ipset list fail2ban-sshd'

# Firewalld Aliases
alias firewall-rejects='sudo firewall-cmd --direct --get-all-rules'

# nixCraft (on Facebook) calc recipe
# Usage: calc "10+2"
#   Pi:  calc "scale=10; 4*a(1)"
# Temperature: calc "30 * 1.8 + 32"
#              calc "(86 - 32)/1.8"
calc_full() { echo "$*" | bc -l; }
calc() { echo "scale=2; $*" | bc -l; }

# Ruby
export RUBYVER=`ruby --version | cut -d" " -f 2 | cut -d. -f 1,2`
export GEM_HOME=$HOME/.ruby/lib/ruby/gems/${RUBYVER}
export RUBYLIB=$HOME/.ruby/lib/ruby:$HOME/.ruby/lib/site_ruby/${RUBYVER}:${RUBYLIB}
export MANPATH="$HOME/local/share/man:${MANPATH}"

if [[ "$(hostname -s)" =~ "rcs-mjh2" ]]; then
  export PATH="/Users/mhanby/bin:/Users/mhanby/local/bin:/Users/mhanby/.local/sbin:/Users/mhanby/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH}"
else
  export PATH="${HOME}/.local/bin:${HOME}/bin:${HOME}/local/bin:${PATH}"
fi

## Install 'md5sum' via HomeBrew instead:
##   brew install md5sha1sum

if [[ "$OSTYPE" == "darwin"* ]]; then
  alias md5='md5 -r'
  #alias python="python3"
  export DYLD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$DYLD_LIBRARY_PATH
  export PATH=/usr/local/opt/python/libexec/bin:/Users/mhanby/Library/Python/3.7/bin:${PATH}
fi

# iTerm2 Shell Integration
#test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
#${HOME}/isiterm2.sh && test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Git Stuff
# Don't use the pager for 'git diff', i.e. dump it all out to the terminal at once
alias gitdiff='git --no-pager diff'

# VI Aliases
alias viro='vim -Mn'

# https://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html
alias mountpretty='mount |column -t'
alias datepretty='date +"%Y%m%d_%H%M%S"'
alias ports='netstat -tulanp'
#alias wakeupnas01='/usr/bin/wakeonlan 00:11:32:11:15:FC'
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

## View server hardware model (VMware, KVM, PowerEdge, etc...)
alias host_model='cat /sys/devices/virtual/dmi/id/product_name'

## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

## Get server cpu info ##
alias cpuinfo='lscpu'

## get GPU ram on desktop / laptop##
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'
## grep without comments
alias nocomment='grep -Ev '\''^(#|$|;)'\'''
alias lt='ls -alrt'
alias tf='tail -f '
alias psg='ps auxf | grep '
alias fastping='ping -c 5 -s.2'
mcd () {
  mkdir -p $1;
  cd $1
}
alias filehogs="sudo lsof -w | awk '{ print \$2 \"\\t\" \$1; }' | sort -rn | uniq -c | sort -rn | head"
alias openfiles="cat /proc/sys/fs/file-nr"
alias vnclist="ps -eo user:25,pid,lstart,cmd --sort=user | grep Xvnc | grep -v grep | grep -v thinlinc | awk '{print \$1 \"\t\" \$9 \"\t\" \$2 \"\t\" \$4 \"-\" \$5 \"-\" \$7 \"_\" \$6 \"\t\" \$18 \"\t\" \$23}' | column -s \$'\t' -t"
alias vnclist_count="ps -eo user:25,cmd --sort=user | grep Xvnc | grep -v grep | grep -v thinlinc | awk '{print \$1}' | uniq -c | grep -v ' 1 ' | sort -r"
alias vnclist_cputime="ps -eo etimes:25,time:25,user:25,pid,lstart,cmd --sort=+user | grep Xvnc | grep -v grep | grep -v thinlinc | sort -k1 -r -n | awk '{print \$3 \"\t\" \$4 \"\t\" \$6 \"-\" \$7 \"-\" \$9 \"_\" \$8 \"\t\" \$18 \"\t\" \$24 \"\t\" \$2}' | sort -k6 -n | column -s \$'\t' -t"
alias sccm_version="grep 'Build number' /var/opt/microsoft/scxcm.log | awk '{print \$4}' | tail -n 1"
alias sccm_version_all="ansible sccm -m shell -a \"grep 'Build number' /var/opt/microsoft/scxcm.log | awk '{print \\\$4}' | tail -n 1\" --one-line"
alias ansible_group_list="ansible localhost -m debug -a 'var=groups.keys()'"
alias ansible_group_membership="ansible localhost -m debug -a 'var=groups'"

if [ -f $HOME/.gem/ruby/gems/tmuxinator-0.9.0/completion/tmuxinator.zsh ]; then
  source ~/.gem/ruby/gems/tmuxinator-0.9.0/completion/tmuxinator.zsh
fi

#powerline-daemon -q
#POWERLINE_BASH_CONTINUATION=1
#POWERLINE_BASH_SELECT=1
#. /home/mhanby/.local/lib//python2.7/site-packages/powerline/bindings/zsh/powerline.zsh

export SHELL=`which zsh`

# https://access.redhat.com/solutions/2094961
# disable GTK+ message "Couldn't connect to accessibility bus"
export NO_AT_BRIDGE=1

# Add highlighters to zsh-syntax-highlighting (default is 'main')
# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_MAXLENGTH=20  # If you don't set a sane max length the highlighter will highlight large pastes of text, which is painfully slow

# Source .zshrc.local to allow for local configuration
if [ -f $HOME/.zshrc.local ]; then
  source $HOME/.zshrc.local
fi

# Enable case insensitive tab completion of file names, even from partial words of the file name
# https://stackoverflow.com/a/22627273/1361782
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
autoload -Uz compinit
compinit

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p $HOME/.zinit
    command git clone https://github.com/zdharma/zinit $HOME/.zinit/bin && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

zinit ice wait blockf atpull'zinit creinstall -q .'

# Regular plugins loaded without tracking.
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting

# Plugin history-search-multi-word loaded with tracking.
zinit load zdharma/history-search-multi-word

# Binary release in archive, from GitHub-releases page.
# After automatic unpacking it provides program "fzf".
zinit ice from"gh-r" as"program"
zinit load junegunn/fzf-bin

zinit ice wait atinit"zpcompinit; zpcdreplay"

zinit ice wait atload"_zsh_autosuggest_start"

# Load a theme
PS1="READY >" # provide a nice prompt till the theme loads
zinit ice wait'!' lucid
if is-at-least 5.1; then
  zinit ice depth=1; zinit light romkatv/powerlevel10k
else
  # Use PowerLevel9k theme when running ZSH version -le 5.0
  zinit ice depth=1; zinit light Powerlevel9k/powerlevel9k
fi

# Enable case insensitive tab completion of file names
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
