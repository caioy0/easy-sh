#!/usr/bin/env bash
#
# setup.sh — Provision a Cloudflare Tunnel ("minipc-tunnel") for the easy-sh
# Docker fleet so you can securely reach local web dashboards (e.g. Dockge on
# :5001) via a custom domain.
#
# Designed to be executed ON the Ubuntu/Debian host (a normal user with sudo).
#
# Run modes:
#   docker   (default) — tunnel runs via Docker Compose (./servers/fleet.sh up)
#   systemd           — tunnel is installed as a native systemd service
#
# Usage:
#   sudo -E bash servers/cloudflared/setup.sh                     # docker mode
#   sudo -E env CF_RUN_MODE=systemd bash servers/cloudflared/setup.sh
#   sudo -E env CF_DOMAIN=panel.yourdomain.com bash servers/cloudflared/setup.sh
#
# Steps performed (in order):
# 1. Env check & prereqs   4. cloudflared tunnel create minipc-tunnel
# 2. Install cloudflared   5. Write config.yml + credentials,
# 3. cloudflared tunnel login    then run via Docker or systemd
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CF_DIR="$REPO_DIR/servers/cloudflared"
ENV_FILE="$REPO_DIR/servers/.env"

# --- configuration (env-file overrides, then env, then defaults) ----------
CF_TUNNEL_NAME="${CF_TUNNEL_NAME:-minipc-tunnel}"
CF_DOMAIN="${CF_DOMAIN:-}"
CF_LOCAL_SERVICE="${CF_LOCAL_SERVICE:-http://localhost:5001}"
CF_RUN_MODE="${CF_RUN_MODE:-docker}"

# --- load values already stored in servers/.env, if any -------------------
[[ -f "$ENV_FILE" ]] && { set -a; source "$ENV_FILE"; set +a; }
CF_TUNNEL_NAME="${CF_TUNNEL_NAME:-minipc-tunnel}"
CF_LOCAL_SERVICE="${CF_LOCAL_SERVICE:-http://localhost:5001}"
CF_RUN_MODE="${CF_RUN_MODE:-docker}"

# --- helpers --------------------------------------------------------------
c_green='\033[1;32m'; c_yellow='\033[1;33m'; c_red='\033[1;31m'; c_reset='\033[0m'
ok()   { printf "${c_green}[✓]${c_reset} %s\n" "$*"; }
warn() { printf "${c_yellow}[!]${c_reset} %s\n" "$*"; }
err()  { printf "${c_red}[✗]${c_reset} %s\n" "$*" >&2; }

# ---------------------------------------------------------------------------
# 1) Environment check & prerequisites + 2) cloudflared install
# ---------------------------------------------------------------------------
install_cloudflared() {
    if command -v cloudflared >/dev/null 2>&1; then
        ok "cloudflared already installed: $(cloudflared --version 2>/dev/null | head -1)"
        return
    fi

    local distro
    distro="$(grep -E '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2)"
    case "$distro" in
        ubuntu|debian|linuxmint)
            warn "cloudflared not found — installing from Cloudflare's APT repo."
            sudo apt-get update -qq
            sudo apt-get install -y curl lsb-release gnupg
            # Cloudflare GPG key (as requested: /etc/apt/keyrings/cloudflare-main.gpg)
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg \
                | sudo tee /etc/apt/keyrings/cloudflare-main.gpg >/dev/null
            # cloudflared APT source ("any" = multi-arch/pinless repo)
            printf 'deb [signed-by=/etc/apt/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main\n' \
                | sudo tee /etc/apt/sources.list.d/cloudflared.list >/dev/null
            sudo apt-get update -qq
            sudo apt-get install -y cloudflared
            ;;
        *)
            err "Unsupported distro '$distro'."
            err "Install cloudflared manually — see https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/"
            exit 1
            ;;
    esac
    ok "cloudflared ready: $(cloudflared --version | head -1)"
}

# ---------------------------------------------------------------------------
# 3) Interactive authentication (browser login). Runs as the invoking user so
#    cert.pem lands in ~/.cloudflared/ (not root's home).
# ---------------------------------------------------------------------------
tunnel_login() {
    local cert="${HOME}/.cloudflared/cert.pem"
    if [[ -f "$cert" ]]; then
        ok "Already authenticated ($cert)."
        return
    fi
    warn "cloudflared tunnel login — a URL will be printed (or opened in your browser)."
    warn "Authorize the domain/zone in that browser, then return to this terminal."
    cloudflared tunnel login
}

