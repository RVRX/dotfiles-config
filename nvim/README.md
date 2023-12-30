# NVIM
0. Install a *recent* neovim version. Check Nevim's [GitHub releases](https://github.com/neovim/neovim/releases/). Try the AppImage dl, move to `/usr/local/bin/` after a `chmod u+x`
1. Install [Plug](https://github.com/junegunn/vim-plug#neovim)
2. mkdir `~/.config/nvim/` and place `init.vim` in it
```
mkdir ~/.config/nvim/
cp init.vim ~/.config/nvim
```
3. Run `:PlugInstall` in nvim
4. Add nvim as default git editor: `git config --global core.editor nvim`
