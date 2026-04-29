#!/usr/bin/bash

# Define list of packages to install via yay
packages=(
    kitty yazi btop fastfetch
    eza nautilus rust ufw 
    ani-cli mpv yt-dlp # anime
    protonup-qt libreoffice-still 
    ttf-hack-nerd nerd-fonts-jetbrains-mono # fonts
)

printf ">> Starting System Initialization...\n"

# Update system and install essential base packages
sudo pacman -Syy --noconfirm archlinux-keyring
sudo pacman -Su --noconfirm
sudo pacman -S --noconfirm zsh nano fzf base-devel git neovim

# Install 'yay' if not already installed
if ! command -v yay &>/dev/null; then
    echo ">> Installing yay AUR helper..."
    git clone https://aur.archlinux.org/yay.git "$HOME/yay" || exit 1
    cd "$HOME/yay" || exit 1
    makepkg -si --noconfirm || exit 1
    cd .. && rm -rf "$HOME/yay"
else
    echo ">> yay is already installed."
fi

# Install Brave browser via official install script
echo ">> Installing Brave browser..."
curl -fsS https://dl.brave.com/install.sh | sh

# Rust packages
# cargo install

# Install all packages using yay
echo ">> Installing selected packages via yay..."
yay -S --noconfirm "${packages[@]}"

# Clean up orphan packages and cache
echo ">> Cleaning up..."
yay -Yc --noconfirm
yay -Scc --noconfirm
sudo pacman -Rns --noconfirm $(pacman -Qdtq 2>/dev/null || echo "")

# Ensure zsh is listed in /etc/shells
zsh_path="$(which zsh)"
if ! grep -q "$zsh_path" /etc/shells; then
    echo ">> Adding zsh to /etc/shells"
    echo "$zsh_path" | sudo tee -a /etc/shells
fi

# Set zsh as the default shell if it's not already
if [[ "$SHELL" != "$zsh_path" ]]; then
    echo ">> Changing default shell to zsh"
    chsh -s "$zsh_path"
fi

echo "✅ Setup complete."
sleep 1