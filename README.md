# Custom cli to install my personal cfg and tools

License: **GPLv3**

## Dependencies and tools

- **Shell:** [zsh](https://github.com/zsh-users/zsh)
- **Framework shell:** [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
- **Theme:** [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

- **Window Manager:** [Hyprland](https://wiki.hyprland.org/Getting-Started/Installation/)
- **Shell environment:** [Caelestia Shell](https://github.com/caelestia-dots/shell)
- **Qt/QML framework:** [QuickShell](https://git.outfoxxed.me/outfoxxed/quickshell)

- **Status bar:** [Waybar](https://github.com/Alexays/Waybar)
- **Launcher:** [Wofi](https://hg.sr.ht/~scoopta/wofi)
- **Notification daemon:** [Fnott](https://codeberg.org/dnkl/fnott)
- **Wallpaper daemon:** [Hyprpaper](https://github.com/hyprwm/hyprpaper)
- **Wallpaper manager:** [Waypaper](https://github.com/anufrievroman/waypaper)

- **Audio session manager:** [WirePlumber](https://pipewire.pages.freedesktop.org/wireplumber/)
- **Audio/Video server:** [PipeWire](https://pipewire.org/)
- **Wayland compatibility:** [XWayland](https://gitlab.freedesktop.org/xorg/xserver)

- **Qt Wayland support:** [qt5-wayland](https://archlinux.org/packages/?name=qt5-wayland)
- **Qt6 Wayland support:** [qt6-wayland](https://archlinux.org/packages/?name=qt6-wayland)

- **Desktop portal:** [xdg-desktop-portal](https://github.com/flatpak/xdg-desktop-portal)
- **Hyprland portal:** [xdg-desktop-portal-hyprland](https://github.com/hyprwm/xdg-desktop-portal-hyprland)

- **Display manager:** [SDDM](https://github.com/sddm/sddm)

- **Terminal emulator:** [Kitty](https://sw.kovidgoyal.net/kitty/)
- **File manager:** [Nautilus](https://apps.gnome.org/Nautilus/)
- **Audio control:** [Pavucontrol](https://freedesktop.org/software/pulseaudio/pavucontrol/)
- **Virtual filesystem support:** [GVFS](https://wiki.gnome.org/Projects/gvfs)

- **Anime explorer:** [ani-cli](https://github.com/pystardust/ani-cli)
- **Video downloader:** [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- **Audio + video toolkit:** [FFmpeg](https://github.com/FFmpeg/FFmpeg)
- **System information:** [fastfetch](https://github.com/fastfetch-cli/fastfetch)

- **AUR helper:** [yay](https://github.com/Jguer/yay)
- **APT alternative:** [nala](https://github.com/volitank/nala)
- **Windows package manager:** [Scoop](https://scoop.sh)

- **Browser:** [Brave](https://brave.com/) and [Firefox](https://www.mozilla.org/firefox/)
- **Firefox user.js:** by brainfucksec [guide here](https://brainfucksec.github.io/firefox-hardening-guide-2025)

- **Dotfiles base:** [ml4w-dotfiles](https://github.com/mylinuxforwork/dotfiles)
- **waybar base:** [waybar-config](https://github.com/mhdzli/dotfiles/tree/home/.config/waybar)

- **Custom script:** yt-ipod — personal script to download songs from YouTube

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
2. Go to [github](https://github.com) and sign in.
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

- for wsl
- To set a different default user than root, append the following to the /etc/wsl.conf file

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
