#
#  __  __   ____     ____  _             _
# |  \/  | / ___|   / ___|| |_ _ __ ___ | |__
# | |\/| || |       \___ \| __| '__/ _ \| '_ \
# | |  | || |___ _   ___) | |_| | | (_) | | | |
# |_|  |_(_)____(_) |____/ \__|_|  \___/|_| |_|
#
#  Default shell file catch-all for BASH/ZSH
#
# M. C. Stroh (mstroh@nrao.edu)
#
#

##########################################################################################
#
# Start with the CIERA bashrc file
#
QUEST_HOSTS="quser31 quser32 quser33 quser34"
hostname=`hostname`
quest_loginnode=false
for x in $QUEST_HOSTS; do
    if [ "$hostname" = "$x" ]; then
        quest_loginnode=true
        break
    fi
done

# If we're on Quest, use CIERA version
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
# Exa - Rust replacement for ls
#
if command -v eza >/dev/null 2>&1; then
    alias ls='eza -al --color=always --group-directories-first --header' # Default
    alias la='eza -a --color=always --group-directories-first --header'  # All but not long
    alias ll='eza -l --color=always --group-directories-first --header'  # Long but not all
    alias lt='eza -aT --color=always --group-directories-first --header' # Tree format
    alias l.='eza -a | egrep "^\."'
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

if command -v broot >/dev/null 2>&1; then
    alias br='broot -dhp'
    alias bs='broot --sizes'
fi
#
##########################################################################################


##########################################################################################
#
# zoxide
#
if command -v zoxide >/dev/null 2>&1; then
    alias cd='z'
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
if [ -d  "$HOME/allocation_data" ]; then
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
#alias emacs="emacs -nw"
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
if [ -r /Applications/NV5/idl/bin/idl_setup.bash ] ; then
    . /Applications/NV5/idl/bin/idl_setup.bash
elif [ -r /Applications/harris/idl/bin/idl_setup.bash ] ; then
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
function load_mamba {
    if { mamba env list | grep "^py313"; } >/dev/null; then
        conda activate py313
    elif { mamba env list | grep "^py312"; } >/dev/null; then
        conda activate py312
    elif { mamba env list | grep "^py311"; } >/dev/null; then
        conda activate py311
    elif { mamba env list | grep "^py310"; } >/dev/null; then
        conda activate py310
    elif { mamba env list | grep "^py39"; } >/dev/null; then
        conda activate py39
    elif { mamba env list | grep "base"; } >/dev/null; then
        conda activate base
    fi
}
if [[ "$quest_loginnode" == false ]]; then
    load_mamba
fi

##########################################################################################


##########################################################################################
#
# Add support for pipx installations
#
if [ -d $HOME/.local/bin ]; then
    export PATH=$PATH:$HOME/.local/bin
fi
#
##########################################################################################


##########################################################################################
#
# Pixi
# A project based package manager.
#
if [ -d "$HOME/.pixi" ]; then
    export PATH="$HOME/.pixi/bin:$PATH"
fi
#
##########################################################################################


##########################################################################################
#
# Clean up path if we're in ZSH
if [ ! -z ${ZSH_VERSION+x} ]; then
    typeset -U path
fi
#
##########################################################################################

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# pnpm
if [ -d "$HOME/.local/share/pnpm" ]; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    case ":$PATH:" in
      *":$PNPM_HOME:"*) ;;
      *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
fi


if [ -f $HOME/../data/swc-shell-split-window/swc-shell-split-window.sh ]; then
    alias tutorial="$HOME/../data/swc-shell-split-window/swc-shell-split-window.sh"
fi

function nodes {
    srun --account=b1094 -N 1 -n 1 --partition=ciera-himem --time=14-00:00:00 --mem=50G --job-name="specialist" --x11 --pty bash -l
}

function nodes2 {
    srun --account=b1094 -N 1 -n 1 --partition=ciera-std --time=14-00:00:00 --mem=50G --job-name="specialist" --x11 --pty bash -l
}

function baade_node {
    srun --account=b1094 -N 1 -n 1 --partition=ciera-std --time=14-00:00:00 --mem=50G --job-name="specialist" --x11 --pty bash -l
}

function specialist_node {
    srun --account=b1094 -N 1 --exclusive --partition=ciera-specialist --time=14-00:00:00 --job-name="specialist" --x11 --pty bash -l
}

function fix_permissions {
    chmod -R go-w /projects/b1094/software/miniforge3
    chmod -R go+rX /projects/b1094/software/miniforge3
    chmod -R go-w /projects/b1094/software/environments
    chmod -R go+rX /projects/b1094/software/environments
}

function checksum {
    if [ -z "$1" ] || [ ! "$1" = "md5" ]; then
	find -type f -exec sha256sum "{}" + > checksum.sha256
    else
	find -type f -exec md5sum "{}" + > checksum.md5
    fi
}

