#!/bin/bash

sudo dnf install fzf zsh fastfetch neofetch kitty 
sudo dnf copr enable derisis13/ani-cli
sudo dnf install ani-cli
sudo dnf copr enable elxreno/jetbrains-mono-fonts
sudo dnf install jetbrains-mono-nerd-fonts jetbrains-mononl-nerd-fonts

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

dnf check-update
sudo dnf install code # or code-insiders

echo "n" | RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "Changing default shell to zsh"
    sleep 1
    chsh -s $(which zsh)
fi

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

if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting"]]; then
	git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
fi

# powerlevel10k
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# .dotfiles
if [[ ! -d "$HOME/dotfiles" ]]; then
    cp -r dotfiles $HOME
    ln -sf $HOME/dotfiles/.zshrc $HOME/.zshrc
    ln -sf $HOME/dotfiles/.p10k.zsh $HOME/.p10k.zsh
    ln -sf $HOME/dotfiles/.config $HOME/.config
    ln -sf $HOME/dotfiles/.config/kitty $HOME/.config/kitty
    ln -sf $HOME/dotfiles/.config/nvim/ $HOME/.config/nvim


echo "Install finished!"