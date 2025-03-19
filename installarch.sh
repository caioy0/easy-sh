#!/usr/bin/bash

sudo pacman -Syy --noconfirm archlinux-keyring
sudo pacman -Su --noconfirm
sudo pacman -S --noconfirm zsh neovim fzf base-devel

# yay install
if ! command -v yay &> /dev/null; then
    cd "$HOME" || exit 1
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit 1
    sudo -u "$USER" makepkg -si --noconfirm
    cd .. && rm -rf yay
else
    echo "yay is already installed."
fi

# WSL check
if grep -qi "microsoft" /proc/version; then
    echo "Using WSL"
    read -r -p "GPU install: [0 - AMD, 1 - Intel, 2 - NVIDIA]: " gpu

    case "$gpu" in
        0)
            sudo pacman -S --noconfirm ani-cli python3 xorg-server xorg-xhost mesa gtk3 qt5-base vulkan-radeon
            ;;
        1)
            sudo pacman -S --noconfirm ani-cli python3 xorg-server xorg-xhost mesa gtk3 qt5-base vulkan-intel
            ;;
        2)
            sudo pacman -S --noconfirm ani-cli python3 xorg-server xorg-xhost mesa gtk3 qt5-base nvidia-utils
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
    zsh /eos-arch/arch-zsh.sh
else
    echo "Exiting..."
    exit 0
fi
