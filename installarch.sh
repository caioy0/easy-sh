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
    read -r -p "gpu drivers install: [0 - AMD, 1 - Intel, 2 - NVIDIA]: " gpu

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
            echo "Invalid input. Skipping gpu install."
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
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "Changing default shell to zsh"
    chsh -s "$(which zsh)"
fi

# oh-my-zsh
printf "Finished! Processed with zsh custom install (must for wsl)? \n[Y or n?]\n"
read -r choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Running next script..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # oh-my-zsh pluggins
    if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    fi

    if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
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
        echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> ~/.zshrc
        echo 'source $ZSH/oh-my-zsh.sh' >> ~/.zshrc
        echo "alias c ='clear'" >> ~/.zshrc
        ln -sf /mnt/wslg/.X11-unix/* /tmp/.X11-unix/
        ln -sf /mnt/wslg/runtime-dir/wayland-0* /run/user/$UID/
    fi

    # hyprland install
    printf "Finished! Hyprland install?\n [y or n]?\n"
    read -r choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        echo "Running next script..."
        zsh eos-arch/eos-hyprland.sh
    else
        echo "Exiting... please, restart shell"
        exit 0
    fi
else
    echo "Finish! Exiting..."
    exit 0
fi
