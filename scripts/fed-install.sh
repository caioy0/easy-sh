#!/bin/bash

sudo dnf upgrade
sudo dnf install fzf zsh fastfetch neofetch kitty 
# ani-cli
sudo dnf copr enable derisis13/ani-cli
sudo dnf install ani-cli

# jetbrains font
sudo dnf copr enable elxreno/jetbrains-mono-fonts
sudo dnf install jetbrains-mono-nerd-fonts jetbrains-mononl-nerd-fonts

# vscode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
sudo dnf install code # or code-insiders
sudo dnf clean all

# omz install
echo "n" | RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh check
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "Changing default shell to zsh"
    sleep 1
    chsh -s $(which zsh)
fi

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
	git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fzf-zsh-plugin"
fi

# powerlevel10k
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# dotfiles
if [[ ! -d "$HOME/dotfiles" ]]; then
    cp -rf ../dotfiles/ $HOME
else
    echo "[~] Updating dotfiles..."
    cp -rf ../dotfiles/ $HOME
    if [[ ! -d "$HOME/.config" ]]; then
        mkdir -p "$HOME/.config"
    fi
fi

# links
ln -sf $HOME/dotfiles/.zshrc $HOME/.zshrc
ln -sf $HOME/dotfiles/.bashrc $HOME/.bashrc
ln -sf $HOME/dotfiles/.config/kitty $HOME/.config/
ln -sf $HOME/dotfiles/.config/nvim/ $HOME/.config/
ln -sf $HOME/dotfiles/.config/fastfetch/ $HOME/.config/

echo "Setup finished!"