#!/usr/bin/bash

# System upgrade
sudo pacman -Syy --noconfirm archlinux-keyring endeavouros-keyring
sudo pacman -Su --noconfirm
sudo pacman -S --noconfirm zsh fzf

# Install and remove
yay -S --noconfirm ani-cli linux-zen linux-zen-headers fzf steam timeshift melonds protonup-qt neovim visual-studio-code-bin kitty libreoffice-still \
    fastfetch neofetch ttf-hack-nerd
yay -Yc --noconfirm
yay -Scc --noconfirm
sudo pacman -Rns --noconfirm $(pacman -Qdtq)

# Swap shell
if [[ "$SHELL" != "$(which zsh)" ]]; then
    printf "Changing default shell to zsh\n"
    chsh -s $(which zsh)
    sleep 1
fi

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

# .dotfiles
if [[ ! -d "$HOME/.dotfiles" ]]; then
    cp -r ./dotfiles $HOME
    ln -sf $HOME/.dotfiles/.zshrc $HOME/.zshrc
    ln -sf $HOME/.dotfiles/.p10k.zsh $HOME/.p10k.zsh
    ln -sf $HOME/.dotfiles/.config $HOME/.config
    ln -sf $HOME/.dotfiles/.config/kitty $HOME/.config/kitty
    ln -sf $HOME/.dotfiles/.config/nvim $HOME/.config/nvim

printf "Finished! Processed with hyprland install?"
read -r choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    yay -S --noconfirm ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes \
        libx11 libxcomposite libxrender libxcursor pixman wayland-protocols cairo pango libxkbcommon \
        xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang-git hyprcursor-git \
        hyprwayland-scanner-git xcb-util-errors hyprutils-git glaze hyprgraphics-git aquamarine-git re2 hyprland-qtutils 
    git clone --recursive https://github.com/hyprwm/Hyprland
    cd Hyprland
    make all && sudo make install

    printf "ml4w install?"
    read -r choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        yay -S ml4w-hyprland
        ml4w-hyprland-setup
    else
        echo "ml4w-hyprland not installed"
        printf "Please restart your terminal\n"
    fi
elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
    echo "Installer finished!"
    exit 0
else
    echo "Invalid Input."
fi
