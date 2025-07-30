# Custom linux .sh easy install

Easy setup yeah.<br>
Shell: zsh<br>
Framework shell: [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)<br>
Theme: [powerlevel10k](https://github.com/romkatv/powerlevel10k)<br>
[hyprland](https://wiki.hyprland.org/Getting-Started/Installation/)<br>
firefox user.js: brainfucksec<br>

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
