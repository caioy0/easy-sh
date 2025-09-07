#!/usr/bin/bash

printf "System Initial Install\n"
sudo pacman -Syy --noconfirm archlinux-keyring
sudo pacman -Su --noconfirm
sudo pacman -S --noconfirm zsh neovim fzf base-devel kitty yt-dlp yazi btop

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

# brave browser
curl -fsS https://dl.brave.com/install.sh | sh
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
