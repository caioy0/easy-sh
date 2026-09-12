#!/usr/bin/env bash

# --- UFW firewall setup (v2) ---
# Usage: ./ufw.sh [--dry-run] [--external-ssh]

set -euo pipefail

DRY_RUN=false
EXTERNAL_SSH=false

# --- Arg parsing ---
for arg in "$@"; do
    case "$arg" in
        --dry-run)      DRY_RUN=true ;;
        --external-ssh) EXTERNAL_SSH=true ;;
        -h|--help)
            echo "Usage: $0 [--dry-run] [--external-ssh]"
            echo "  --dry-run       Print rules without applying them"
            echo "  --external-ssh  Allow SSH from anywhere (rate-limited); default is LAN-only"
            exit 0
            ;;
        *) echo "[!] Unknown flag: $arg"; exit 1 ;;
    esac
done

# --- Ask for the trusted local network (default: 192.168.15.0/24) ---
read -r -p "Trusted local network to allow [192.168.15.0/24]: " NETWORK
NETWORK="${NETWORK:-192.168.15.0/24}"

echo "[~] Configuring UFW..."
echo "    Allowing from: $NETWORK"
echo "    External SSH: $EXTERNAL_SSH"
echo "    Dry run:      $DRY_RUN"

# --- Define rules (order matters: defaults first) ---
run() {
    if $DRY_RUN; then
        echo "    [dry-run] $*"
    else
        sudo "$@"
    fi
}

# Defaults: deny incoming, allow outgoing
run ufw default deny incoming
run ufw default allow outgoing

# SSH: LAN-only by default, or rate-limited if --external-ssh
if $EXTERNAL_SSH; then
    run ufw limit 22/tcp
else
    run ufw allow from "$NETWORK" to any port 22 proto tcp
fi

# --- Lockout safety check (skip in dry-run) ---
if ! $DRY_RUN; then
    if ! sudo ufw status 2>/dev/null | grep -q "22/tcp.*ALLOW"; then
        echo "[!] No SSH allow rule detected — aborting to prevent lockout"
        exit 1
    fi
fi

# --- Confirmation before enabling ---
if ! $DRY_RUN; then
    read -r -p "Enable UFW now? [y/N] " confirm
    if [[ "$confirm" == [yY]* ]]; then
        run ufw enable
        run ufw logging on
    else
        echo "[~] UFW rules staged but NOT enabled. Run 'sudo ufw enable' manually."
        exit 0
    fi
else
    echo "    [dry-run] ufw enable"
    echo "    [dry-run] ufw logging on"
fi

echo "[✓] UFW configured."