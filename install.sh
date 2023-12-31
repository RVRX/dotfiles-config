#!/usr/bin/bash


move_config() {
    echo "moving $2 to $1"
    #mv $2 $1
}

## checks for an existing config at a location before replacing
## (config_location_old, config_location_replacement)
check_for_existing_and_move() {
    if [ -e "$1" ]
    then
        echo "Config $1 already exists, do you want to replace? [y/N]"
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then 
            move_config $1 $2
        fi
    else
        echo "Config $1 does not exist... moving"
        move_config $1 $2
    fi
}

#
#
#
# ### NVIM ###
#
# Get installed nvim version:
NVIM_VER=$(nvim --version | grep 'NVIM v' | cut -c7-)
#
# minimum compatible nvim version:
nvim_min="0.7"
#
# version checking functions:
verlte() {
    printf '%s\n' "$1" "$2" | sort -C -V
}
verlt() {
    [ "$1" = "$2" ] && return 1 || verlte $1 $2
}
#
# ensure installed is above minimum
if $(verlt $nvim_min $NVIM_VER)
then
    echo "$NVIM_VER > 0.7"
    #
    # Move config file
    check_for_existing_and_move "$HOME/.config/nvim/init.vim" "nvim/init.vim"
    #
    # Have user PlugInstall
    echo "nvim will open after you hit enter. Please type ':PlugInstall' then close."
    read;
    nvim
else
    echo "Neovim version ($NVIM_VER) is less than required (0.7). See nvim/README.md"
fi
# 
#
#
#
# ### TMUX ###
#
check_for_existing_and_move "$HOME/.tmux.conf" "tmux/.tmux.conf"
#
#
#
#
# ### zsh ###
#
check_for_existing_and_move "$HOME/.zshrc" "zsh/.zshrc"
#
#
#
#
# ### iTerm2 ###
#
echo "Add iTerm2 config? [y/N]"
read iterm_answer
if [ "$iterm_answer" != "${iterm_answer#[Yy]}" ] ;then 
    echo "iTerm must be done manually, see: https://stackoverflow.com/questions/22943676/how-to-export-iterm2-profiles"
fi

