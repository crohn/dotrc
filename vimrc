set shell=/bin/bash
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Plugins
Plugin 'bling/vim-airline'
Plugin 'dag/vim-fish'
Bundle 'edkolev/tmuxline.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'

" Colorschemes
Plugin 'junegunn/seoul256.vim'
Plugin 'Lokaltog/vim-distinguished'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'
Plugin 'zeis/vim-kolor'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

set background=dark
set encoding=utf-8
set expandtab
set number
set incsearch
set hlsearch
set mouse=a
set shiftwidth=2
set t_Co=256
set tabstop=2
set wildmenu

set laststatus=2

let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:NERDTreeDirArrows=1
let g:tmuxline_preset='full'
let g:solarized_termcolors=1
let g:solarized_contrast='high'
let g:solarized_visibility='high'
let g:solarized_degrade=1
let g:solarized_termcolors=256
let g:solarized_italic=0
let g:solarized_bold=0

colorscheme solarized

nmap <C-n> :tabnext<CR>
nmap <C-p> :tabprev<CR>
nmap <C-y> :let @/=''<CR>
nmap <F7>  :NERDTreeToggle<CR>

inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap { {}<ESC>i
