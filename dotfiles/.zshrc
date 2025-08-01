if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export EDITOR=nvim

# WSL 2.0 support
#ln -sf /mnt/wslg/.X11-unix/* /tmp/.X11-unix/
#ln -sf /mnt/wslg/runtime-dir/wayland-0* /run/user/$UID/

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
# plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf fzf-zsh-plugin fast-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# alias
alias c='clear'
alias ff='fastfetch'
alias nf='neofetch'
alias shutdown='systemctl poweroff'
alias v='$EDITOR'
alias reset='systemctl reboot'

# typeset
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

if [[ $(tty) == *"pts"* ]]; then
    fastfetch --config ~/.config/fastfetch/config.jsonc
fi