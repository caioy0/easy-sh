#!/bin/bash

sudo pacman -Syy archlinux-keyring
sudo pacman -Su 
sudo pacman -S zsh neovim git yay

#wsl check
if grep -qi "microsoft" /proc/version;
    echo "using wsl"
    yay -S --noconfirm ani-cli python3
else
    yay -S --noconfirm ani-cli linux-zen linux-zen-headers timeshift 
fi
yay -Yc --noconfirm

#if for some reason arch is not using zsh
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "Changing default shell to zsh"
    chsh -s $(which zsh)
fi

echo "Finished! Processed with zsh custom install?"

read -r choice

if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Running next script..."
    zsh zsh.sh
else
    echo "Exiting..."
    exit 0
fi
