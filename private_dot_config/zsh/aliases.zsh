# Basic aliases
alias rm='rm -rIv'   # Recursive, interactive, and verbose `rm`
alias cp='cp -rv'   # Recursive and verbose `cp`
alias mv='mv -v'    # Verbose `mv`
alias mkdir='mkdir -vp'  # Recursive, verbose `mkdir`
alias grep='rg'     # Use `ripgrep` instead of `grep`

# `exa` aliases for more informative and colored output
alias la='exa --icons -a --group-directories-first'  # List all files and directories, including hidden ones
alias ll='exa --icons -lah --group-directories-first'  # List in long format with permissions and human-readable sizes
alias ls='exa --icons --group-directories-first'  # List files and directories

# `exa` alias for displaying directory trees
alias tree='exa --icons --tree'

# Misc aliases
alias updates='checkupdates; paru -Qum'  # Check system and AUR updates
alias rs='curl --data-binary @- https://paste.rs | wl-copy'  # Share output to a pastebin and copy to clipboard

alias c=clear
alias v=nvim
alias d="v -d"
alias lf=lfcd
alias iopacity="~/.config/alacritty/change-opacity.sh +"
alias dopacity="~/.config/alacritty/change-opacity.sh -"

# `exa` aliases for more informative and colored output
alias la='exa --icons -a --group-directories-first'  # List all files and directories, including hidden ones
alias ll='exa --icons -lah --group-directories-first'  # List in long format with permissions and human-readable sizes
alias ls='exa --icons --group-directories-first'  # List files and directories

alias talisman=$TALISMAN_HOME/talisman_darwin_amd64
alias cm=chezmoi

alias pstree="pstree -g 2"
alias vpn="~/connect-vpn.sh"

#git
alias gst="git status"
alias gco="git checkout"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
