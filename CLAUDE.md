# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal dotfiles repository: a flat set of per-tool directories, each holding one config file plus a `README.md` with that tool's install steps and prerequisites. There is no build, test, or lint step — "running" a change means copying the file to its destination and restarting the tool.

`install.sh` existed at HEAD but is deleted in the working tree (it only ever handled nvim, and assumed the old vim-plug `init.vim`). Treat installation as manual, per the per-directory READMEs. The top-level `README.md` still references `install.sh` and is stale.

## Config file destinations

| Repo path | Destination |
|-----------|-------------|
| `nvim/init.lua` | `~/.config/nvim/init.lua` |
| `nvim/spell/en.utf-8.add` | `~/.config/nvim/spell/en.utf-8.add` |
| `zsh/.zshrc` | `~/.zshrc` |
| `tmux/.tmux.conf` | `~/.tmux.conf` |
| `lazygit/config.yml` | `~/.config/lazygit/config.yml` (macOS: `~/Library/Application Support/lazygit/config.yml`) |
| `iTerm2/com.googlecode.iterm2.plist` | imported through iTerm2 preferences, not copied |

## Important: files are copies, not symlinks

Nothing here is symlinked into place. The live config and the repo copy drift independently, and the repo copy is deliberately the *portable* version:

- Machine-specific values are stripped or replaced with `~`-relative paths.
- Local-only lines (work aliases, `pyenv`/`pipx` PATH entries, per-machine `export`s) live only in the live file, not here.
- Opt-in settings are committed **commented out with a `TODO`** rather than enabled — e.g. `DOCKER_DEFAULT_PLATFORM` in `zsh/.zshrc`, the tmux prefix and colors in `tmux/.tmux.conf`.

So when syncing a live config back into the repo, diff rather than overwrite, and keep the local-only and TODO-commented lines out of the commit.

## nvim config architecture

`nvim/init.lua` is a single-file config (~320 lines) organized into `-- [[ SECTION ]]` blocks: plugin bootstrap → options → colorscheme → then one block per plugin. Plugin *specs* are all declared in the one `require("lazy").setup({...})` table near the top; each plugin's *setup and keymaps* live in its own section further down, not inline in the spec. Follow that split when adding a plugin.

- **lazy.nvim self-bootstraps** — it git-clones itself on first launch if absent; there is no separate install step and no lockfile committed.
- **Leader is `\`** (`vim.g.mapleader = "\\"`).
- **Requires nvim 0.11+** and uses the modern APIs deliberately (a past commit, `46770a2`, fixed `checkhealth` deprecations). Don't reintroduce older equivalents: use `vim.uv` (not `vim.loop`), `vim.lsp.config('*', …)` + mason-lspconfig v2's automatic enable (not per-server `lspconfig.<server>.setup{}`), and `vim.diagnostic.jump({count=…})` (not `goto_next`/`goto_prev`).
- **Treesitter is on the `main` branch**, where the plugin only installs parsers; highlighting comes from neovim's built-in treesitter. Parsers need the `tree-sitter` CLI and a C compiler, and are installed with `:TSInstall`. A `BufReadPost` autocmd calls `vim.treesitter.stop()` for files over 250 KB.
- **LSP keymaps are buffer-local**, set from a single `LspAttach` autocmd — add new ones there, not globally.
- **lazygit integration**: `\gg` opens it; `GIT_EDITOR` is set to `nvr` when available so `e` in lazygit opens the file in the parent nvim. A `TermEnter`/`TermLeave` autocmd pair toggles `hlsearch` off inside terminal buffers so lazygit's UI isn't highlighted.

The custom spellfile (`nvim/spell/en.utf-8.add`) is the hand-added word list. Its compiled `.spl` sibling is generated, so it is not tracked — run `:mkspell! ~/.config/nvim/spell/en.utf-8.add` after copying, or just let `zg` rebuild it. Note `init.lua` never sets `spell`; it is enabled per-buffer with `:set spell`.

External binaries the config expects: `ripgrep` (Telescope live grep), `fd` (file finder), `tree-sitter` CLI, a C compiler, and optionally `lazygit` and `nvr`. See `nvim/README.md` for the full list and the keymap table.

## zsh config

`zsh/.zshrc` is oh-my-zsh–based. The custom plugins it lists (`zsh-syntax-highlighting`, `zsh-autosuggestions`, `zsh-nvm`) are **not vendored** and must be git-cloned into `$ZSH_CUSTOM/plugins/` first — a fresh copy of this file errors without them. See `zsh/README.md` for the clone commands. The `zstyle ':omz:alpha:lib:git' async-prompt no` line at the top is a workaround for an upstream oh-my-zsh bug (ohmyzsh#12267); don't remove it as dead config.

## Commit conventions

Single-line subjects, prefixed with the tool when scoped to one: `zsh: Add vi mode`, `nvim: let telescope see hidden files`, `lazygit: add lazygit config`. Unprefixed subjects are used for repo-wide or multi-tool changes.
