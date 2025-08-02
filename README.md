## Custom cli to install my personal cfg and tools!
Easy setup yeah.<br>

License: **GPLv3**

### Dependecies and tools
- **Shell:** [zsh] (https://github.com/zsh-users/zsh)
- **Framework shell:** [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)  
- **Theme:** [Powerlevel10k](https://github.com/romkatv/powerlevel10k)  
- **Window Manager:** [Hyprland](https://wiki.hyprland.org/Getting-Started/Installation/)  
- **Anime explorer:** [ani-cli](https://github.com/pystardust/ani-cli)  
- **Dotfiles base:** [ml4w-dotfiles](https://github.com/mylinuxforwork/dotfiles)
- **Video cli:** [yt-dlp](https://github.com/yt-dlp/yt-dlp)  
- **Audio+Video tool cli:** [FFmpeg](https://github.com/FFmpeg/FFmpeg)  
- **System info cli:** [fastfetch](https://github.com/fastfetch-cli/fastfetch)  
- **AUR helper:** [yay](https://github.com/Jguer/yay)  
- **Apt alt:** [nala](https://github.com/volitank/nala)  
- **Browser (Arch):** brave browser  
- **Firefox user.js:** brainfucksec  

## usage and advices
-> zsh easy-sh [options]
-> to list all the options use
zsh easy-sh -h or --help

## exec my custom scripts
```dos
chmod +x install.sh.
./arch-install.sh.

-- or

zsh arch-install.sh || bash arch-install.sh
```

## upcoming feat:
macOS files!
hyprland for ubuntu/deb<br>
thinking a way to improve easy-sh
dotfiles full feat

### new feat:
Script that donwload aac good quality for my ipod 1 gen ;)

### basic config arch after install
for wsl<br>
To set a different default user than root, append the following to the /etc/wsl.conf file:<br>

[user]<br>
default=username<br>

archlinux root:
```dos
passwd
useradd -m -g users -G wheel -s /bin/bash [username]
echo "%wheel ALL=(ALL) ALL" >/etc/sudoers.d/wheel
passwd [username]
```
