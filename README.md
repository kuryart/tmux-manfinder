# tmux-manfinder

Tmux plugin quick search in man pages with fzf

## Install

### Using TPM

```bash
set -g @plugin 'kuryart/tmux-manfinder'
```

## Config

```tmux
set -g @manfinder-key "M-m" # keybinding
set -g @manfinder-cache-ttl 86400 # time to recache
set -g @manfinder-fzf-opts "--height=80% --reverse --ansi" # fzf options
```
