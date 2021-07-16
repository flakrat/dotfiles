Dotfiles that I share amongst my workstations (idea and some content from Josh Beard's GitHub: https://github.com/joshbeard/dotfiles)

## References
  - ZSH Plugin Manager: https://github.com/zdharma/zinit
  - ZSH Theme: https://github.com/romkatv/powerlevel10k
  - Nerd Fonts: https://github.com/ryanoasis/nerd-fonts
    - https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack
  - Tmux Config: https://github.com/gpakosz/.tmux
  - Tmux Resurrect: https://github.com/tmux-plugins/tmux-resurrect
  - Tmux Continuum: https://github.com/tmux-plugins/tmux-continuum
  - Neovim / Nvim: https://github.com/neovim/neovim
    - Tokyo Night theme: https://github.com/folke/tokyonight.nvim
  - vim-plug: https://github.com/junegunn/vim-plug

## Quick Install
TODO: Turn this into an Ansible playbook

Install the latest release of Neovim from: https://github.com/neovim/neovim/releases/tag/stable

```shell
# Install zsh and other helper apps not already installed
sudo yum -y install zsh wget curl git

# Install Zinit https://github.com/zdharma/zplugin
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
zsh
zinit self-update

# Clone dotfiles and copy some of the config files
if [ ! -d ~/git/flakrat ]; then mkdir -p ~/git/flakrat; fi

# Install gpakosz/.tmux
cd ~
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf

cd ~/git/flakrat
git clone https://github.com/flakrat/dotfiles.git

# Copy some of the config files
cd ~/git/flakrat/dotfiles/home
cp -a .zsh* .vimrc .tmux.conf.local  ~/

# Nerd Hack Font - https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack
if [ ! -d ~/.local/share/fonts ]; then mkdir -p ~/.local/share/fonts; fi
if [ ! -d ~/.config/fontconfig/conf.d ]; then mkdir -p ~/.config/fontconfig/conf.d; fi

if [ ! -d ~/tmp ]; then mkdir ~/tmp; fi
cd ~/tmp
hack=Hack-v3.003-ttf.tar.gz
wget https://github.com/source-foundry/Hack/releases/download/v3.003/$hack
if [ -d ~/tmp/ttf ]; then rm -rf ~/tmp/ttf; fi
tar -zxf $hack
cp -a ttf/Hack*.ttf ~/.local/share/fonts/
cd ~/.config/fontconfig/conf.d/
curl -fLo "10-nerd-font-symbols.conf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/10-nerd-font-symbols.conf
fc-cache -f -v
unset hack

# Install vim-plug
cd ~
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
