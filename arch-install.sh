#!/usr/bin/bash

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
    read -r -p "gpu drivers install: [1 - AMD, 2 - Intel, 3 - NVIDIA, 0 - Exit]: " gpu

    case "$gpu" in
        0)
            yay -S --noconfirm ani-cli python3 xorg-server xorg-xhost mesa gtk3 qt5-base vulkan-radeon
            ;;
        1)
            yay -S --noconfirm ani-cli python3 xorg-server xorg-xhost mesa gtk3 qt5-base vulkan-intel
            ;;
        2)
            yay -S --noconfirm ani-cli python3 xorg-server xorg-xhost mesa gtk3 qt5-base nvidia-utils
            ;;
        *)
            echo "No gpu install."
            sleep 1
            ;;
    esac
else
    yay -S --noconfirm ani-cli linux-zen linux-zen-headers timeshift kitty plasma-meta
fi

yay -Yc --noconfirm

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
cp ~/.zshrc ~/.zshrc.bak  
echo 'export ZSH=$HOME/.oh-my-zsh' > ~/.zshrc
echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf-zsh-plugin)' >> ~/.zshrc
echo 'source $ZSH/oh-my-zsh.sh' >> ~/.zshrc
echo "alias c ='clear'" >> ~/.zshrc
echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >>  ~/.zshrc
# wsl 2.0 support
if grep -qi "microsoft" /proc/version; then
    echo "ln -sf /mnt/wslg/.X11-unix/* /tmp/.X11-unix/" >>  ~/.zshrc
    echo "ln -sf /mnt/wslg/runtime-dir/wayland-0* /run/user/$UID/">>  ~/.zshrc
fi
# hyprland install
printf "Finished! Hyprland install?\n[y or n]?: "
read -r choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    yay -S --noconfirm ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite libxrender libxcursor pixman wayland-protocols cairo pango libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang-git hyprcursor-git hyprwayland-scanner-git xcb-util-errors hyprutils-git glaze hyprgraphics-git aquamarine-git re2 hyprland-qtutils
    cd $HOME && git clone --recursive https://github.com/hyprwm/Hyprland
    cd Hyprland
    make all && sudo make install

    #install ml4w
    printf "Do you want to install ml4w?\n[y or n]?: "
    read -r choice
    if [[ "$choice" == "Y"|| "$choice" == "y"]]; then
        yay -S ml4w-hyprland
        ml4w-hyprland-setup
    else
        echo "Finished the install setup!" 
        exit 0
    fi
else
    echo "Finished the install setup!"
    exit 0
fi
