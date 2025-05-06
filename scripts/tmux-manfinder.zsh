#!/usr/bin/env zsh

# Configurações padrão
export TMUX_MANFINDER_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/tmux-manfinder/manpages.db"
export TMUX_MANFINDER_MAX_AGE=${TMUX_MANFINDER_MAX_AGE:-86400}
export TMUX_MANFINDER_FZF_OPTS=${TMUX_MANFINDER_FZF_OPTS:-'--height=80% --reverse --ansi --preview "man {1}" --preview-window right:60%:wrap'}

__tmux_manfinder_generate_db() {
    apropos -s 1,2,3,4,6,7,8,9 '' 2>/dev/null |
    awk -F'[()]' '{
        gsub(/^ +| +$/, "", $1)
        section = $2 ? $2 : "unknown"
        printf "\033[33m%s\033[0m(\033[35m%s\033[0m)\t%s\n", $1, section, $0
    }' | sort -uf
}

__tmux_manfinder_update_cache() {
    mkdir -p "$(dirname "$TMUX_MANFINDER_CACHE")"
    if [[ ! -f "$TMUX_MANFINDER_CACHE" ]] || \
       [[ $(( $(date +%s) - $(stat -c %Y "$TMUX_MANFINDER_CACHE") )) -gt $TMUX_MANFINDER_MAX_AGE ]]; then
        __tmux_manfinder_generate_db > "${TMUX_MANFINDER_CACHE}.tmp"
        mv "${TMUX_MANFINDER_CACHE}.tmp" "$TMUX_MANFINDER_CACHE"
    fi
}

tmux-manfinder() {
    __tmux_manfinder_update_cache

    local selected man_page
    selected=$(fzf ${=TMUX_MANFINDER_FZF_OPTS} < "$TMUX_MANFINDER_CACHE")
    
    [[ -n "$selected" ]] && {
        man_page=$(awk -F'[()]' '{print $1 " " $2}' <<< "$selected")
        tmux neww -n "man $man_page" "man ${=man_page}"
    }
}
