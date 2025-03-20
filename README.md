# Custom linux .sh easy install

Easy setup yeah.<br>
Shell: zsh<br>
Framework shell: oh-my-zsh link: https://github.com/ohmyzsh/ohmyzsh<br>
theme: https://github.com/romkatv/powerlevel10k<br>
hyprland: https://wiki.hyprland.org/Getting-Started/Installation/<br>

## exec script
```dos
chmod +x install.sh.
./install.sh.<br>
```

## wsl 2.0
<a name = "for wsl 2.0"></a>
Not ready yet.

## next feat:
### auto install:
hyprland for arch<br>
hyprland for ubuntu<br>
hyprland for debian<br>

### run a simple version of the code:
thinking a way to just write everything in one .sh

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
