#!/bin/bash

sudo apt-get update && sudo apt-get upgrade
sudo apt install curl wget zsh neovim tasksel

# zsh
if ! grep -q "/bin/zsh" /etc/shells && ! grep -q "/usr/bin/zsh" /etc/shells; then
    echo "/bin/zsh" | sudo tee -a /etc/shells
    echo "/usr/bin/zsh" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "Changing default shell to zsh"
    sleep 2
    chsh -s $(which zsh)
fi

# desktop env
echo "install desktop env? Y/y or n"
read choice
if [[$choice == "Y" || $choice == "y" ]]; then
    zsh tasksel
fi
echo "Please, restart the shell"