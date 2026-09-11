# easy-sh

> Personal Linux architecture automation: dotfiles, OS bootstrap, and a
> resource-constrained home-server Docker fleet — driven by one CLI.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/release/caioy0/easy-sh?include_prereleases&sort=semver)](https://github.com/caioy0/easy-sh/releases)
[![Shell: bash/zsh](https://img.shields.io/badge/shell-bash%2Fzsh-lightgray)](#)
<!-- spdx: MIT -->

`easy-sh` is your single entry point to:

- **Bootstrap** a fresh machine — Arch, Debian/Ubuntu, Fedora, macOS or WSL —
  installing your preferred toolchain and shell.
- **Provision** a headless **Debian server** into a lean Docker host (Docker
  Engine + Compose, Lazydocker, optional Dockge).
- **Run a game & network fleet** — a **Minecraft PaperMC** server, a
  **Terraria** server, and a **Cloudflare Tunnel** for secure HTTPS access to
  local web dashboards — all under a strict memory budget.
- **Sync your dotfiles** (zsh, bash, nvim, kitty, fastfetch, Hyprland, …) with
  backup + idempotent symlinks.

---

## Table of contents

- [Overview](#overview)
- [Repository layout](#repository-layout)
- [Quick start](#quick-start)
  - [On your desktop (any distro / WSL / macOS)](#on-your-desktop)
  - [On your home server (Docker fleet)](#on-your-home-server)
- [CLI reference](#cli-reference)
- [Dotfiles](#dotfiles)
- [Home-server fleet](#home-server-fleet)
- [Dependencies & tools](#dependencies--tools)
- [Post-install guides](#post-install-guides)
- [License](#license)

---

## Overview

Repositories like this usually keep installers and dotfiles side by side
without any structure. `easy-sh` is organized so the three jobs it does don't
step on one another:

| Concern                  | Where it lives                     |
|--------------------------|------------------------------------|
| Interactively install OS packages | `*-base/` (per-distro) + `easy-sh` menu/CLI |
| Set up shell + editor + dotfiles  | `dotfiles/`, handled by `easy-sh`           |
| Run game servers & tunnel          | `servers/` (Docker Compose fleet)           |
| Windows PowerShell bootstrap       | `windows/`                                  |

### Design principles

- **Idempotent & safe to re-run** — every script is guarded with existence
  checks (`bash -n` clean, `safe_link` replaces dirs, no double-installs).
- **Memory-cautious** — the fleet never lets the JVM exceed **3 GB total**
  (verified by `fleet.sh budget`, see `.clinerules`).
- **Lightweight** — Docker Engine + Compose, Lazydocker, Dockge, Cloudflare
  Tunnel only. No heavy control panels.
- **Readable** — small single-purpose shell scripts, centralized config, and a
  consistent `#!/usr/bin/env bash|zsh` shebang.

---

## Repository layout

```text
easy-sh/
├── easy-sh                  # main CLI (menu + flags: -a -d -f -m -u -w -l -b)
├── arch-base/apps.sh        # Arch: base packages + yay + Brave (+ hyprland/, packtracer/)
├── deb-base/                # Debian/Ubuntu desktop (apps.sh) & server (ubuntu-apps.sh)
├── fed-base/apps.sh         # Fedora: dnf packages + VSCode + fonts
├── macos/apps.sh            # macOS: Xcode CLI + Homebrew + Rust/Cargo
├── scripts/                 # lean WSL-focused installers (arch/debian/fedora/macos)
├── servers/                 # Docker Compose game + network fleet (see servers/README.md)
│   ├── minecraft/           #   PaperMC (latest MC + latest Java)
│   ├── terraria/            #   vanilla Terraria
│   ├── cloudflared/         #   Cloudflare Tunnel (HTTPS ingress for web panels)
│   ├── fleet.sh             #   fleet manager (up/down/status/budget/…)
│   └── .env.example         #   shared fleet config (copy to .env)
├── dotfiles/                # shell/editor/config sources linked into $HOME
├── windows/                 # PowerShell bootstrap for Windows
├── .clinerules              # operating rules for AI-assisted management
└── LICENSE                  # MIT
```
---

## Quick start

### On your desktop

```bash
git clone git@github.com:caioy0/easy-sh.git && cd easy-sh

# interactive menu, or pass your distro directly:
./easy-sh                      # shows the interactive menu
./easy-sh -a                   # Arch        | -d Debian | -f Fedora
./easy-sh -m                   # macOS       | -u Ubuntu/Debian server
./easy-sh -w                   # WSL helper menu
./easy-sh -b                   # dotfiles only
./easy-sh --help               # full option list
```

The CLI installs the selected OS toolchain, then sets up **Oh My Zsh** +
plugins + your dotfiles (with automatic `.bak` backups). Pass `--skip-dotfiles`
to skip the dotfiles step.

> Run it with `zsh easy-sh` or make it executable (`chmod +x easy-sh`).

### On your home server

Provision the Docker host and launch the game/network fleet:

```bash
# 1) bootstrap the Docker host (base tools + Docker + lazydocker)
./easy-sh -u                     # or: bash deb-base/ubuntu-apps.sh

# 2) fleet first-run: config files + data dirs
./servers/fleet.sh setup

# 3) edit shared config (passwords, domain, JVM heap)
$EDITOR servers/.env

# 4) provision the Cloudflare Tunnel (interactive: login, create, config)
./servers/fleet.sh cloudflared

# 5) start everything
./servers/fleet.sh up
```

---

## CLI reference

```text
usage: ./easy-sh [options]

 -d | --debian           Debian desktop bootstrap
 -a | --arch             Arch desktop bootstrap
 -f | --fedora           Fedora desktop bootstrap
 -m | --macos            macOS bootstrap
 -u | --ubuntu-server    Ubuntu/Debian server (Docker host) setup
 -w | --wsl              WSL helper menu
 -l | --hyprland         link Hyprland dotfiles on top of an install
 -b | --only-dotfiles    copy & link dotfiles only (no OS packages)
 --skip-dotfiles         run OS packages but do not touch dotfiles
 -h | --help             show this help
```

Without arguments, `easy-sh` prints a menu (pick your distro, then choose to
skip dotfiles or not).

---

## Dotfiles

Everything under `dotfiles/` is the source of truth and gets **linked** (not
copied) into your home directory:

| Source                     | Linked target          |
|----------------------------|------------------------|
| `dotfiles/.zshrc`          | `~/.zshrc`             |
| `dotfiles/.bashrc`         | `~/.bashrc`            |
| `dotfiles/.config/bashrc/` | `~/.config/bashrc`     |
| `dotfiles/.config/nvim/`   | `~/.config/nvim`       |
| `dotfiles/.config/kitty/`  | `~/.config/kitty`      |
| `dotfiles/.config/fastfetch/` | `~/.config/fastfetch` |
| `dotfiles/.config/hypr/` … | `~/.config/hypr` (Hyprland/Arch only) |

Before linking, existing files are backed up to `*.bak`. The link step is
idempotent and safe to re-run (existing real directories are replaced with
symlinks — see `safe_link()` in `easy-sh`).

---

## Home-server fleet

> Full docs: [`servers/README.md`](servers/README.md)

A Docker Compose fleet tuned for a **Debian 13 mini PC (6 GB RAM, 64 GB SSD)**,
held to a **3 GB total JVM** budget:

| Stack      | Image                              | Purpose                          |
|------------|------------------------------------|----------------------------------|
| Minecraft  | `itzg/minecraft-server:latest`     | PaperMC (latest MC + latest Java)|
| Terraria   | `iceoid/terraria-server:latest`    | Vanilla server (lightweight)     |
| Cloudflare | `cloudflare/cloudflared:latest`    | Secure HTTPS web access (e.g. Dockge :5001) |

Manage it with `./servers/fleet.sh`:

```bash
./servers/fleet.sh status       # containers + ports
./servers/fleet.sh logs         # tail logs
./servers/fleet.sh console minecraft   # attach console (Ctrl-P Ctrl-Q)
./servers/fleet.sh info         # live CPU/RAM
./servers/fleet.sh budget       # confirm JVM heap <= 3 GB
./servers/fleet.sh down         # stop (keeps world data)
```

### Fleet resource policy

- **JVM:** Minecraft `MC_MEMORY=2G` is the only JVM service; Terraria is a
  native binary (no JVM heap). `fleet.sh budget` enforces the 3 GB cap.
- **Idle:** set `MC_AUTOPAUSE=true` in `servers/.env` so an empty Minecraft
  server drops to ~0 CPU/RAM; Terraria sits quiet when idle.
- **Remote access:** Cloudflare Tunnel exposes HTTP(S) dashboards
  (Dockge :5001) via `CF_DOMAIN`. Game traffic (Minecraft/Terraria) stays
  LAN/VPN — the tunnel is HTTP/HTTPS only.

---
## Dependencies & tools

**Shell & framework**

- [zsh](https://github.com/zsh-users/zsh) · [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [fzf](https://github.com/junegunn/fzf) (with `fzf-zsh-plugin`)

**Editor & terminal**

- [Neovim](https://neovim.io/) · [Kitty](https://sw.kovidgoyal.net/kitty/) · [btop](https://github.com/aristocratos/btop)

**Wayland / Hyprland (desktop)**

- [Hyprland](https://wiki.hyprland.org/Getting-Started/Installation/) · [Waybar](https://github.com/Alexays/Waybar) · [Wofi](https://hg.sr.ht/~scoopta/wofi) · [Fnott](https://codeberg.org/dnkl/fnott)
- [Waypaper](https://github.com/anufrievroman/waypaper) · [Hyprpaper](https://github.com/hyprwm/hyprpaper)
- [PipeWire](https://pipewire.org/) · [WirePlumber](https://pipewire.pages.freedesktop.org/wireplumber/) · [Pavucontrol](https://freedesktop.org/software/pulseaudio/pavucontrol/)
- [SDDM](https://github.com/sddm/sddm) · [xdg-desktop-portal](https://github.com/flatpak/xdg-desktop-portal) · [Matugen](https://github.com/InioX/matugen)

**Media**

- [ani-cli](https://github.com/pystardust/ani-cli) · [yt-dlp](https://github.com/yt-dlp/yt-dlp) · [FFmpeg](https://github.com/FFmpeg/FFmpeg) · [fastfetch](https://github.com/fastfetch-cli/fastfetch)

**Package managers**

- [yay](https://github.com/Jguer/yay) (Arch) · [nala](https://github.com/volitank/nala) (APT) · [Homebrew](https://brew.sh/) (macOS) · [Scoop](https://scoop.sh) (Windows)

**Browser**

- [Brave](https://brave.com/) · [Firefox](https://www.mozilla.org/firefox/) (with
  [brainfucksec’s user.js hardening guide](https://brainfucksec.github.io/firefox-hardening-guide-2025))

**Bases**

- Dotfiles base: [ml4w-dotfiles](https://github.com/mylinuxforwork/dotfiles)
- Waybar: [waybar-config](https://github.com/mhdzli/dotfiles/tree/home/.config/waybar)

---

## Post-install guides

### 🔐 SSH + GitHub

Generate an Ed25519 key and register it with GitHub:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

Then in GitHub: **Settings → SSH and GPG keys → New SSH key** — paste the
`ssh-ed25519 …` output, give it a title, and save. Verify with:

```bash
ssh -T git@github.com
```

### WSL: non-root default user

Append to `/etc/wsl.conf` and restart WSL:

```ini
[user]
default=username
```

### Arch: create a wheel user from root

```bash
passwd
useradd -m -g users -G wheel -s /bin/bash [username]
echo "%wheel ALL=(ALL) ALL" >/etc/sudoers.d/wheel
passwd [username]
```

### Matugen: apply wallpaper colors

```bash
matugen image <path to image>
```

### macOS

Install MacPorts (`# Install macports`) or prefer the Homebrew path automated
by `./easy-sh -m`.

---

## License

[MIT](LICENSE) © caioy0
