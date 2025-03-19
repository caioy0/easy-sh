#!/usr/bin/zsh

yay -S --noconfirm ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite libxrender libxcursor pixman wayland-protocols cairo pango libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang-git hyprcursor-git hyprwayland-scanner-git xcb-util-errors hyprutils-git glaze hyprgraphics-git aquamarine-git re2 hyprland-qtutils

git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
make all && sudo make install

#install ml4w
echo "Do you want to install ml4w? Y or n"
read -r choice
if [[$choice == "Y"|| $choice == "y"]]; then
    yay -S ml4w-hyprland
    ml4w-hyprland-setup
else
    echo "Finished install setup!" 
    exit 0
fi