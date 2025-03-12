#!/bin/bash

# System upgrade
sudo pacman -Syy archlinux-keyring endeavouros-keyring
sudo pacman -Su 
sudo pacman -S zsh neovim git
# Install and remove
yay -S --noconfirm ani-cli linux-zen linux-zen-headers fzf steam timeshift melonds protonup-qt neovim visual-studio-code-bin kitty libreoffice-still brave
yay -Yc --noconfirm
# Swap shell
chsh -s $(which zsh)

#zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Neovim
mkdir -p ~/.config/nvim
cat > ~/.config/nvim/init.lua <<EOL
-- Config
vim.opt.number = true
vim.opt.syntax = 'enable'
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.cmd('filetype plugin indent on')
vim.o.mouse = "a"

-- Packer 
EOL

echo "script finished. Time to reboot"