# NVIM

## Requirements

- **Neovim 0.11+** — check [GitHub releases](https://github.com/neovim/neovim/releases/)
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** — required for Telescope live grep (`\fg`)
- **[fd](https://github.com/sharkdp/fd)** — required for Telescope file finder (`\ff`)
- **[tree-sitter CLI](https://github.com/tree-sitter/tree-sitter)** — required to compile parsers (`npm install -g tree-sitter-cli`)
- **A C compiler** (`build-essential` on Linux, Xcode CLT on macOS)
- **[lazygit](https://github.com/jesseduffield/lazygit)** (optional) — for `\gg`
- **[neovim-remote](https://github.com/mhinz/neovim-remote)** (optional) — `pip install neovim-remote`, allows pressing `e` in lazygit to open files in the parent nvim instance

## Setup

1. Install requirements above

2. Place `init.lua` in your nvim config directory:
```sh
mkdir -p ~/.config/nvim/
cp init.lua ~/.config/nvim/
```

3. Open nvim — [lazy.nvim](https://github.com/folke/lazy.nvim) will bootstrap itself and install all plugins automatically

4. Install treesitter parsers:
```
:TSInstall lua vim vimdoc query c
```

5. Install LSP servers via Mason (e.g. `lua_ls` is auto-installed):
```
:Mason
```

6. Set nvim as default git editor:
```sh
git config --global core.editor nvim
```

## Key mappings

| Key | Action |
|-----|--------|
| `\ff` | Find files (Telescope) |
| `\fg` | Live grep (Telescope) |
| `\fb` | Browse open buffers |
| `\e`  | Toggle file tree (NvimTree) |
| `\gg` | Open LazyGit |
| `\p`  | Preview git hunk inline |
| `\gm` | Git blame current line |
| `]c` / `[c` | Next / prev git hunk |
| `gd`  | Go to definition |
| `K`   | Hover documentation |
| `gr`  | References |
| `\r`  | Rename symbol |
| `\a`  | Code action |
| `]d` / `[d` | Next / prev diagnostic |
| `zR` / `zM` | Open / close all folds |
| `Alt+,` / `Alt+.` | Previous / next buffer tab |
| `Alt+c` | Close buffer tab |
