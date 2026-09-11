#!/usr/bin/env bash
#
# ubuntu-apps.sh — Ubuntu/Debian *server* bootstrap for easy-sh
#
# Goal: turn a fresh Ubuntu/Debian box into a lightweight, resource-friendly
# Docker host (fits a resource-constrained mini PC, see .clinerules). It sets
# up:
#   - core CLI tools + nala (nicer apt frontend)
#   - Docker Engine + Docker Compose plugin (official get.docker.com script)
#   - lazydocker  — fast Docker TUI (CLI tool, NOT a daemon)
#   - Dockge      — lightweight web panel (optional: WITH_DOCKGE=1)
#
# Idempotent: safe to re-run. Run as a normal user; the script elevates to
# root itself when needed and keeps the invoking user's identity for
# user-scoped tools (docker group, ~/.local/bin, lazydocker config).
#
# Usage:
#   bash deb-base/ubuntu-apps.sh                # base + docker + lazydocker
#   WITH_DOCKGE=1 bash deb-base/ubuntu-apps.sh  # also start Dockge on :5001

set -euo pipefail

INSTALL_DOCKGE="${WITH_DOCKGE:-0}"

log() { printf "\033[1;32m[+]\033[0m %s\n" "$*"; }
ok()  { printf "\033[1;32m[✓]\033[0m %s\n" "$*"; }
warn(){ printf "\033[1;33m[!]\033[0m %s\n" "$*"; }

# ---------------------------------------------------------------------------
# Elevate to root, preserving env + invoking user identity.
# ---------------------------------------------------------------------------
if [[ "$(id -u)" -ne 0 ]]; then
    warn "Not running as root — re-invoking with sudo (keep your password ready)."
    exec sudo -E bash "$0" "$@"
fi

REAL_USER="${SUDO_USER:-root}"
USER_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"
[[ -n "$USER_HOME" ]] || USER_HOME="/root"

# ---------------------------------------------------------------------------
# 1) Base packages
# ---------------------------------------------------------------------------
install_base() {
    log "Updating the system"
    apt update -qq
    apt upgrade -y

    log "Installing base packages"
    apt install -y \
        curl wget git zsh neovim fzf gnupg ufw btop \
        tmux htop tasksel ca-certificates unzip nala

}

# ---------------------------------------------------------------------------
# 2) Docker Engine + Compose plugin
# ---------------------------------------------------------------------------
install_docker() {
    if command -v docker >/dev/null 2>&1; then
        ok "Docker already installed: $(docker --version)"
    else
        log "Installing Docker Engine + Compose plugin (official script)"
        curl -fsSL https://get.docker.com | sh
    fi

    if ! docker compose version >/dev/null 2>&1; then
        apt install -y docker-compose-plugin \
            || warn "Compose plugin missing — try 'apt install docker-compose-plugin'."
    fi

    if [[ "$REAL_USER" != "root" ]]; then
        usermod -aG docker "$REAL_USER"
        ok "Added '$REAL_USER' to the 'docker' group (re-login or 'newgrp docker' to apply)"
    fi
}

# ---------------------------------------------------------------------------
# 3) lazydocker — fast Docker TUI. Installed as the real user (no daemon).
# ---------------------------------------------------------------------------
install_lazydocker() {
    if [[ -x "$USER_HOME/.local/bin/lazydocker" ]] \
        || command -v lazydocker >/dev/null 2>&1; then
        ok "lazydocker already installed"
        return
    fi

    log "Installing lazydocker (CLI TUI) for '$REAL_USER'"
    if [[ "$REAL_USER" != "root" ]]; then
        sudo -u "$REAL_USER" bash -c \
            'curl -fsSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/installer.sh | bash'
    else
        curl -fsSL \
            https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/installer.sh \
            | bash
    fi

    # Expose it on root's PATH for convenience without clobbering existing bins.
    if [[ -x "$USER_HOME/.local/bin/lazydocker" ]] \
        && [[ ! -e /usr/local/bin/lazydocker ]]; then
        ln -sf "$USER_HOME/.local/bin/lazydocker" /usr/local/bin/lazydocker
    fi
    ok "lazydocker ready — run: lazydocker"
}

# ---------------------------------------------------------------------------
# 4) Dockge — lightweight web panel (optional, WITH_DOCKGE=1)
# ---------------------------------------------------------------------------
install_dockge() {
    [[ "$INSTALL_DOCKGE" == "1" ]] || return 0

    local stacks_dir="/opt/stacks"
    local dockge_dir="/opt/dockge"

    if ! command -v docker >/dev/null 2>&1; then
        warn "Docker is required for Dockge — skipping."
        return 1
    fi

    log "Setting up Dockge in $dockge_dir"
    install -d -m 0755 "$stacks_dir" "$dockge_dir"

    curl -fsSL \
        https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml \
        -o "$dockge_dir/compose.yaml"

    ( cd "$dockge_dir" && docker compose up -d )

    # Make stack dir writable by the admin/docker user.
    if [[ "$REAL_USER" != "root" ]]; then
        chown -R "$REAL_USER" "$stacks_dir" "$dockge_dir"
    fi

    ok "Dockge started — open http://<host>:5001"
}

# ---------------------------------------------------------------------------
main() {
    install_base
    install_docker
    install_lazydocker
    install_dockge

    printf "\n\033[1;32m[Done]\033[0m Ubuntu/Debian server ready.\n"
    printf "  • Re-login (or 'newgrp docker') to use docker without sudo.\n"
    printf "  • Run 'lazydocker' for the Docker TUI.\n"
    [[ "$INSTALL_DOCKGE" == "1" ]] \
        && printf "  • Dockge UI: http://<host>:5001\n"
}
main "$@"
