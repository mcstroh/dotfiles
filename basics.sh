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


# Give us a long history
set savehist=500000
set history=500000

# Aliases
alias rm='rm -i'
alias ssh='ssh -X'
alias cdirs='for file in *; do if [ -d "$file" ]; then tar -czf "${file}.tar.gz" "$file"; fi; done'
alias crdirs='for file in *; do if [ -d "$file" ]; then tar -czf "${file}.tar.gz" "$file" && rm -rf "$file" || rm -rf "${file}.tar.gz"; fi; done'

if [ ! -z ${ZSH_VERSION+x} ]; then
    export MAMBA_SHELL="zsh"
else
    export MAMBA_SHELL="bash"
fi

# Use Emacs as the default text editor
export VISUAL=emacs
export EDITOR="$VISUAL"


# General extraction function
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}


# root privileges
alias doas="doas --"


# navigation
function up {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}


function tar_and_rm {
    dir="$1"
    if [ -d "$dir" ]; then
        tar -czf "${dir}.tar.gz" "$dir" && rm -rf "$dir" || rm -rf "${dir}.tar.gz";
    fi
}


function decompress_pipeline {
    rm -rf bandpass_plots
    rm -rf data_plots
    rm -rf corrected_plots
    tar xzf bandpass_plots.tar.gz
    tar xzf data_plots.tar.gz
    tar xzf corrected_plots.tar.gz
}

###############################################################################
#
# Configure local mamba installation if it exists
#
# Reference $HOME, to work for local macOS and Linux installations
export MAMBA_ROOT_PREFIX="$HOME/../data/miniforge3"
export MAMBA_EXE="$MAMBA_ROOT_PREFIX/bin/mamba"
__mamba_setup="$("$MAMBA_EXE" shell hook --shell $MAMBA_SHELL --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
__conda_setup="$('$MAMBA_ROOT_PREFIX/bin/conda' 'shell.$MAMBA_SHELL' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
    eval "$__conda_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
    if [ -f "$MAMBA_ROOT_PREFIX/etc/profile.d/conda.sh" ]; then
        . "$MAMBA_ROOT_PREFIX/etc/profile.d/conda.sh"
    else
        export PATH="$MAMBA_ROOT_PREFIX/bin:$PATH"
    fi
fi
unset __mamba_setup
unset __conda_setup


#
###############################################################################

###############################################################################
#
# Alias for Emacs on macOS due to bug with keyboard input not moving to window
#
#if [ "$(uname)"=="Darwin" ]; then
#    alias emacs="emacs -nw"
#fi
#
#
###############################################################################

###############################################################################
#
# FTOOLS/CALDB
#
if [ "$(uname)"=="Darwin" ] && [ -d "/Users/data/heasoft" ]; then
    export HEADAS="/Users/data/heasoft"
    . "$HEADAS/headas-init.sh"
elif [ -d "/home/data/heasoft" ]; then
    export HEADAS="/home/data/heasoft/x86_64-pc-linux-gnu-libc2.38"
    . "$HEADAS/headas-init.sh"
fi
if [ "$(uname)"=="Darwin" ] && [ -d "/Users/data/caldb" ] ; then
    export CALDB="/Users/data/caldb"
    . "$CALDB/software/tools/caldbinit.sh"
elif [ -d "/home/data/caldb" ]; then
    export CALDB="/home/data/caldb"
    . "$CALDB/software/tools/caldbinit.sh"
fi
#
#
###############################################################################

###############################################################################
#
# pipx
#
if [ -d $HOME/.local/bin ]; then
    export PATH="$PATH:$HOME/.local/bin"
fi
#
###############################################################################

###############################################################################
#
# Julia
#
if [ -d $HOME/.juliaup/bin ]; then
    export PATH="$PATH:$HOME/.juliaup/bin"
fi
#
###############################################################################

#if [ -d "/home/data/zed" ]; then
#    alias zed="cd /home/data/zed;WAYLAND_DISPLAY='' cargo run --release"
#fi

# Force unmount
alias fumnt="sudo umount -l"