# ---------------------------------------------------------------------------
# 4) Create (or reuse) the named tunnel; print its UUID.
# ---------------------------------------------------------------------------
get_tunnel_id() {
    local name="$1" out existing id

    out="$(cloudflared tunnel list 2>/dev/null || true)"
    existing="$(printf '%s\n' "$out" | awk -v n="$name" '$2==n{print $1; exit}')"
    if [[ -n "$existing" ]]; then
        ok "Tunnel '$name' already exists: $existing"
        echo "$existing"
        return
    fi

    out="$(cloudflared tunnel create "$name")"
    printf '\n%s\n' "$out" >&2
    id="$(printf '%s\n' "$out" \
        | grep -oE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' \
        | head -1)"
    [[ -n "$id" ]] || { err "Could not parse tunnel ID from: $out"; return 1; }
    ok "Created tunnel '$name': $id"
    echo "$id"
# ---------------------------------------------------------------------------
# 5a) Write cloudflared config with ingress (domain -> local service + 404).
# ---------------------------------------------------------------------------
gen_config() {
    local id="$1"
    local config="$CF_DIR/config.yml"

    if [[ -z "$CF_DOMAIN" ]]; then
        read -rp "Public hostname for the tunnel [panel.yourdomain.com]: " CF_DOMAIN
        [[ -n "$CF_DOMAIN" ]] || { err "A public hostname is required."; return 1; }
    fi

    cat > "$config" <<EOF
# Cloudflare Tunnel config (generated by setup.sh — re-run to regenerate)
tunnel: $id
credentials-file: /etc/cloudflared/credentials/$id.json
ingress:
  # your public dashboard (e.g. Dockge) exposed over HTTPS
  - hostname: $CF_DOMAIN
    service: $CF_LOCAL_SERVICE
  # catch-all (fallback) -> 404
  - service: http_status:404
EOF
    ok "Wrote $config"
}

# ---------------------------------------------------------------------------
# 5b) Copy the named-tunnel credentials into the repo (mounted read-only
#     by the cloudflared container).
# ---------------------------------------------------------------------------
copy_creds() {
    local id="$1"
    local src="${HOME}/.cloudflared/${id}.json"
    if [[ ! -f "$src" ]]; then
        err "Expected credentials at $src — did 'tunnel create' succeed?"
        return 1
    fi
    install -d -m 0700 "$CF_DIR/credentials"
    install -m 0600 "$src" "$CF_DIR/credentials/${id}.json"
    ok "Credentials copied to $CF_DIR/credentials/${id}.json"
}

# ---------------------------------------------------------------------------
# 5c) (Optional) native systemd service instead of Docker.
# ---------------------------------------------------------------------------
install_systemd() {
    local id="$1"
    warn "Installing cloudflared as a native systemd service."
    sudo mkdir -p /etc/cloudflared/credentials
    sudo install -m 0600 "${HOME}/.cloudflared/${id}.json" "/etc/cloudflared/credentials/${id}.json"
    sudo install -m 0644 "$CF_DIR/config.yml" "/etc/cloudflared/config.yml"
    cloudflared --config /etc/cloudflared/config.yml service install
    sudo systemctl enable --now cloudflared
    sleep 2
    sudo systemctl --no-pager status cloudflared || true
    warn "Tunnel is now managed by systemd (boots automatically)."
}

main() {
    local id
    ok "=== Cloudflare Tunnel setup (easy-sh fleet) ==="
    install_cloudflared      # steps 1 + 2
    tunnel_login             # step 3 (interactive)
    id="$(get_tunnel_id "$CF_TUNNEL_NAME")"   # step 4
    gen_config "$id"         # step 5a
    copy_creds "$id"         # step 5b

    if [[ "$CF_RUN_MODE" == "systemd" ]]; then
        install_systemd "$id"
    else
        ok "Docker mode selected."
        printf '%s\n' ""
        printf '  Next:   %s\n' "./servers/fleet.sh up"
        printf '  Check:  %s\n' "./servers/fleet.sh status"
        printf '  Logs:   %s\n' "./servers/fleet.sh logs cloudflared"
        printf '%s\n' "  Point $CF_DOMAIN's CNAME record at <uuid>.cfargotunnel.com in Cloudflare DNS."
    fi
}

main "$@"
}