if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# WSL 2.0 support
#ln -sf /mnt/wslg/.X11-unix/* /tmp/.X11-unix/
#ln -sf /mnt/wslg/runtime-dir/wayland-0* /run/user/$UID/

# Exports
export EDITOR=nvim
export ZSH=$HOME/.oh-my-zsh
export PATH="$HOME/.cargo/bin:$PATH"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# plugins
plugins=(git 
zsh-autosuggestions 
zsh-syntax-highlighting 
fzf-zsh-plugin 
fast-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# alias
alias shutdown='systemctl poweroff'
alias reset='systemctl reboot'

alias c='clear'
alias ls='eza --icons=always'
alias v='$EDITOR'
alias vim='neovim'
alias b='btop'

alias ff='fastfetch --config examples/25.jsonc'
alias nf='neofetch'

omzplugins() {
  for d in "$ZSH/custom/plugins"/*; do
    if [ -d "$d/.git" ]; then
      echo "🔄 Updating $d..."
      (cd "$d" && git pull --ff-only)
    else
      echo "⚠️  Skipping $d (not a git repo)"
    fi
  done
}

# typeset
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

fastfetch --config examples/13.jsonc