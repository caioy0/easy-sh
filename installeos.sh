#!/bin/bash

# System upgrade
sudo pacman -Syy --noconfirm archlinux-keyring endeavouros-keyring
sudo pacman -Su --noconfirm
sudo pacman -S --noconfirm zsh neovim git fzf

# Install and remove
yay -S --noconfirm ani-cli linux-zen linux-zen-headers fzf steam timeshift melonds protonup-qt neovim visual-studio-code-bin kitty libreoffice-still
yay -Yc --noconfirm

# Swap shell
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "Changing default shell to zsh"
    chsh -s $(which zsh)
fi

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

#end
echo "Finished! Processed with zsh custom install?"
read -r choice

if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Running next script..."
    zsh /eos-arch/zsh.sh
else
    echo "Exiting..."
    exit 0
fi