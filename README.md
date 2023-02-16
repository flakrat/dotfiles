Dotfiles that I share amongst my workstations (idea and some content from Josh Beard's GitHub: https://github.com/joshbeard/dotfiles)

- [References](#references)
- [ZSH with Starship](#zsh-with-starship)

## References

- [Starship Cross-Shell Prompt](https://starship.rs/)
  - [Starship Discord Server](https://discord.gg/8Jzqu3T)
- [ZSH Antigen Plugin Manager](https://github.com/zsh-users/antigen)
- [Powerline Extra Symbols](https://github.com/ryanoasis/powerline-extra-symbols)
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)
  - [Nerd Font Cheat Sheet](https://www.nerdfonts.com/cheat-sheet)
- Tmux Config: https://github.com/gpakosz/.tmux
- Tmux Resurrect: https://github.com/tmux-plugins/tmux-resurrect
- Tmux Continuum: https://github.com/tmux-plugins/tmux-continuum
- Neovim / Nvim: https://github.com/neovim/neovim
  - Tokyo Night theme: https://github.com/folke/tokyonight.nvim
- vim-plug: https://github.com/junegunn/vim-plug

## ZSH with Starship

[Starship](https://starship.rs/) is a cross-shell prompt built with Rust.

![image](https://user-images.githubusercontent.com/1587409/151089867-9ec01914-5fd0-4585-b5b1-1982db0d2b1e.png)

- Install Starship and Antigen (ZSH plugin manager)

```shell
[[ ! -d ~/.local/bin ]] && mkdir -p ~/.local/bin

sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --bin-dir ~/.local/bin
curl -L git.io/antigen > ~/antigen.zsh
```

- Install Nerd Fonts
  - Mac Nerd Font install using Homebrew

  ```shell
  cd ~
  if [[ -d ~/homebrew ]]; then
    cd ~/homebrew
    git pull
    cd -
  else
    git clone https://github.com/Homebrew/brew homebrew
  fi

  eval "$(~/homebrew/bin/brew shellenv)"
  brew update --force --quiet
  chmod -R go-w "$(brew --prefix)/share/zsh"

  brew tap homebrew/cask-fonts
  brew install --cask font-hack-nerd-font
  brew install --cask font-fira-code-nerd-font
  brew install --cask font-meslo-lg-nerd-font

  printf '\ue0c0\n'
  ```

  - Linux manual Nerd Font Install

  ```shell
  fontdir="$HOME/.local/share/fonts/NerdFonts"
  [[ ! -d "$fontdir" ]] && mkdir -p $fontdir

  curl -fLo "${fontdir}/Hack Regular Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf

  fc-cache -f "$fontdir"
  printf '\ue0c0\n'
  ```

- Add ZSH configuration files from this repo

```shell
[[ ! -d ~/git/flakrat ]] && mkdir -p ~/git/flakrat

cd ~/git/flakrat
git clone https://github.com/flakrat/dotfiles.git

cd ~/git/flakrat/dotfiles/zsh
cp .zshrc .zshrc.local  ~/

[[ ! -d ~/.config ]] && mkdir -p ~/.config
cp starship.toml ~/.config/
```

- Exit and restart the shell and your prompt should now be awesome

## Tmux

Install gpakosz/.tmux

```shell
cd ~
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp ~/git/flakrat/dotfiles/tmux/.tmux.conf.local ~/
mkdir ~/.tmux_resurrect
```
