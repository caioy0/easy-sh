# Custom linux .sh easy install

Easy setup yeah.<br>
Shell: zsh<br>
Framework shell: oh-my-zsh link: https://github.com/ohmyzsh/ohmyzsh<br>
theme: https://github.com/romkatv/powerlevel10k<br>
hyprland: https://wiki.hyprland.org/Getting-Started/Installation/<br>

## exec script
chmod +x install.sh.
./install.sh.

## wsl 2.0
<a name = "for wsl 2.0"></a>
Not ready yet.

## next feat:
### auto install:
hyprland for arch
hyprland for ubuntu
hyprland for debian

### run a simple version of the code:
thinking a way to just write everything in one .sh

### basic config arch after install
for wsl
To set a different default user than root, append the following to the /etc/wsl.conf file:
[user]
default=username

archlinux root:
passwd _setpassword_
useradd -m -g users -G wheel _username_
passwd username -setpassword_

echo "_username_ ALL=(ALL) ALL" >> /etc/sudoers.d/_username_
