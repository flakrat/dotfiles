Dotfiles that I share amongst my workstations (idea and some content from Josh Beard's GitHub: https://github.com/joshbeard/dotfiles)

- [References](#references)
- [ZSH with Starship](#zsh-with-starship)

## References

- Zsh
  - [Starship Cross-Shell Prompt](https://starship.rs/)
    - [Starship Discord Server](https://discord.gg/8Jzqu3T)
  - [ZSH Antigen Plugin Manager](https://github.com/zsh-users/antigen) - Zsh plugin manager
  - [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)
    - [Nerd Font Cheat Sheet](https://www.nerdfonts.com/cheat-sheet)
- Tmux
  - Tmux Config: https://github.com/gpakosz/.tmux
  - Tmux Resurrect: https://github.com/tmux-plugins/tmux-resurrect
  - Tmux Continuum: https://github.com/tmux-plugins/tmux-continuum
- NeoVim
  - Neovim / Nvim: https://github.com/neovim/neovim
  - [NvChad](https://nvchad.com/) - Blazing fast plugin manager for NeoVim

## ZSH with Starship

[Starship](https://starship.rs/) is a cross-shell prompt built with Rust.

![image](https://user-images.githubusercontent.com/1587409/151089867-9ec01914-5fd0-4585-b5b1-1982db0d2b1e.png)

- Install Starship and Antigen (ZSH plugin manager)

```shell
[[ ! -d ~/.local/bin ]] && mkdir -p ~/.local/bin

sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --bin-dir ~/.local/bin
curl -L git.io/antigen > ~/antigen.zsh
```

- Install Nerd Fonts (only needed on the local system). 
  - Mac Nerd Font install using Homebrew. This step comes from [this Github comment](https://gist.github.com/davidteren/898f2dcccd42d9f8680ec69a3a5d350e?permalink_comment_id=5238232#gistcomment-5238232)

  ```shell
  brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs brew install --cask
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
if [[ ! -d ~/.tmux_resurrect ]]; then mkdir ~/.tmux_resurrect; fi
```

## NeoVim / NvChad

Install the latest release of NeoVim AppImage

```shell
file=~/.local/bin/nvim.appimage
test -f $file && rm $file
curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o $file
ln -s $file ~/.local/bin/nvim
chmod 755 $file
```

Install the [NvChad](https://nvchad.com/) plugin manager for NeoVim

```shell
test -d ~/.config/nvim && rm -rf ~/.config/nvim
test -d ~/.local/share/nvim && rm -rf ~/.local/share/nvim
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
```

NvChad can be updated from within NeoVim using the command

```shell
NvChadUpdate
```

Optionally, disable the mouse click moving the cursor by editing `~/.config/nvim/lua/core/init.lua` and changing `opt.mouse = "a"` to `opt.mouse = ""`

Additionally, on RHEL7 / CentOS 7, `nvim-treesitter` fails to build. It can be disabled by editing `~/.config/nvim/lua/custom/plugins.lua`

```lua
{
  "nvim-treesitter/nvim-treesitter",
  opts = overrides.treesitter,
  enabled = false
},
```
