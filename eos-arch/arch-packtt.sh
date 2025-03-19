#!/bin/zsh

# 2025-03-15

printf "2025-03-15 arch-linux packet tracer installer.\n"
printf "Before the install, you need to download the packettracer.deb from the official Cisco website.\n"
printf "0 - To exit \n1 - Start the build \n2 - Download page.\n"
read -r option

if [[ "$option" == "1" ]]; then
    # Install packettracer
    if [[ ! -d "$HOME/packettracer" ]]; then
        git clone https://aur.archlinux.org/packettracer.git "$HOME/packettracer"
    fi

    # Install .deb package
    cd $HOME/packettracer || exit

    printf "CHROOT NOT READY\n"
    printf "Chroot build?\n Y or n?\n"
    read -r choice

    if [[ "$choice" == "Y" || "$choice" == "y" ]]; then
        if [[ ! -d "$HOME/chroot" ]]; then
            mkdir "$HOME/chroot"
            CHROOT="$HOME/chroot"
            mkarchroot "$CHROOT/ROOT" base-devel
            if [[ ! -f ~/.makepkg.conf ]]; then 
                cat > ~/.makepkg.conf <<EOL
EOL
            fi
            if ! grep "mirrorlist" "$CHROOT/root/etc/pacman.d/mirrorlist"; then
                printf "Not ready chroot\n"
                exit 0
            fi
        else
            printf "Chroot already exists, skipping setup.\n"
        fi
    elif [[ "$choice" == "N" || "$choice" == "n" ]]; then
        printf "No chroot install\n"
        mv ~/Downloads/Packet_Tracer822_amd64_signed.deb ~/packettracer
        sudo pacman -S --noconfirm qt5-base java17-openjdk
        sleep 2
        makepkg
        printf "Now build the package using: sudo pacman -U file\n"
    else
        printf "Invalid input!\n"
    fi
        
elif [[ "$option" == "2" ]]; then
    printf "You need to login/register at Cisco Network site and download the .deb file.\n"
    printf "Link: https://skillsforall.com/resources/lab-downloads\n"
elif [[ "$option" == "3" ]]; then
    printf "Goodbye!\n"
    exit 0
else
    printf "Input not valid\n"
fi
