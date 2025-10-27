#
#  __  __   ____     ____  _             _
# |  \/  | / ___|   / ___|| |_ _ __ ___ | |__
# | |\/| || |       \___ \| __| '__/ _ \| '_ \
# | |  | || |___ _   ___) | |_| | | (_) | | | |
# |_|  |_(_)____(_) |____/ \__|_|  \___/|_| |_|
#
#  NRAO shell catch-all
#
# M. C. Stroh (mstroh@nrao.edu)
#
#

# Paths
export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH="$HOME/software/bin:$HOME/lustre/software/bin:$PATH"
export PATH="$HOME/lustre/software/texlive/2025/bin/x86_64-linux:$PATH"
export MANPATH="${MANPATH}:/users/mstroh/lustre/software/texlive/2025/texmf-dist/doc/man"
export INFOPATH="${INFOPATH}:/users/mstroh/lustre/software/texlive/2025/texmf-dist/doc/info"

# Aliases
alias check-nodes="ssh nmpost-master $HOME/bin/check-compute-node.sh"
alias check-lustre="lustre_quota /lustre/aoc/users/${USER} && lfs quota -h -u ${USER} /lustre/aoc"
alias emacs="emacs -nw"
