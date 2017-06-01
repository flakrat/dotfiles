Dotfiles that I share amongst my workstations (idea and some content from Josh
Beard's GitHub: https://github.com/joshbeard/dotfiles

## Quick Install
TODO: Turn this into an Ansible playbook

```shell
sudo yum -y install zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

mkdir ~/git
cd ~/git
git clone https://github.com/flakrat/dotfiles.git
cd ~/git/dotfiles/home
cp -a .vim ~/
cp -a .zsh* .iterm2* .vimrc .tmux.conf  ~/
cp -a .oh-my-zsh/custom/themes ~/.oh-my-zsh/custom/
cp -a isiterm2.sh ~/

# Powerline fonts - https://github.com/powerline/fonts - are used by Agnoster theme
# https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/agnoster.zsh-theme
#
# Without these, the prompt will show control chars instead of fancy seperators
cd ~/git
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh

mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c ":PluginInstall"

```

```shell
# If running in Gnome Terminal, set the default profile font to Powerline and background color
if [ ${VTE_VERSION+x} ]; then
  profile="$(gconftool-2 --get /apps/gnome-terminal/global/default_profile)"

  oldbkcolor="$(gconftool-2 --get /apps/gnome-terminal/profiles/${profile}/background_color)"
  newbkcolor='#00002B2B3636'
  echo "Changing gnome-terminal ${profile} profile background_color from '$oldbkcolor' to '$newbkcolor'"
  gconftool-2 --set /apps/gnome-terminal/profiles/${profile}/background_color --type string "$newbkcolor"

  oldfont="$(gconftool-2 --get /apps/gnome-terminal/profiles/${profile}/font)"
  newfont="Meslo LG M DZ for Powerline 8"

  echo "Changing gnome-terminal ${profile} profile font from: '$oldfont' to '$newfont'"
  gconftool-2 --set /apps/gnome-terminal/profiles/${profile}/use_system_font --type bool false
  gconftool-2 --set /apps/gnome-terminal/profiles/${profile}/font --type string "$newfont"
fi
```
## Install vundle for vim (https://github.com/gmarik/Vundle.vim)
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

## Use vundle to install vim plugins/extensions
run `:PluginInstall` from within vim

You can also just do:

    vim -c ":PluginInstall"

