#!/usr/bin/bash

# System upgrade
sudo pacman -Syy --noconfirm archlinux-keyring endeavouros-keyring
sudo pacman -Su --noconfirm
sudo pacman -S --noconfirm zsh fzf

# Install and remove
yay -S --noconfirm ani-cli linux-zen linux-zen-headers fzf steam timeshift melonds protonup-qt neovim visual-studio-code-bin kitty libreoffice-still
yay -Yc --noconfirm

# Swap shell
if [[ "$SHELL" != "$(which zsh)" ]]; then
    printf("Changing default shell to zsh\n")
    chsh -s $(which zsh)
    sleep 1
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
printf("Finished! Processed with zsh/hyprland custom install?")
read -r choice

if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Running next script..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    zsh /eos-arch/eos-zsh.sh
elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
    echo "Exiting..."
    exit 0
else
    echo "Invalid Input."
fi
