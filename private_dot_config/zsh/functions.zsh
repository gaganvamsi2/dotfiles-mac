#!/usr/bin/env zsh

cheet() {
  curl cht.sh/$1 | bat
}

obsidian-cleanup() {
 fd -e txt . '/Users/azhahes/Library/Mobile Documents/iCloud~md~obsidian/Documents/knowledge-vault' -x sh -c 'mv "$0" "${0%.md.txt}.md"' {}
}

copy-tmux-window-address() {
  tmux display-message -p '#{session_name}:#{window_index}.#{pane_index}' | awk '{print $1}' | clipcopy
}

aws-sso-login(){
  aws sso login --profile $1
  eval $(aws configure export-credentials --profile $1 --format env)
}

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
