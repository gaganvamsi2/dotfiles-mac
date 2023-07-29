#!/usr/bin/env zsh

# When trimming the internal history, discard duplicates before unique events
setopt HIST_EXPIRE_DUPS_FIRST

# Remove older command if a duplicate is added to the history list
setopt HIST_IGNORE_ALL_DUPS

# Do not add duplicates of previous command to the history list
setopt HIST_IGNORE_DUPS

# Do not save older duplicates of newer commands when writing the history file
setopt HIST_SAVE_NO_DUPS

# Append new history lines to the $HISTFILE as soon as they are entered
setopt INC_APPEND_HISTORY

# Match files beginning with . without explicitly specifying the dot
setopt globdots

# Enable using cd command without explicitly using cd in command
setopt autocd

# Disable all beeps in zsh
unsetopt BEEP

# vi mode settings
VI_MODE_SET_CURSOR=true
MODE_INDICATOR="%F{white}+%f"
INSERT_MODE_INDICATOR="%F{yellow}+%f"

PROMPT="$PROMPT\$(vi_mode_prompt_info)"
RPROMPT="\$(vi_mode_prompt_info)$RPROMPT"

DEFAULT_USER=$(whoami)

zstyle ':autocomplete:*' fzf-completion yes

LFCD="$HOME/.config/lf/lfcd.sh"                                #  pre-built binary, make sure to use absolute path
if [ -f "$LFCD" ]; then
    source "$LFCD"
fi
