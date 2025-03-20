#!/usr/bin/zsh

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
    zsh eos-hyprland.sh
else
    echo "Exiting... please, restart shell"
    exit 0
fi