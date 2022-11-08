#  ____ ___ _____ ____      _
# / ___|_ _| ____|  _ \    / \
#| |    | ||  _| | |_) |  / _ \
#| |___ | || |___|  _ <  / ___ \
# \____|___|_____|_| \_\/_/   \_\
#
# .basics file for shell setup
#
# Last modified: March 18th, 2022 - M. C. Stroh (michael.stroh@northwestern.edu)
#



# Give us a long history
set savehist=500000
set history=500000



# Aliases
alias rm='rm -i'
alias ssh='ssh -Y'
alias cdirs='for file in *; do if [ -d "$file" ]; then tar -czf "${file}.tar.gz" "$file"; fi; done'
alias crdirs='for file in *; do if [ -d "$file" ]; then tar -czf "${file}.tar.gz" "$file" && rm -rf "$file" || rm -rf "${file}.tar.gz"; fi; done'
alias conda_base='conda activate base'


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

##########################################################################################
#
# Configure local anaconda installation if it exists
#
# By referencing $HOME, this should work for typical local MacOS and Linux installations
if [ -d "$HOME/../data/miniconda3" ]; then
    if [ -f "$HOME/../data/miniconda3/etc/profile.d/conda.sh" ]; then
        eval "$($HOME/../data/miniconda3/bin/conda shell.bash hook)"
        conda activate py39
    else
        export PATH="$HOME/../data/miniconda3/bin:$PATH"
    fi
elif [ -d "$HOME/../data/anaconda3" ]; then
    if [ -f "$HOME/../data/anaconda3/etc/profile.d/conda.sh" ]; then
        eval "$($HOME/../data/anaconda3/bin/conda shell.bash hook)"
        conda activate py39
    else
        export PATH="$HOME/../data/miniconda3/bin:$PATH"
    fi
fi
if { conda env list | grep "py311"; } >/dev/null; then
    conda activate py311
fi
#
##########################################################################################
