" Plugins will be downloaded under the specified directory.
call plug#begin('~/.local/share/nvim/site/plugged')

" Bottom bar guy
Plug 'nvim-lualine/lualine.nvim'

" Startup splash screen
Plug 'nvimdev/dashboard-nvim'

" nvim-treesitter (syntax highlighting)
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Need to run `TSInstall <language>` for every language syntax highlighting is
" wanted for

" Terminal
"Plug 'akinsho/toggleterm.nvim', {'tag' : 'v2.9.0'}

" NvimTree, file system explorer
Plug 'nvim-tree/nvim-tree.lua'

" diffview
Plug 'sindrets/diffview.nvim'

" Git status in gutter
Plug 'airblade/vim-gitgutter'

" Icons (for some plugins)
Plug 'nvim-tree/nvim-web-devicons' " TODO: requires a NERD Font on terminal 

" barbar (Better Tabs)
Plug 'romgrk/barbar.nvim'

" git signs [dependency for barbar]
Plug 'lewis6991/gitsigns.nvim' " OPTIONAL: for git status

" Bookmarks
Plug 'MattesGroeger/vim-bookmarks'

" linter/make[r]
Plug 'neomake/neomake'

" git-messenger (git blame; <leader>hgm)
Plug 'rhysd/git-messenger.vim'

" plenary [dependency for telescope]
Plug 'nvim-lua/plenary.nvim'

" telescope (file search, fuzzy file finder)
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }

" lazygit
Plug 'kdheepak/lazygit.nvim'

" UI compnents (hardtime, noice dependency)
Plug 'MunifTanjim/nui.nvim'

" hardtime, command suggestions to better vim workflow
Plug 'm4xshen/hardtime.nvim'

" notifications
Plug 'rcarriga/nvim-notify'

" indent '|' lines for better visualization of indents
Plug 'lukas-reineke/indent-blankline.nvim'

" total redesign of the command line
Plug 'folke/noice.nvim'

" sublime-text-esque multiple cursor selections
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" lsp package manager and co.
"Plug 'williamboman/mason.nvim' " package manager
"Plug 'williamboman/mason-lspconfig.nvim' " helper for thing
"Plug 'neovim/nvim-lspconfig' " thing


"  Uncomment the two plugins below if you want to manage the language servers from neovim
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v3.x'}

" promise (line folding, nvim-ufo requirement)
Plug 'kevinhwang91/promise-async'
" line folding
Plug 'kevinhwang91/nvim-ufo'

" theme
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'dracula/vim', { 'as': 'dracula' }

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" init toggle term, define open key
"lua require("toggleterm").setup({open_mapping = [[<c-\>]]})


" gitgutter options
set updatetime=100
autocmd VimEnter * GitGutterLineNrHighlightsEnable
autocmd VimEnter * GitGutterLineHighlightsEnable
nmap <leader>p <Plug>(GitGutterPreviewHunk)

lua << EOF

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require'dashboard'.setup{
    theme = 'hyper',
    config = {
      week_header = {
       enable = true,
      },
      shortcut = {
        -- { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
        {
          icon = ' ',
          icon_hl = '@variable',
          desc = 'Files',
          group = 'Label',
          action = 'Telescope find_files',
          key = 'f',
        },
        {
          desc = 'Check Health',
          group = 'DiagnosticHint',
          action = 'checkhealth',
          key = 'a',
        },
        {
          desc = ' dotfiles',
          group = 'Number',
          --action = 'Telescope dotfiles',
          action = 'tabe ~/.config/',
          key = 'd',
        },
      },
    },
} -- start dashboard-nvim
 
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  --ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    --disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 250 * 1024 -- 250 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

vim.notify = require("notify")


local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

--require("mason").setup()
--require("mason-lspconfig").setup()

-- indent blankline
require("ibl").setup({
    indent = {
    char = "│",
    tab_char = "│",
  },
  scope = { show_start = false, show_end = false },
  exclude = {
    filetypes = {
      "help",
      "alpha",
      "dashboard",
      "neo-tree",
      "Trouble",
      "trouble",
      "lazy",
      "mason",
      "notify",
      "toggleterm",
      "lazyterm",
    },
  },})

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})


-- telescope settings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})





-- the below was sourced from https://lsp-zero.netlify.app/v3.x/guide/quick-recipes.html#enable-folds-with-nvim-ufo
-- vim ufo folding
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require('ufo').setup()

-- Using ufo provider need remap `zR` and `zM`.
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

lsp_zero.set_server_config({
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
    }
  }
})




-- set termguicolors to enable highlight groups
--vim.opt.termguicolors = true

-- lualine (status line plugin)
require('lualine').setup()


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

-- DiffView keymaps
vim.keymap.set('n', '<leader>dv', '<cmd>DiffviewFileHistory %<cr>')
vim.keymap.set('n', '<leader>do', '<cmd>DiffviewOpen<cr>')
vim.keymap.set('n', '<leader>dc', '<cmd>DiffviewClose<cr>')

-- hardtime setup
-- https://github.com/m4xshen/hardtime.nvim
require("hardtime").setup({
   disable_mouse=false,
   max_time=500,
   max_count=2,
   restriction_mode="hint"
})

---- toggle term keybinds
--function _G.set_terminal_keymaps()
--  local opts = {buffer = 0}
--  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
--  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
--  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
--  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
--  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
--  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
--  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
--end
--
---- if you only want these mappings for toggle term use term://*toggleterm#* instead
--vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

EOF

"colorscheme dracula         " enable theme

let g:catppuccin_flavour = "macchiato" " latte, frappe, macchiato, mocha

lua << EOF
require("catppuccin").setup()
EOF

colorscheme catppuccin
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
set wildmode=longest,full   " tab-completion settings
filetype plugin indent on   " allow auto-indenting depending on file type
syntax on                   " syntax highlighting (nvim default)
set cursorline              " enable cursorline
set ttyfast                 " speed scrolling
set hidden                  " needed for toggleterm to function properly
set relativenumber


" BarBar keybinds
" Move to previous/next
nnoremap <silent>    <A-,> <Cmd>BufferPrevious<CR>
nnoremap <silent>    <A-.> <Cmd>BufferNext<CR>

" Re-order to previous/next
nnoremap <silent>    <A-<> <Cmd>BufferMovePrevious<CR>
nnoremap <silent>    <A->> <Cmd>BufferMoveNext<CR>

" Goto buffer in position...
nnoremap <silent>    <A-1> <Cmd>BufferGoto 1<CR>
nnoremap <silent>    <A-2> <Cmd>BufferGoto 2<CR>
nnoremap <silent>    <A-3> <Cmd>BufferGoto 3<CR>
nnoremap <silent>    <A-4> <Cmd>BufferGoto 4<CR>
nnoremap <silent>    <A-5> <Cmd>BufferGoto 5<CR>
nnoremap <silent>    <A-6> <Cmd>BufferGoto 6<CR>
nnoremap <silent>    <A-7> <Cmd>BufferGoto 7<CR>
nnoremap <silent>    <A-8> <Cmd>BufferGoto 8<CR>
nnoremap <silent>    <A-9> <Cmd>BufferGoto 9<CR>
nnoremap <silent>    <A-0> <Cmd>BufferLast<CR>

" Pin/unpin buffer
nnoremap <silent>    <A-p> <Cmd>BufferPin<CR>

" Close buffer
nnoremap <silent>    <A-c> <Cmd>BufferClose<CR>


" macos only?
vnoremap <C-c> :w !pbcopy<CR><CR> noremap <C-v> :r !pbpaste<CR><CR>
set clipboard=unnamed
