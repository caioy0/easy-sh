#!/bin/bash

sudo apt-get update && sudo apt-get upgrade
sudo apt install curl zsh neovim
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)
echo "restart shell"
