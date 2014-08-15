" Josh's .vimrc : https://github.com/joshbeard/dotfiles/blob/master/home/.vimrc

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" http://vim.wikia.com/wiki/Toggle_auto-indenting_for_code_paste
set pastetoggle=<F10> 

""" Vundle Stuff - https://github.com/gmarik/Vundle.vim
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" To install plugins, add them here and then:
" Launch vim and run :PluginInstall
"
" To install from command line: vim +PluginInstall +qall
"
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" VIM Puppet plugin - https://github.com/rodjek/vim-puppet
Plugin 'rodjek/vim-puppet'

" Tabular - https://github.com/godlygeek/tabular
" Sometimes, it's useful to line up text. Naturally, it's nicer to have the
" computer do this for you, since aligning things by hand quickly becomes
" unpleasant.
Plugin 'godlygeek/tabular'

" syntastic - https://github.com/scrooloose/syntastic
" Syntastic is a syntax checking plugin for Vim that runs files through
" external syntax checkers and displays any resulting errors to the user. This
" can be done on demand, or automatically as files are saved.
Plugin 'scrooloose/syntastic'

" File browser - https://github.com/scrooloose/nerdtree
Plugin 'scrooloose/nerdtree'

" sexy color theme
Plugin 'joshbeard/vim-kolor'
" a light colorscheme
Plugin 'Pychimp/vim-sol'
" light/pleasant colorscheme
Plugin 'jnurmine/Zenburn'
" https://github.com/morhetz/gruvbox/wiki/Installation
Plugin 'morhetz/gruvbox'

" All of your Plugins must be added before the following line
call vundle#end()             " required
filetype plugin indent on     " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" Put your stuff after this line

""" Syntastic options - http://crimsonfu.github.io/2012/08/22/vimpuppet.html
" read :help Syntastic for details
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_enable_signs=1
let g:syntastic_quiet_messages = {'level': 'warnings'}
let g:syntastic_auto_loc_list=1

" wisely add end in ruby, endfunction/endif/more in vim script, etc
Plugin 'tpope/vim-endwise'

" turn off auto adding comments on next line
" so you can cut and paste reliably
" http://vimdoc.sourceforge.net/htmldoc/change.html#fo-table

set fo=tcq
filetype plugin on
set modeline
set modelines=1

syntax on

" set default comment color to cyan instead of darkblue
" which is not very legible on a black background
highlight comment ctermfg=cyan

"""MJH"""let g:neocomplcache_enable_at_startup = 1
"""MJH"""
"""MJH"""map <Leader>= <C-w>=

set tabstop=2
set expandtab
set softtabstop=2
set shiftwidth=2
" Turn on line numbers
"set number
set smartindent
set t_Co=256

"""MJH"""set formatoptions-=cro
"""MJH"""
"""MJH"""autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
"""MJH"""
"""MJH"""" 80 column concern
"""MJH""""let &colorcolumn=join(range(81,999),",")

" This adds a nice vertical colored bar at column 80, but has the nasty side
" effect of adding extra white space when copying and pasting in vim using the 
" mouse (padded up to column 80
"if version >= 703
"  set colorcolumn=80
"endif

"""MJH"""" nerdtree
"""MJH"""map <leader>n :NERDTreeToggle<CR>
"""MJH"""map <C-n> :NERDTreeToggle<CR>
"""MJH"""" " autocmd vimenter * if !argc() | NERDTree | endif

" colorscheme
color kolor
syn on

highlight LiteralTabs ctermbg=darkgreen guibg=darkgreen
match LiteralTabs /\s\  /
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/

" Show me a ruler
set ruler

" Set up puppet manifest and spec options
au BufRead,BufNewFile *.pp
  \ set filetype=puppet
au BufRead,BufNewFile *_spec.rb
  \ nmap <F8> :!rspec --color %<CR>

"""MJH"""" Enable indentation matching for =>'s
"filetype plugin indent on

" switch panes easier
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

"""MJH"""" neocomplcache keybindings
"""MJH"""let g:neocomplcache_enable_at_startup = 1

"""MJH"""inoremap <expr><C-g>     neocomplcache#undo_completion()
"""MJH"""inoremap <expr><C-l>     neocomplcache#complete_common_string()

"""MJH"""" <CR>: close popup and save indent.
"""MJH"""inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"""MJH"""function! s:my_cr_function()
"""MJH"""  return neocomplcache#smart_close_popup() . "\<CR>"
"""MJH"""  " For no inserting <CR> key.
"""MJH"""  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
"""MJH"""endfunction
"""MJH"""" <TAB>: completion.
"""MJH"""inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"""MJH"""" <C-h>, <BS>: close popup and delete backword char.
"""MJH"""inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
"""MJH"""inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
"""MJH"""inoremap <expr><C-y>  neocomplcache#close_popup()
"""MJH"""inoremap <expr><C-e>  neocomplcache#cancel_popup()


"""MJH"""""""""""""""""""""""""""""""""
"""MJH"""" airline
"""MJH"""""""""""""""""""""""""""""""""
"""MJH"""let g:airline_theme             = 'powerlineish'
"""MJH"""let g:airline_enable_branch     = 1
"""MJH"""let g:airline_enable_syntastic  = 1
"""MJH"""let g:airline_powerline_fonts   = 1

"""MJH"""if !exists('g:airline_symbols')
"""MJH"""  let g:airline_symbols = {}
"""MJH"""endif
"""MJH"""let g:airline_symbols.space = "\ua0"
"""MJH"""let g:airline#extensions#tabline#enabled = 1

"""MJH"""" unicode symbols
"""MJH"""let g:airline_left_sep = '»'
"""MJH""""let g:airline_left_sep = '▶'
"""MJH"""let g:airline_right_sep = '«'
"""MJH""""let g:airline_right_sep = '◀'
"""MJH"""let g:airline_linecolumn_prefix = '␊ '
"""MJH"""let g:airline_linecolumn_prefix = '␤ '
"""MJH"""let g:airline_linecolumn_prefix = '¶ '
"""MJH"""let g:airline#extensions#branch#symbol = '⎇ '
"""MJH"""let g:airline_paste_symbol = 'ρ'
"""MJH"""let g:airline_paste_symbol = 'Þ'
"""MJH"""let g:airline_paste_symbol = '∥'
"""MJH"""let g:airline#extensions#whitespace#symbol = 'Ξ'

"""MJH"""" Always show the airline bar
"""MJH"""set laststatus=2

" Git wrapper
Plugin 'tpope/vim-fugitive'
map <Leader>a :Git add %<CR>
map <Leader>s :Gstatus<CR>
map <Leader>c :Gcommit<CR>

"color codeschool
color gruvbox
set background=dark
