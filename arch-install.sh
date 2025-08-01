#!/usr/bin/bash

printf "System Initial Install\n"
sudo pacman -Syy --noconfirm archlinux-keyring
sudo pacman -Su --noconfirm
sudo pacman -S --noconfirm zsh neovim fzf base-devel

# yay install
if ! command -v yay &> /dev/null; then
    cd "$HOME" || exit 1
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit 1
    makepkg -si --noconfirm
    cd .. && rm -rf yay
else
    echo "yay is already installed."
fi

# wsl check
if grep -qi "microsoft" /proc/version; then
    echo "Using wsl"
    read -r -p "gpu drivers install: [1 - AMD, 2 - Intel, 3 - NVIDIA, 0 - no drivers install]: " gpu

    case "$gpu" in
        0)
            echo "Exiting..."
            sleep 1
            exit 0
            ;;
        1)
            yay -S --noconfirm ani-cli python3 xorg-server xorg-xhost mesa gtk3 qt5-base vulkan-radeon
            ;;
        2)
            yay -S --noconfirm ani-cli python3 xorg-server xorg-xhost mesa gtk3 qt5-base vulkan-intel
            ;;
        3)
            yay -S --noconfirm ani-cli python3 xorg-server xorg-xhost mesa gtk3 qt5-base nvidia-utils
            ;;
        *)
            echo "No gpu install."
            sleep 1
            ;;
    esac
else
    yay -S --noconfirm ani-cli linux-zen linux-zen-headers timeshift kitty plasma-meta fastfetch neofetch \
        visual-studio-code-bin steam protonup-qt neovim libreoffice-still ttf-hack-nerd melonds nerd-fonts-jetbrains-mono\
fi

yay -Yc --noconfirm
yay -Scc --noconfirm
sudo pacman -Rns --noconfirm $(pacman -Qdtq)

# if zsh have problems
if ! grep -q "$(which zsh)" /etc/shells ; then
    sudo sh -c "echo $(which zsh) >> /etc/shells"
fi
# change bash to zsh
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "Changing default shell to zsh"
    chsh -s "$(which zsh)"
fi

# oh-my-zsh install
echo "n" | RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# oh-my-zsh pluggins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# fzf-zsh-plugin
if [[ ! -d "$ZSH_CUSTOM/plugins/fzf-zsh-plugin" ]]; then
    git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git "$ZSH_CUSTOM/plugins/fzf-zsh-plugin"
fi

# fast-syntax-highlighting
if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" ]]; then
	git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
fi

# powerlevel10k
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# dotfiles
if [[ ! -d "$HOME/dotfiles" ]]; then
    cp -r dotfiles $HOME
    ln -sf $HOME/dotfiles/.zshrc $HOME/.zshrc
    ln -sf $HOME/dotfiles/.p10k.zsh $HOME/.p10k.zsh
    ln -sf $HOME/dotfiles/.config $HOME/.config
    ln -sf $HOME/dotfiles/.config/kitty $HOME/.config/kitty
    ln -sf $HOME/dotfiles/.config/nvim/ $HOME/.config/nvim
    ln -sf $HOME/dotfiles/.config/fastfetch/ $HOME/.config/fastfetch

# wsl 2.0 support
if grep -qi "microsoft" /proc/version; then
    echo "ln -sf /mnt/wslg/.X11-unix/* /tmp/.X11-unix/" >>  ~/.zshrc
    echo "ln -sf /mnt/wslg/runtime-dir/wayland-0* /run/user/$UID/">>  ~/.zshrc
fi

# hyprland install
printf "Finished! Hyprland install?\n[y or n]?: "
read -r choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    yay -S --noconfirm ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite libxrender libxcursor \
    pixman wayland-protocols cairo pango libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus \
    hyprlang-git hyprcursor-git hyprwayland-scanner-git xcb-util-errors hyprutils-git glaze hyprgraphics-git aquamarine-git re2 hyprland-qtutils
    
    cd $HOME && git clone --recursive https://github.com/hyprwm/Hyprland
    cd Hyprland
    make all && sudo make install

    #install ml4w
    echo "Do you want to install ml4w?\n[y or n]?: "
    read -r choice
    if [[ "$choice" == "Y"|| "$choice" == "y"]]; then
        yay -S ml4w-hyprland
        ml4w-hyprland-setup
    else
        echo "Finished the install setup! please restart your shell.\n" 
        exit 0
    fi
else
    echo "Finished the install setup! please restart your shell."
    exit 0
fi
