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
