Dotfiles that I share amongst my workstations (idea and some content from Josh
Beard's GitHub: https://github.com/joshbeard/dotfiles

## References
  - https://medium.com/@alex285/get-powerlevel9k-the-most-cool-linux-shell-ever-1c38516b0caa
  - https://github.com/robbyrussell/oh-my-zsh
  - https://github.com/bhilburn/powerlevel9k
  - https://github.com/ryanoasis/nerd-fonts
  - http://bluejamesbond.github.io/CharacterMap/
  - https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack

## Quick Install
TODO: Turn this into an Ansible playbook

```shell
# Install zsh if not already installed
sudo yum -y install zsh

# Install Oh-my-zsh (http://ohmyz.sh/)
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Clone dotfiles and copy some of the config files
mkdir ~/git
cd ~/git
git clone https://github.com/flakrat/dotfiles.git
cd ~/git/dotfiles/home
cp -a .vim ~/
cp -a .zsh* .iterm2* .vimrc .tmux.conf  ~/
cp -a .oh-my-zsh/custom/themes ~/.oh-my-zsh/custom/
cp -a isiterm2.sh ~/

# Nerd Hack Font - https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack
#
if [[ ! -d "~/tmp" ]]; then mkdir ~/tmp; fi
cd ~/tmp
wget https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip
if [[ -d "~/tmp/ttf" ]]; then rm -rf ~/tmp/ttf; fi
unzip Hack*.zip
cp -a ttf/Hack*.ttf ~/.local/share/fonts/
cd ~/.config/fontconfig/conf.d/
curl -fLo "10-nerd-font-symbols.conf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/10-nerd-font-symbols.conf
fc-cache -f -v

# Install the PowerLevel9k (https://github.com/bhilburn/powerlevel9k) theme into oh-my-zsh, followed by optionally copying my slight mod (adds current date and time to the prompt)
cd ~/git/dotfiles/home
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
cp -a .oh-my-zsh/custom/themes/powerlevel9k/powerlevel9k-flakrat.zsh-theme \
  ~/.oh-my-zsh/custom/themes/powerlevel9k/

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
