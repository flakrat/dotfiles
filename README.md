Dotfiles that I share amongst my workstations (idea and some content from Josh
Beard's GitHub: https://github.com/joshbeard/dotfiles

## References
  - ZSH Plugin Manager: https://github.com/zdharma/zplugin
  - ZSH Theme: https://github.com/romkatv/powerlevel10k
  - Nerd Fonts: https://github.com/ryanoasis/nerd-fonts
  - Other
    - Oh-My-Zsh: https://github.com/robbyrussell/oh-my-zsh
    - https://medium.com/@alex285/get-powerlevel9k-the-most-cool-linux-shell-ever-1c38516b0caa
    - http://bluejamesbond.github.io/CharacterMap/
    - https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack

## Quick Install
TODO: Turn this into an Ansible playbook

```shell
# Install zsh and other helper apps not already installed
sudo yum -y install zsh wget curl git

# Install Zplugin https://github.com/zdharma/zplugin
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"

# Clone dotfiles and copy some of the config files
if [ ! -d ~/git/flakrat ]; then
  mkdir -p ~/git/flakrat
fi

cd ~/git/flakrat

git clone https://github.com/flakrat/dotfiles.git

# Copy some of the config files
cd ~/git/flakrat/dotfiles/home
cp -a .vim ~/
cp -a .zsh* .iterm2* .vimrc .tmux.conf  ~/
cp -a isiterm2.sh ~/

# Nerd Hack Font - https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack
#
if [ ! -d ~/.local/share/fonts ]; then
  mkdir -p ~/.local/share/fonts
fi
if [ ! -d ~/.config/fontconfig/conf.d ]; then
  mkdir -p ~/.config/fontconfig/conf.d
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  cd ~/Library/Fonts
  curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
else
  cd ~/.local/share/fonts
  curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
fi
cd -

if [ ! -d ~/tmp ]; then mkdir ~/tmp; fi
cd ~/tmp
hack=Hack-v3.003-ttf.tar.gz
wget https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.tar.gz
if [ -d ~/tmp/ttf ]; then rm -rf ~/tmp/ttf; fi
tar -zxf $hack
cp -a ttf/Hack*.ttf ~/.local/share/fonts/
cd ~/.config/fontconfig/conf.d/
curl -fLo "10-nerd-font-symbols.conf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/10-nerd-font-symbols.conf
fc-cache -f -v
unset hack

# Install Powerline Fonts to support flakrat/tmux-config
# https://powerline.readthedocs.io/en/latest/installation/linux.html
cd ~/tmp
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mv PowerlineSymbols.otf ~/.local/share/fonts/
fc-cache -vf ~/.local/share/fonts/
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# Install Vim bundles
mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c ":PluginInstall"
```

## Gnome Terminal
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
