#!/bin/bash

sudo apt-get update && sudo apt-get upgrade
sudo apt install curl wget zsh neovim tasksel fzf 

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
printf "omz install"
sleep 1
echo "n" | RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    
# oh-my-zsh plugins
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

#dotfiles
if [[ ! -d "$HOME/dotfiles" ]]; then
    cp -r dotfiles $HOME
    ln -sf $HOME/dotfiles/.zshrc $HOME/.zshrc
    ln -sf $HOME/dotfiles/.p10k.zsh $HOME/.p10k.zsh
    ln -sf $HOME/dotfiles/.config $HOME/.config
    ln -sf $HOME/dotfiles/.config/kitty $HOME/.config/kitty
    ln -sf $HOME/dotfiles/.config/nvim/ $HOME/.config/nvim
fi

echo "Finished! Please restart your terminal"
echo "If you are using WSL, please restart your WSL instance"
exit 0
