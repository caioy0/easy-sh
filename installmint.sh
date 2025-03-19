#!/bin/bash

sudo apt-get update && sudo apt-get upgrade
sudo apt install zsh neovim fzf steam mpv kitty curl

if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "Changing default shell to zsh"
    chsh -s $(which zsh)
fi

echo "Finished! Processed with zsh custom install?"
read -r choice

if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Running next script..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    zsh /deb-based/zsh.sh
elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
    echo "Exiting..."
    exit 0
else
    echo "Invalid Input."
fi