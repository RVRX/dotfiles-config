-- This is a Lua-based Neovim config (init.lua)
-- Migrated from init.vim using lazy.nvim for plugin management
-- Assumes lazy.nvim is installed: https://github.com/folke/lazy.nvim

-- [[ PLUGIN BOOTSTRAP (Lazy.nvim) ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = "\\"

require("lazy").setup({
  -- UI / Appearance
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "nvim-lualine/lualine.nvim" },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
  { "nvimdev/dashboard-nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "folke/noice.nvim", dependencies = { "MunifTanjim/nui.nvim" } },
  { "rcarriga/nvim-notify" },
  { "romgrk/barbar.nvim" },
  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate" },

  -- Git
  { "lewis6991/gitsigns.nvim" },
  { "kdheepak/lazygit.nvim" },
  { "sindrets/diffview.nvim" },

  -- File navigation
  { "nvim-tree/nvim-tree.lua" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- LSP & Completion
  { "neovim/nvim-lspconfig", lazy = false },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Folding
  { "kevinhwang91/nvim-ufo", dependencies = { "kevinhwang91/promise-async", "luukvbaal/statuscol.nvim" } },

  -- Marks plugin
  { 
  "chentoast/marks.nvim",
  config = function()
    require("marks").setup()
  end
},

  -- Utility
  { "m4xshen/hardtime.nvim" },
  { "mg979/vim-visual-multi", branch = "master" },
})

-- [[ OPTIONS ]]
vim.opt.mouse = "a"
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "",
  foldsep = " ",
  foldclose = "",
}

-- [[ COLORSCHEME ]]
vim.g.catppuccin_flavour = "mocha"
require("catppuccin").setup({ transparent_background = false })
vim.cmd.colorscheme("catppuccin-mocha")

-- [[ TREESITTER ]]
-- nvim-treesitter main branch only manages parser installation;
-- highlighting is now handled by neovim's built-in treesitter.
require("nvim-treesitter").setup()

-- Disable treesitter highlighting for large files
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(ev)
    local max_filesize = 250 * 1024
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
    if ok and stats and stats.size > max_filesize then
      vim.treesitter.stop(ev.buf)
    end
  end,
})

-- [[ LSP ]]
-- Set capabilities globally for all servers (nvim 0.11+ API)
vim.lsp.config('*', {
  capabilities = vim.tbl_deep_extend("force",
    require("cmp_nvim_lsp").default_capabilities(),
    { textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } } }
  ),
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local map = function(keys, func) vim.keymap.set("n", keys, func, { buffer = ev.buf }) end
    map("gd",         vim.lsp.buf.definition)
    map("gD",         vim.lsp.buf.declaration)
    map("K",          vim.lsp.buf.hover)
    map("gr",         vim.lsp.buf.references)
    map("gs",         vim.lsp.buf.signature_help)
    map("gI",         vim.lsp.buf.implementation)
    map("<leader>r",  vim.lsp.buf.rename)
    map("<leader>a",  vim.lsp.buf.code_action)
    map("[d",         function() vim.diagnostic.jump({ count = -1, float = true }) end)
    map("]d",         function() vim.diagnostic.jump({ count =  1, float = true }) end)
  end,
})

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls" },
  -- automatic_enable = true is the default in v2; servers are enabled via vim.lsp.enable()
})

-- [[ COMPLETION ]]
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"]     = cmp.mapping.abort(),
    ["<CR>"]      = cmp.mapping.confirm({ select = false }),
    ["<Tab>"]     = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"]   = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
})

-- [[ NOICE & NOTIFY ]]
require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    lsp_doc_border = false,
  },
})
require("notify").setup({
  background_color = "#1e1e2e",
})


-- [[ BARBAR ]]
require("barbar").setup({
  sidebar_filetypes = { NvimTree = true },
})
local opts = { noremap = true, silent = true }
-- Move to previous/next
vim.keymap.set('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
vim.keymap.set('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
vim.keymap.set('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
vim.keymap.set('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
-- Goto buffer in position...
vim.keymap.set('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
vim.keymap.set('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
vim.keymap.set('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
vim.keymap.set('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
vim.keymap.set('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
vim.keymap.set('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
vim.keymap.set('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
vim.keymap.set('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
vim.keymap.set('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
vim.keymap.set('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
-- Pick buffer
vim.keymap.set('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
-- Pin/unpin buffer
vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
vim.keymap.set('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)


-- [[ LUALINE ]]
require("lualine").setup({
  sections = {
    lualine_c = {
      { "filename", path = 1 }
    }
  }
})

-- [[ INDENT-BLANKLINE ]]
require("ibl").setup({
  indent = { char = "│", tab_char = "│" },
  scope = { show_start = false, show_end = false },
  exclude = { filetypes = { "help", "dashboard", "lazy", "mason", "notify" } },
})

-- [[ TELESCOPE ]]
require("telescope").setup({
  pickers = { find_files = { hidden = true, no_ignore = true } }
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fb", builtin.buffers)
vim.keymap.set("n", "<leader>fh", builtin.help_tags)

-- [[ NVIM-TREE ]]
require("nvim-tree").setup({
  hijack_cursor = false,
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set('n', 'e', api.tree.change_root_to_node, {
      buffer = bufnr,
      desc = "NvimTree: CD into directory"
    })
  end
})
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")

-- [[ LAZYGIT ]]
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit" })

-- Use neovim-remote so that pressing "e" in lazygit opens files in this nvim instance
if vim.fn.executable('nvr') == 1 then
  vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end

-- [[ UFO FOLDING ]]
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
require("ufo").setup()
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

-- [[ GITSIGNS ]]
require("gitsigns").setup()
local gs = require("gitsigns")
vim.keymap.set("n", "<leader>p", gs.preview_hunk_inline)
vim.keymap.set("n", "]c", gs.next_hunk)
vim.keymap.set("n", "[c", gs.prev_hunk)
vim.keymap.set("n", "<leader>gm", gs.blame_line)


-- [[ HARDTIME ]]
require("hardtime").setup({
  disable_mouse = false,
  max_time = 500,
  max_count = 5,
  restriction_mode = "hint",
})

-- [[ DASHBOARD ]]
require("dashboard").setup({
  theme = "hyper",
  config = {
    week_header = { enable = true },
    shortcut = {
      { icon = " ", icon_hl = "@variable", desc = "Files", group = "Label", action = "Telescope find_files", key = "f" },
      { desc = "Check Health", group = "DiagnosticHint", action = "checkhealth", key = "a" },
      { desc = " dotfiles", group = "Number", action = "tabe ~/.config/", key = "d" },
    },
  },
})
