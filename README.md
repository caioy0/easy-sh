# Custom linux .sh easy install

## exec script
chmod +x install.sh.
sudo ./install.sh.

<a name = "for wsl 2.0"></a>
currently testing.

## basic config
for wsl
To set a different default user than root, append the following to the /etc/wsl.conf file:
[user]
default=username

archlinux root:
passwd
useradd -m -g users -G wheel username
passwd username

echo "username ALL=(ALL) ALL" >> /etc/sudoers.d/username

### next feat:
hyprland auto-install (arch)
hyprland for ubuntu
hyprland for debian