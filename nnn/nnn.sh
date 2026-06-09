#!/bin/sh
# ~/.config/nnn/nnn.sh
# Source this as 
#   [ -f "$HOME/.config/nnn/nnn.sh" ] && . "$HOME/.config/nnn/nnn.sh"

# Editor setup
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Plugin setup
export NNN_PLUG="f:finder;o:fzopen;p:preview-tui;d:diffs;t:nmount;v:imgview;z:autojump"
export NNN_OPTS="aeou"

# cd on quit
n () {
    # Block nesting nnn inside an nnn-spawned shell.
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }
 
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
 
    nnn "$@"
 
    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f -- "$NNN_TMPFILE" > /dev/null
    }
}
