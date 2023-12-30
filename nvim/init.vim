" Plugins will be downloaded under the specified directory.
call plug#begin('~/.local/share/nvim/site/plugged')

" Bottom bar guy
Plug 'vim-airline/vim-airline'

" NERDTree, file system explorer
Plug 'preservim/nerdtree'

" Icons (for NERDTree) [TODO: requires a NERD Font on terminal]
"Plug 'ryanoasis/vim-devicons'

" theme
Plug 'dracula/vim', { 'as': 'dracula' }

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

colorscheme dracula         " enable theme
"set termguicolors           " can fix issue with theme colors

set mouse=a                 " enable mouse
set nocompatible            " disable compatability features to vi
set showmatch               " bracket matching
set ignorecase              " case insensitive search
set tabstop=4               " # cols occupied by a tab
set softtabstop=4           " see 4 spaces as a tab
set expandtab               " convert tabs to whitespace
set shiftwidth=4            " width for autoindent
set autoindent              " enable autoindent
set number                  " line numbers
set wildmode=longest,list   " tab-completion settings
filetype plugin indent on   " allow auto-indenting depending on file type
set cursorline
set ttyfast                 " speed scrolling
