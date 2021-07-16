" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" On-demand loading
Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }

" Ansible Vim
Plug 'pearofducks/ansible-vim', { 'do': './UltiSnips/generate.sh' }

" Themes
Plug 'lifepillar/vim-solarized8'
Plug 'folke/tokyonight.nvim'

" Always load devicons last
Plug 'ryanoasis/vim-devicons'
call plug#end()

"let g:solarized_termcolors=16 "this is what fixed it for me
" set Vim-specific sequences for RGB colors
"let g:solarized_termcolors=256
"set t_Co=256
syntax enable
"set background=dark
"colorscheme solarized8
let g:tokyonight_style = "night"
colorscheme tokyonight

set encoding=UTF-8

