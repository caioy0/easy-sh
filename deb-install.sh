#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget zsh neovim tasksel fzf gnupg

# fastfetch
wget https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch_amd64.deb -O fastfetch.deb
sudo dpkg -i fastfetch_amd64.deb
sudo apt -f install -y

# apt nala
sudo apt install nala
sudo nala update

# ani-cli
git clone "https://github.com/pystardust/ani-cli.git"
sudo cp ani-cli/ani-cli /usr/local/bin
rm -rf ani-cli

# nerd font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

# hack
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
unzip Hack.zip
rm Hack.zip
# jetbrains
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip
rm JetBrainsMono.zip

fc-cache -fv
cd $HOME

# kernel and wsl check
if grep -qi "microsoft" /proc/version; then
    echo "using wsl"
    sleep 1
else
    curl 'https://liquorix.net/liquorix-keyring.gpg' | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/liquorix.gpg > /dev/null
    echo "deb [arch=amd64] http://liquorix.net/debian bookworm main" | sudo tee /etc/apt/sources.list.d/liquorix.list
    sudo apt update
    sudo apt install linux-image-liquorix-amd64 linux-headers-liquorix-amd64
fi

# zsh
if ! grep -q "/bin/zsh" /etc/shells && ! grep -q "/usr/bin/zsh" /etc/shells; then
    echo "/bin/zsh" | sudo tee -a /etc/shells
    echo "/usr/bin/zsh" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "Changing default shell to zsh"
    sleep 1
    chsh -s $(which zsh)
fi

# omz
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    printf "omz install"
    sleep 1
    echo "n" | RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# oh-my-zsh plugins
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
    cp -rf dotfiles $HOME
else
    echo "[~] Updating dotfiles..."
    rsync -avh --delete --exclude='.git' dotfiles/ "$HOME/dotfiles/"
    if [[ ! -d "$HOME/.config" ]]; then
        mkdir -p "$HOME/.config"
    fi
fi

# links
ln -sf $HOME/dotfiles/.zshrc $HOME/.zshrc
ln -sf $HOME/dotfiles/.config/kitty $HOME/.config/
ln -sf $HOME/dotfiles/.config/nvim/ $HOME/.config/
ln -sf $HOME/dotfiles/.config/fastfetch/ $HOME/.config/

echo "Finished! Please restart your terminal"
echo "If you are using WSL, please restart your WSL instance"
exit 0
