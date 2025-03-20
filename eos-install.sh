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

# oh-my-zsh install
echo "n" | RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# oh-my-zsh pluggins
if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi

if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi

if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin" ]]; then
    git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
fi

# powerlevel10k
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# .zshrc
if ! grep -q 'export ZSH=' ~/.zshrc; then
    cp ~/.zshrc ~/.zshrc.bak  
    echo 'export ZSH=$HOME/.oh-my-zsh' > ~/.zshrc
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
    echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf-zsh-plugin)' >> ~/.zshrc
    echo 'source $ZSH/oh-my-zsh.sh' >> ~/.zshrc
    echo "alias gotopa ='cd /usr/user/home/git'" >> ~/.zshrc
    echo "alias c ='clear'" >> ~/.zshrc
fi

printf("Finished! Processed with hyprland install?")
read -r choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    yay -S --noconfirm ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite libxrender libxcursor pixman wayland-protocols cairo pango libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang-git hyprcursor-git hyprwayland-scanner-git xcb-util-errors hyprutils-git glaze hyprgraphics-git aquamarine-git re2 hyprland-qtutils
    git clone --recursive https://github.com/hyprwm/Hyprland
    cd Hyprland
    make all && sudo make install

elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
    echo "Installer finished!"
    exit 0
else
    echo "Invalid Input."
fi
