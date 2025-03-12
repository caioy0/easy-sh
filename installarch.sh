#!/bin/bash

sudo pacman -Syy archlinux-keyring
sudo pacman -Su 
sudo pacman -S zsh neovim git yay
yay -S --noconfirm ani-cli linux-zen linux-zen-headers timeshift 
yay -Yc --noconfirm
chsh -s $(which zsh)

echo "finish..."
