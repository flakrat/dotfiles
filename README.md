Dotfiles that I share amongst my workstations (idea and some content from Josh
Beard's GitHub: https://github.com/joshbeard/dotfiles

## Quick Install
```shell
sudo yum -y install zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c ":PluginInstall"

mkdir ~/git
cd ~/git
git clone https://github.com/flakrat/dotfiles.git
cd dotfiles/home
cp -a .zsh* .iterm2* .vimrc .tmux.conf  ~/
cp -a .oh-my-zsh/themes/* ~/.oh-my-zsh/themes/
```
## Install vundle for vim (https://github.com/gmarik/Vundle.vim)
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

## Use vundle to install vim plugins/extensions
run `:PluginInstall` from within vim

You can also just do:

    vim -c ":PluginInstall"

