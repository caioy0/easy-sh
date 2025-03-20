#!/bin/bash

sudo apt-get update && sudo apt-get upgrade
sudo apt install curl wget zsh neovim tasksel

# zsh
if ! grep -q "/bin/zsh" /etc/shells && ! grep -q "/usr/bin/zsh" /etc/shells; then
    echo "/bin/zsh" | sudo tee -a /etc/shells
    echo "/usr/bin/zsh" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "Changing default shell to zsh"
    sleep 2
    chsh -s $(which zsh)
fi

# wsl check
if grep -qi "microsoft" /proc/version; then
    echo "Using WSL"
    sleep 1
    sudo apt install xrdp
fi

# desktop env
prinf "Install oh-my-zsh?"
read -r choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Running next script..."
    echo "n" | RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
            "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

        # .zshrc
        cp ~/.zshrc ~/.zshrc.bak  
        echo 'export ZSH=$HOME/.oh-my-zsh' > ~/.zshrc
        echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
        echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf-zsh-plugin)' >> ~/.zshrc
        echo 'source $ZSH/oh-my-zsh.sh' >> ~/.zshrc
        git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH/custom/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
    fi

elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
    echo "Finish install!"
    exit 0
else
    echo "Invalid Input."
fi