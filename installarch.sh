#!/bin/bash

sudo pacman -Syy --noconfirm  archlinux-keyring
sudo pacman -Su --noconfirm 
sudo pacman -S --noconfirm zsh neovim fzf base-devel

# yay install
if ! command -v yay &> /dev/null; then
    cd "$HOME" || exit
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    sudo -u "$USER" makepkg -si --noconfirm
    cd .. && rm -rf yay
else
    echo "yay was already on the system."
fi

# wsl check
if grep -qi "microsoft" /proc/version; then
    echo "using wsl"
    read -rp "which gpu are you using? (0 - AMD, 1 - Intel)" gpu

    if [[$gpu == "0"]]; then
        yay -S --noconfirm ani-cli python3 xorg-server xorg-xhost mesa gtk3 qt5-base vulkan-radeon
    fi
    if [[$gpu == "1"]]; then
        yay -S --noconfirm ani-cli python3 xorg-server xorg-xhost mesa gtk3 qt5-base vulkan-intel
    else 
        echo "Invalid input. Skipping GPU driver installation."
    fi

else
    yay -S --noconfirm ani-cli linux-zen linux-zen-headers timeshift kitty
fi

yay -Yc --noconfirm

# if arch is not using zsh
if ! grep -q "$(which zsh)" /etc/shells ; then
    sudo sh -c "echo $(which zsh) >> /etc/shells"
fi
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "Changing default shell to zsh"
    chsh -s "$(which zsh)"
fi

# oh-my-zsh
printf "Finished! Processed with zsh custom install (must for wsl)? \n(Y or n?)\n"
read -r choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Running next script..."
    zsh zsh.sh
else
    echo "Exiting..."
    exit 0
fi
