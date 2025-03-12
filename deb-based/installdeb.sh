#!/bin/bash

sudo apt-get update && sudo apt-get upgrade
sudo apt install curl zsh neovim tasksel
chsh -s $(which zsh)
#desktop env
tasksel
echo "restart shell"
