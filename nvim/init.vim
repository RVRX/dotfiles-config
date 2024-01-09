" Plugins will be downloaded under the specified directory.
call plug#begin('~/.local/share/nvim/site/plugged')

" Bottom bar guy
Plug 'vim-airline/vim-airline'

" Terminal
Plug 'akinsho/toggleterm.nvim', {'tag' : 'v2.9.0'}

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

" init toggle term, define open key
lua require("toggleterm").setup({open_mapping = [[<c-\>]]})


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

-- toggle term keybinds
function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

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
set hidden                  " needed for toggleterm to function properly
