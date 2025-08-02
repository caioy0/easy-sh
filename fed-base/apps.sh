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
