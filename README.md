Dotfiles that I share amongst my workstations (idea and some content from Josh
Beard's GitHub: https://github.com/joshbeard/dotfiles

## Quick Install
```shell
sudo yum -y install zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

mkdir ~/git
cd ~/git
git clone https://github.com/flakrat/dotfiles.git
cd dotfiles/home
cp -a .zsh* .iterm2* .vimrc .tmux.conf  ~/
cp -a .oh-my-zsh/themes/* ~/.oh-my-zsh/themes/

# Powerline fonts - https://github.com/powerline/fonts - are used by Agnoster theme
# https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/agnoster.zsh-theme
#
# Without these, the prompt will show control chars instead of fancy seperators
cd ~/git
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh

# If running in Gnome Terminal, set the default profile font to Powerline
if [ `echo $VTE_VERSION` -eq 3409 ]; then
  oldfont=$(gconftool-2 --get /apps/gnome-terminal/profiles/Default/font)
  newfont="Meslo LG M DZ for Powerline 8"

  echo "Changing gnome-terminal Default profile font from: '$oldfont' to '$newfont'"
  gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string "$newfont"
fi


mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c ":PluginInstall"
```
## Install vundle for vim (https://github.com/gmarik/Vundle.vim)
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

## Use vundle to install vim plugins/extensions
run `:PluginInstall` from within vim

You can also just do:

    vim -c ":PluginInstall"

