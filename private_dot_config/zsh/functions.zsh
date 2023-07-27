#!/usr/bin/env zsh

conf() {
  case $1 in
    zsh)      $EDITOR "$XDG_CONFIG_HOME/zsh/.zshrc" ;;
    zprofile) $EDITOR "$XDG_CONFIG_HOME/zsh/.zprofile" ;;
    zaliases)  $EDITOR "$XDG_CONFIG_HOME/zsh/aliases.zsh" ;;
    zbinds)  $EDITOR "$XDG_CONFIG_HOME/zsh/keybinds.zsh" ;;
    zopt)  $EDITOR "$XDG_CONFIG_HOME/zsh/options.zsh" ;;
    zgenom)  $EDITOR "$XDG_CONFIG_HOME/zsh/zgenom.zsh" ;;
    zcomp)  $EDITOR "$XDG_CONFIG_HOME/zsh/compinit.zsh" ;;
    zfunc)  $EDITOR "$XDG_CONFIG_HOME/zsh/functions.zsh" ;;
  esac
}

cheet() {
  curl cht.sh/$1 | bat
}

# tells zsh to ignore case when completing commands or filenames.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

eval "$(zoxide init zsh)"

LFCD="$HOME/.config/lf/lfcd.sh"                                #  pre-built binary, make sure to use absolute path
if [ -f "$LFCD" ]; then
    source "$LFCD"
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}
