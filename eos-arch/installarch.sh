#!/bin/bash

sudo pacman -Syy --noconfirm  archlinux-keyring
sudo pacman -Su --noconfirm 
sudo pacman -S --noconfirm zsh neovim fzf base-devel

#yay install
if ! command -v yay &> /dev/null; then
    cd "$HOME" || exit
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    sudo -u "$USER" makepkg -si --noconfirm
    cd .. && rm -rf yay
else
    echo "yay was already on the system."
fi

#wsl check
if grep -qi "microsoft" /proc/version; then
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
    chsh -s "$(which zsh)"
fi

echo "Finished! Processed with zsh custom install (must for wsl)? Y/n?"
read -r choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Running next script..."
    zsh zsh.sh
else
    echo "Exiting..."
    exit 0
fi
