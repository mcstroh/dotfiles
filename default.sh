#
#  __  __   ____     ____  _             _
# |  \/  | / ___|   / ___|| |_ _ __ ___ | |__
# | |\/| || |       \___ \| __| '__/ _ \| '_ \
# | |  | || |___ _   ___) | |_| | | (_) | | | |
# |_|  |_(_)____(_) |____/ \__|_|  \___/|_| |_|
#
#  .default shell file catch-all for BASH/ZSH
#
# Last modified: March 16th, 2022 - M. C. Stroh (michael.stroh@northwestern.edu)
#
#

##########################################################################################
#
# Start with the CIERA bashrc file
#
if [ -f /projects/b1094/software/dotfiles/.bashrc ]; then
    . /projects/b1094/software/dotfiles/.bashrc

# If we're not on Quest, run the local version
elif [ -f "$HOME/dotfiles/bashrc.sh" ]; then
    . $HOME/dotfiles/bashrc.sh
fi
#
##########################################################################################



##########################################################################################
#
# Default setup
#
export TERM="xterm-256color" # getting colors
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
set savehist=500000
set history=500000
set histfile=~/dotfiles/.histfile


# Use EMACS as default text editor
export EDITOR="emacs -nw"

#
##########################################################################################



##########################################################################################
#
# Server connections
#
if [ -f "$HOME/dotfiles/servers.sh" ]; then
    . $HOME/dotfiles/servers.sh
fi
#
##########################################################################################



##########################################################################################
#
# Brew package manager
#    Need to load early due to later dependencies
#
if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
#
##########################################################################################



##########################################################################################
#
# Check shell to determine subsequent dotfiles to load
#
if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
   
   # Assume Zsh
    if [ -f "$HOME/dotfiles/zshrc.zsh" ]; then
        . $HOME/dotfiles/zshrc.zsh
    fi   


elif [ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]; then

   # Assume BASH
    if [ -f "$HOME/dotfiles/bashrc.sh" ]; then
        . $HOME/dotfiles/bashrc.sh
    fi   

else
    echo "Running unknown shell."
fi
#
##########################################################################################



##########################################################################################
#
# Rust
#
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
#
##########################################################################################



##########################################################################################
#
# Exa - used to replace ls
#
if command -v exa >/dev/null 2>&1
then  
    alias ls='exa -al --color=always --group-directories-first' # my preferred listing
    alias la='exa -a --color=always --group-directories-first'  # all files and dirs
    alias ll='exa -l --color=always --group-directories-first'  # long format
    alias lt='exa -aT --color=always --group-directories-first' # tree listing
    alias l.='exa -a | egrep "^\."'
fi
#
##########################################################################################



##########################################################################################
#
# Broot - another file viewer
#
if [ -f "$HOME/.config/broot/launcher/bash/br" ]; then
    . $HOME/.config/broot/launcher/bash/br
fi

if command -v broot >/dev/null 2>&1
then
    alias br='broot -dhp'
    alias bs='broot --sizes'
fi
#
##########################################################################################



##########################################################################################
#
# Local CARTA installation
#
# If MacOS
if [ -f '/Applications/CARTA.app/Contents/MacOS/CARTA' ]; then
    alias carta='/Applications/CARTA.app/Contents/MacOS/CARTA'
fi
#
##########################################################################################



##########################################################################################
#
# Allocation statistics directory
#
if [ -d  '/home/mcs8686/allocation_data' ]; then
    export ALLOCATION_DATA_DIR='/home/mcs8686/allocation_data'
fi
#
##########################################################################################



##########################################################################################
#
# Configure local anaconda installation if it exists
#
# By referencing $HOME, this should work for typical local MacOS and Linux installations
if [ -d "$HOME/../data/anaconda3" ]; then
    if [ -f "$HOME/../data/anaconda3/etc/profile.d/conda.sh" ]; then
        . $HOME/../data/anaconda3/etc/profile.d/conda.sh
        conda activate py39
    else
        export PATH="$HOME/../data/anaconda3/bin:$PATH"
    fi
fi
#
##########################################################################################



##########################################################################################
#
# Configure BAaDE survey environment
#
if [ -f /projects/b1094/stroh/baade/setup.sh ]; then
    . /projects/b1094/stroh/baade/setup.sh
fi
#
##########################################################################################



##########################################################################################
#
# Dooom
#
if [ -d "$HOME/.emacs.d/bin" ]; then
    export PATH="$HOME/.emacs.d/bin:$PATH"
fi
#
##########################################################################################



##########################################################################################
#
# MacPorts
#
if [ -d /opt/local/bin ]; then
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
    export MANPATH="/opt/local/share/man:$MANPATH"
fi
#
##########################################################################################



##########################################################################################
#
# Clean up path if we're in ZSH
if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
    typeset -U path
fi
#
##########################################################################################
