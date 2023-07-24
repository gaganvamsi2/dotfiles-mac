#!/usr/bin/env zsh

# load zgenom
source "${HOME}/.zgenom/zgenom.zsh"

# Check for plugin and zgenom updates every 7 days
# This does not increase the startup time.
zgenom autoupdate

# if the init script doesn't exist
if ! zgenom saved; then
    echo "Creating a zgenom save"

    # Ohmyzsh base library
    zgenom ohmyzsh

    # plugins
    zgenom ohmyzsh plugins/git
    zgenom ohmyzsh plugins/sudo
    # just load the completions
    zgenom ohmyzsh --completion plugins/docker-compose

    # Install ohmyzsh osx plugin if on macOS
    [[ "$(uname -s)" = Darwin ]] && zgenom ohmyzsh plugins/macos

    # theme
    zgenom ohmyzsh themes/arrow

    # Enable fzf (fuzzy finder) for tab completions and history searching
    zgenom load Aloxaf/fzf-tab
    zgenom load joshskidmore/zsh-fzf-history-search
    # Enable syntax highlighting
    zgenom load zdharma-continuum/fast-syntax-highlighting
    # Enable useful zsh-users plugins
    zgenom load zsh-users/zsh-autosuggestions
    zgenom load zsh-users/zsh-history-substring-search
    zgenom load --completion zsh-users/zsh-completions
    # zgenom load zsh-users/vi-mode
    zgenom load jeffreytse/zsh-vi-mode
    
    # generate the init script from plugins above
    zgenom save

    # Compile your zsh files
    zgenom compile "$HOME/.config/zsh/.zshrc"
    # Uncomment if you set ZDOTDIR manually
    # zgenom compile $ZDOTDIR

    # You can perform other "time consuming" maintenance tasks here as well.
    # If you use `zgenom autoupdate` you're making sure it gets
    # executed every 7 days.

    # rbenv rehash
fi
