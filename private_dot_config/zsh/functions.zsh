#!/usr/bin/env zsh

cheet() {
  curl cht.sh/$1 | bat
}

cp-vm() {
  scp -rp $1 azsubra@phoenix327666.appsdev.fusionappsdphx1.oraclevcn.com:$2
}

obsidian-cleanup() {
 fd -e txt . '/Users/azhahes/Library/Mobile Documents/iCloud~md~obsidian/Documents/knowledge-vault' -x sh -c 'mv "$0" "${0%.md.txt}.md"' {}
}

copy-tmux-window-address() {
  tmux display-message -p '#{session_name}:#{window_index}.#{pane_index}' | awk '{print $1}' | clipcopy
}

select-kube-config() {
  oci ce cluster create-kubeconfig --cluster-id $(
    oci ce cluster list --compartment-id $(
      oci iam compartment list --compartment-id ocid1.compartment.oc1..aaaaaaaayrghte3g2iiualdgaqqikwumcweskuengqgty65yiwnf6mndvcha |
      jq -r '.data[] | [.name, .id] | @tsv' |
      fzf |
      awk '{print $2}'
    ) |
    jq -r '.data[0].id'
  ) --file $HOME/.kube/config --region us-phoenix-1 --token-version 2.0.0
}

# Usage
# get_secret_value "<your_secret_ocid>"
get_secret_value() {
    local secret_id=$1

    if [[ -z "$secret_id" ]]; then
        echo "Secret ID is required."
        return 1
    fi

    # Retrieve, decode, display, and copy the secret value
    oci secrets secret-bundle get --secret-id "$secret_id" \
        --query 'data."secret-bundle-content".content' --raw-output | base64 --decode | tee >(pbcopy)
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
