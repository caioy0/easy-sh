#!/bin/bash

sudo apt-get update && sudo apt-get upgrade
sudo apt install zsh neovim fzf
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "Changing default shell to zsh"
    chsh -s $(which zsh)
fi

echo "Finished! Processed with zsh custom install?"
read -r choice

if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Running next script..."
    zsh /deb-based/zsh.sh
else
    echo "Exiting..."
    exit 0
fi