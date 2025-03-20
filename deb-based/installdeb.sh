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

# wsl
if grep -qi "microsoft" /proc/version; then
    echo "Using WSL"
    sleep 1
    sudo apt install xrdp
fi

# desktop env
prinf "Install oh-my-zsh?"
read -r choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Running next script..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    zsh ./zsh.sh
elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
    echo "Exiting..."
    exit 0
else
    echo "Invalid Input."
fi