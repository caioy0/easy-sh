# Custom linux .sh easy install

License: **GPLv3**

Easy setup yeah.<br>
- **Shell:** [zsh] (https://github.com/zsh-users/zsh)
- **Framework shell:** [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)  
- **Theme:** [Powerlevel10k](https://github.com/romkatv/powerlevel10k)  
- **Window Manager:** [Hyprland](https://wiki.hyprland.org/Getting-Started/Installation/)  
- **Anime explorer:** [ani-cli](https://github.com/pystardust/ani-cli)  
- **Dotfiles base:** [ml4w-dotfiles](https://github.com/mylinuxforwork/dotfiles)
- **Video cli:** [yt-dlp](https://github.com/yt-dlp/yt-dlp)  
- **Audio+Video tool cli:** [FFmpeg](https://github.com/FFmpeg/FFmpeg)  
- **System info cli:** [fastfetch](https://github.com/fastfetch-cli/fastfetch)  
- **Browser (Arch):** brave browser  
- **Firefox user.js:** brainfucksec  

## advices
usage of zsh is recomended -> zsh script.sh 

## exec script
```dos
chmod +x install.sh.
./arch-install.sh.

-- or

zsh arch-install.sh || bash arch-install.sh
```

## wsl 2.0
<a name = "for wsl 2.0"></a>
Not ready yet.

## upcoming feat:
macOS files!
hyprland for ubuntu/deb<br>
thinking a way to just write everything in one .sh
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
