#!/bin/bash

purge_others() {
    echo "Removing NVIDIA and Intel GPU drivers (if present)..."

    case "$1" in
        debian)
            # NVIDIA
            sudo apt-get purge -y '^nvidia-.*' '^libnvidia-.*'
            # Intel (ex: i965 driver, in case you want to be strict)
            sudo apt-get purge -y i965-va-driver intel-media-va-driver-non-free
            ;;
        arch)
            # NVIDIA
            sudo pacman -Rns --noconfirm nvidia nvidia-utils nvidia-dkms
            # Intel (optional)
            sudo pacman -Rns --noconfirm intel-media-driver libva-intel-driver
            ;;
        fedora)
            # NVIDIA
            sudo dnf remove -y '*nvidia*' xorg-x11-drv-nvidia*
            # Intel
            sudo dnf remove -y intel-media-driver libva-intel-driver
            ;;
        *)
            echo "Error: unsupported or missing distro in purge function"
            exit 1
            ;;
    esac
}

install_amd_drivers() {
    echo "Installing AMD drivers for $1..."
    case "$1" in
        debian)
            sudo apt-get update
            sudo apt-get install -y firmware-amd-graphics libgl1-mesa-dri libglx-mesa0 mesa-vulkan-drivers xserver-xorg-video-all
            ;;
        arch)
            yay --no-confirm vulkan-radeon mesa
            ;;
        fedora)
            sudo dnf install -y mesa-dri-drivers mesa-libGL mesa-vulkan-drivers
            ;;
        *)
            echo "Error: unsupported or missing distro in AMD install"
            exit 1
            ;;
    esac
}

# MAIN
if [ -z "$1" ]; then
    echo "Usage: $0 <distro>"
    exit 1
fi

purge_others "$1"
install_amd_drivers "$1"
