#
#  __  __   ____     ____  _             _
# |  \/  | / ___|   / ___|| |_ _ __ ___ | |__
# | |\/| || |       \___ \| __| '__/ _ \| '_ \
# | |  | || |___ _   ___) | |_| | | (_) | | | |
# |_|  |_(_)____(_) |____/ \__|_|  \___/|_| |_|
#
#  .default shell file catch-all for BASH/ZSH
#
# M. C. Stroh (michael.stroh@northwestern.edu)
#
#

##########################################################################################
#
# Start with the CIERA bashrc file
#
QUEST_HOSTS="quser21 quser22 quser23 quser24 quser31 quser32 quser33 quser34"
hostname=`hostname`
quest_loginnode=false
for x in $QUEST_HOSTS; do
    if [ "$hostname" = "$x" ]; then
        quest_loginnode=true
        break
    fi
done

if [ -f /projects/b1094/software/dotfiles/.bashrc ]; then
    . /projects/b1094/software/dotfiles/.bashrc

# If we're not on Quest, run the local version
elif [ -f "$HOME/dotfiles/basics.sh" ]; then
    . $HOME/dotfiles/basics.sh
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


# Use EMACS as default text editor
export EDITOR="emacs"

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
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
#
##########################################################################################


##########################################################################################
#
# Check shell to determine subsequent dotfiles to load
#
if [ ! -z ${ZSH_VERSION+x} ]; then
   # Assume Zsh
    if [ -f "$HOME/dotfiles/zshrc.zsh" ]; then
        . $HOME/dotfiles/zshrc.zsh
    fi   

else
   # Assume BASH
    if [ -f "$HOME/dotfiles/bashrc.sh" ]; then
        . $HOME/dotfiles/bashrc.sh
    fi   

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
    alias ls='exa -al --color=always --group-directories-first --header' # Default
    alias la='exa -a --color=always --group-directories-first --header'  # All but not long
    alias ll='exa -l --color=always --group-directories-first --header'  # Long but not all
    alias lt='exa -aT --color=always --group-directories-first --header' # Tree format
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
if [ -f /Applications/CARTA.app/Contents/MacOS/CARTA ]; then
    alias carta='/Applications/CARTA.app/Contents/MacOS/CARTA'
fi
#
##########################################################################################


##########################################################################################
#
# Allocation statistics directory
#
if [ -d  /home/mcs8686/allocation_data ]; then
    export ALLOCATION_DATA_DIR='/home/mcs8686/allocation_data'
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
# Doom
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
# IDL
#
if [ -r /Applications/harris/idl/bin/idl_setup.bash ] ; then
    . /Applications/harris/idl/bin/idl_setup.bash
fi
#
##########################################################################################

##########################################################################################
#
# DS9
#
if ! command -v ds9 >/dev/null 2>&1 && [ -x /Applications/SAOImageDS9.app ]; then
    alias ds9='open /Applications/SAOImageDS9.app'
fi
#
##########################################################################################


##########################################################################################
#
# Activate conda environment
#
function load_conda {
    if { conda env list | grep "py311"; } >/dev/null; then
        conda activate py311
    elif { conda env list | grep "py310"; } >/dev/null; then
        conda activate py310
    elif { conda env list | grep "py39"; } >/dev/null; then
        conda activate py39
    elif { conda env list | grep "base"; } >/dev/null; then
        conda activate base
    fi
}

if [ ! -z ${ZSH_VERSION+x} ]; then
    load_conda
else
    if command -v shopt >/dev/null 2>&1; then
        if [ "$2" == "on" ] && command -v conda >/dev/null 2>&1; then
            load_conda
        fi
    fi
fi
##########################################################################################



##########################################################################################
#
# Clean up path if we're in ZSH
if [ ! -z ${ZSH_VERSION+x} ]; then
    typeset -U path
fi
#
##########################################################################################

function nodes {
    srun --account=b1094 -N 1 -n 1 --partition=ciera-himem --time=14-00:00:00 --mem=50G --job-name="specialist" --x11 --pty bash -l
}

function nodes2 {
    srun --account=b1094 -N 1 -n 1 --partition=ciera-std --time=14-00:00:00 --mem=50G --job-name="specialist" --x11 --pty bash -l
}

function fix_permissions {
    chmod -R go-w /projects/b1094/software/miniconda
    chmod -R go+rX /projects/b1094/software/miniconda
    chmod -R go-w /projects/b1094/software/environments
    chmod -R go+rX /projects/b1094/software/environments
    chmod -R go-w /projects/b1094/software/miniforge3
    chmod -R go+rX /projects/b1094/software/miniforge3
}
