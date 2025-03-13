#!/bin/bash

sudo pacman -Syy archlinux-keyring
sudo pacman -Su 
sudo pacman -S zsh neovim yay fzf

#wsl check
if grep -qi "microsoft" /proc/version;
    echo "using wsl"
    sleep 5
    yay -S --noconfirm ani-cli python3 xorg-server xorg-xhost mesa gtk3 qt5-base vulkan-radeon
    #Intel: vulkan-intel
else
    yay -S --noconfirm ani-cli linux-zen linux-zen-headers timeshift 
fi
yay -Yc --noconfirm

#if arch is not using zsh
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "Changing default shell to zsh"
    chsh -s $(which zsh)
fi

echo "Finished! Processed with zsh custom install (must for wsl)?"
read -r choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Running next script..."
    zsh zsh.sh
else
    echo "Exiting..."
    exit 0
fi
