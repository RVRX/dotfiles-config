" Plugins will be downloaded under the specified directory.
call plug#begin('~/.local/share/nvim/site/plugged')

" Bottom bar guy
Plug 'vim-airline/vim-airline'

" NvimTree, file system explorer
Plug 'nvim-tree/nvim-tree.lua'

" Icons (for some plugins)
Plug 'nvim-tree/nvim-web-devicons' " TODO: requires a NERD Font on terminal 

" Better Tabs
Plug 'romgrk/barbar.nvim'

" theme
Plug 'dracula/vim', { 'as': 'dracula' }

" List ends here. Plugins become visible to Vim after this call.
call plug#end()


lua << EOF

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
--vim.opt.termguicolors = true

-- empty setup using defaults
require('nvim-tree').setup({
  hijack_cursor = false,
  on_attach = function(bufnr)
    local bufmap = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, {buffer = bufnr, desc = desc})
    end

    -- See :help nvim-tree.api
    local api = require('nvim-tree.api')
   
    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    bufmap('e', api.tree.change_root_to_node, 'CD')
    bufmap('I', api.tree.toggle_hidden_filter, 'Toggle hidden files')
    vim.keymap.del('n', '<C-T>', { buffer = bufnr })
  end
})


-- open NvimTree with \e
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')

EOF

colorscheme dracula         " enable theme
"set termguicolors           " can fix issue with theme colors

set mouse=a                 " enable mouse
set hlsearch                " highlight search (nvim default)
set incsearch               " incremental search (nvim default)
set nocompatible            " disable compatability features to vi
set showmatch               " bracket matching (nvim default)
set ignorecase              " case insensitive search
set tabstop=4               " # cols occupied by a tab
set softtabstop=4           " see 4 spaces as a tab
set expandtab               " convert tabs to whitespace
set shiftwidth=4            " width for autoindent
set autoindent              " enable autoindent
set number                  " line numbers
set wildmode=longest,list   " tab-completion settings
filetype plugin indent on   " allow auto-indenting depending on file type
syntax on                   " syntax highlighting (nvim default)
set cursorline              " enable cursorline
set ttyfast                 " speed scrolling
