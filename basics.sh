#  ____ ___ _____ ____      _
# / ___|_ _| ____|  _ \    / \
#| |    | ||  _| | |_) |  / _ \
#| |___ | || |___|  _ <  / ___ \
# \____|___|_____|_| \_\/_/   \_\
#
# .basics file for shell setup
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
# Configure local anaconda installation if it exists
#
# Reference $HOME, to work for local macOS and Linux installations
if [ -d "$HOME/../data/miniforge3" ]; then
    __conda_setup="$('$HOME/../data/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/../data/miniforge3/etc/profile.d/conda.sh" ]; then
            . "$HOME/../data/miniforge3/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/../data/miniforge3/bin:$PATH"
        fi
    fi
    unset __conda_setup

    if [ -f "$HOME/../data/miniforge3/etc/profile.d/mamba.sh" ]; then
        . "$HOME/../data/miniforge3/etc/profile.d/mamba.sh"
    fi

elif [ -d "$HOME/../data/miniconda3" ]; then
    if [ -f "$HOME/../data/miniconda3/etc/profile.d/conda.sh" ]; then
        eval "$($HOME/../data/miniconda3/bin/conda shell.bash hook)"
    else
        export PATH="$HOME/../data/miniconda3/bin:$PATH"
    fi
fi
#
###############################################################################

###############################################################################
#
# Alias for Emacs on macOS due to bug with keyboard input not moving to window
#
if [ "$(uname)"=="Darwin" ]; then
    alias emacs="emacs -nw"
fi
#
#
###############################################################################

###############################################################################
#
# FTOOLS/CALDB
#
if [ "$(uname)"=="Darwin" ] && [ -d "/Users/data/heasoft" ] ; then
    export HEADAS="/Users/data/heasoft/x86_64-apple-darwin22.6.0"
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


