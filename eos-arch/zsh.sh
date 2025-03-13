#!/bin/zsh

#zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

cp ~/.zshrc ~/.zshrc.bak  
echo 'export ZSH=$HOME/.oh-my-zsh' > ~/.zshrc
echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> ~/.zshrc
echo 'source $ZSH/oh-my-zsh.sh' >> ~/.zshrc
echo "alias gotopa='cd /usr/user/home/git'" >> ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting

#wsl check
if grep -qi "microsoft" /proc/version; then
    echo "wsl detected!..."
    sleep 3
    echo 'if [ -d "/mnt/wslg/.X11-unix" ]; then ln -sf /mnt/wslg/.X11-unix/* /tmp/.X11-unix/; fi' >> ~/.zshrc
    echo 'if [ -d "/mnt/wslg/runtime-dir" ]; then ln -sf /mnt/wslg/runtime-dir/wayland-0* /run/user/$UID/; fi' >> ~/.zshrc
fi

#hyprland install
echo "Finished! Hyprland install?"
read -r choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Running next script..."
    zsh hyprland.sh
else
    echo "Exiting... please, restart shell"
    exit 0
fi
