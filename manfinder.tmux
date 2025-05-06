#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Carrega configurações padrão
tmux source-file "$CURRENT_DIR/config/tmux-manfinder.conf"

# Adiciona diretório de scripts ao PATH
add_to_path() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}
add_to_path "$CURRENT_DIR/scripts"

# Define o key binding
key=$(tmux show-option -gqv "@manfinder-key" | sed 's/"//g')
[[ -z "$key" ]] && key="M-m"

tmux bind-key ${=key} run-shell "zsh -ic 'tmux-manfinder'"
