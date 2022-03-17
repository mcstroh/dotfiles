#
# ZSH setup
#

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  . "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


#
# iTerm2 shell integration
#
if [ -f "$HOME/dotfiles/.iterm2_shell_integration.zsh" ]; then
    . ${HOME}/dotfiles/.iterm2_shell_integration.zsh
fi



#
# Doom Emacs
#
if [ -d "$HOME/.emacs.d/bin" ]; then
    path+=('$HOME/.emacs.d/bin') # Add Doom to path
    export EDITOR="emacs -nw"
fi



##########################################################################################
#
# ZSH plugins/enhancements
#
#     MacOS with brew
#
if command -v brew >/dev/null 2>&1
then  

    #
    # ZSH plugins
    #

    if [[ -r /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme ]]; then
        . /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
    fi
    
    # ZSH git prompt
    if [ -f /opt/homebrew/opt/zsh-git-prompt/zshrc.sh ]; then
        . /opt/homebrew/opt/zsh-git-prompt/zshrc.sh
    fi

    # ZSH syntax highlighting
    if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi

    # ZSH autosuggestions
    if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        . /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi

    # ZSH completions
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    autoload -Uz compinit
    compinit
    
    # Setup p10k
    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f "$HOME/dotfiles/.p10k.zsh" ]] || . ${HOME}/dotfiles/.p10k.zsh

#
#      Linux box
#
else
    zstyle :compinstall filename "$HOME/.zshrc"
    autoload -Uz compinit
    compinit

fi
#
##########################################################################################
