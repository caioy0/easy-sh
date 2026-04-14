## Custom cli to install my personal cfg and tools!
Easy setup yeah.<br>

License: **GPLv3**

### Dependencies and tools
- **Shell:** [zsh](https://github.com/zsh-users/zsh)
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
- **Windows package manager:** [Scoop](https://scoop.sh) 
- **Firefox user.js:** by brainfucksec [guide-here](https://brainfucksec.github.io/firefox-hardening-guide-2025)
- **Browser :** [brave](https://brave.com/) and [firefox](https://www.firefox.com/)
- **yt-ipod:** my script to download songs from yt  

## usage and advices
- -> zsh easy-sh [options]
- -> to list all the options use zsh easy-sh -h or --help

## exec my custom scripts
```bash
chmod +x script.sh
./script.sh

-- or

zsh arch-install.sh || bash arch-install.sh
```

### scripts
- scripts -> .sh to use with wsl

## upcoming feat:
- dotfiles full settings working

### 🔐 Basic SSH Configuration (After Installation)
This guide walks you through setting up an SSH key for secure communication with GitHub.
---
Run the following commands, replacing the email with your GitHub email:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```
### 🌐 Add Your SSH Key to GitHub
- After running the `cat ~/.ssh/id_ed25519.pub` command:
1. Copy the entire output (it should start with `ssh-ed25519` and end with your email).
2. Go to https://github.com and sign in.
3. In the top-right corner, click your profile picture → **Settings**.
4. In the sidebar, click **SSH and GPG keys**.
5. Click **New SSH key**.
6. Add a title (e.g., "My Laptop" or "WSL").
7. Paste your copied key into the **Key** field.
8. Click **Add SSH key** to save.

### now test
```bash
ssh -T git@github.com
```

## basic config arch after install
for wsl<br>
To set a different default user than root, append the following to the /etc/wsl.conf file:<br>

### in /etc/wsl.conf
```bash
[user]
default=username
```
### archlinux root
```bash
passwd
useradd -m -g users -G wheel -s /bin/bash [username]
echo "%wheel ALL=(ALL) ALL" >/etc/sudoers.d/wheel
passwd [username]
```
