# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
zstyle ':omz:alpha:lib:git' async-prompt no
# ^ fix for dissapearing git prompt https://github.com/ohmyzsh/ohmyzsh/issues/12267

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="michelebologna"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
	zsh-nvm
    colored-man-pages
    # dirhistory  # alt-arrowkey navigation of dirs
    macos
    rsync  # adds `rysnc-*` command aliases
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# TODO: uncomment below to make docker use x64 images. Useful for sharing containers when pulling on M-chip macbooks
# export DOCKER_DEFAULT_PLATFORM=linux/amd64
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vi=nvim
alias vim=nvim

#alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# Uncomment the following line to run neofetch on shell start
# neofetch

# linux manpages
# See:
#   https://apple.stackexchange.com/a/427413/519342
#   linux$ tar -cvf manpages.tar /usr/share/man
#   mac$ scp
lman() { man -M ~/Documents/linux-man "$@" }


# Uncomment the following line to enable 1Password completions
# eval "$(op completion zsh)"; compdef _op op

# Keep history per-session (oh-my-zsh enables share_history by default)
unsetopt SHARE_HISTORY

# fzf keybindings: Ctrl-R history, Ctrl-T files, Alt-C cd (needs fzf 0.48+)
(( $+commands[fzf] )) && source <(fzf --zsh)

# Select and sign in to an AWS SSO profile by nickname: `awsuse <nickname>`.
# Not configured by default. To set it up, fill in _awsuse_profiles below in
# your local ~/.zshrc only (never commit real profile names or account IDs):
#
#   _awsuse_profiles=(
#     example1 ExampleRole1-<account-id>
#     example2 ExampleRole2-<account-id>
#   )
#
# Each value must be a profile name from ~/.aws/config (`aws configure sso`
# creates them). Nicknames tab-complete once configured.
typeset -gA _awsuse_profiles
_awsuse_profiles=()

awsuse() {
  if (( ! ${#_awsuse_profiles} )); then
    print -u2 "awsuse: not configured. Add profiles to _awsuse_profiles in ~/.zshrc (see the comments there)."
    return 1
  fi

  local profile
  [[ -n "$1" ]] && profile="${_awsuse_profiles[$1]}"
  if [[ -z "$profile" ]]; then
    print -u2 "Usage: awsuse ${(j:|:)${(@ok)_awsuse_profiles}}"
    return 2
  fi

  if aws sso login --profile "$profile"; then
    export AWS_PROFILE="$profile"
    print "Using AWS profile: $profile"
  fi
}

_awsuse_completions() {
  local -a profiles
  profiles=(${(k)_awsuse_profiles})
  _describe 'AWS profile nickname' profiles
}
compdef _awsuse_completions awsuse
