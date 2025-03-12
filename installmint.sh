#!/bin/bash

sudo apt-get update && sudo apt-get upgrade
sudo apt install ani-cli zsh neovim code
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
