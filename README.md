# dotfiles-config

Personal config for nvim, zsh, tmux, lazygit, and iTerm2.

## Installation

There is no installer. Each directory has its own `README.md` covering that tool's
prerequisites and setup — start there. (An `install.sh` existed until it was orphaned
by the vim-plug → lazy.nvim migration; it is gone, not broken-and-waiting-to-be-fixed.)

Most configs are copied into place, e.g.:

```sh
cp nvim/init.lua  ~/.config/nvim/init.lua
cp zsh/.zshrc     ~/.zshrc
cp tmux/.tmux.conf ~/.tmux.conf
cp lazygit/config.yml ~/.config/lazygit/config.yml   # macOS: ~/Library/Application Support/lazygit/
```

The two files nvim *writes* are symlinked instead, so its writes land in this repo
rather than drifting out of it:

```sh
ln -sf ~/dotfiles-config/nvim/lazy-lock.json ~/.config/nvim/lazy-lock.json
mkdir -p ~/.config/nvim/spell
ln -sf ~/dotfiles-config/nvim/spell/en.utf-8.add ~/.config/nvim/spell/en.utf-8.add
```

Run `:Lazy restore` after pulling on a machine, before installing or updating plugins —
otherwise lazy.nvim rewrites `lazy-lock.json` from that machine's older state.

nvim 0.11+ is required; the config uses APIs that older builds do not have.
