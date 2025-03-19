#!/bin/zsh

# oh-my-zsh

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then 
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "already installed" 
fi