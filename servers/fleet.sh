#!/usr/bin/env bash
#
# fleet.sh — manage the easy-sh game/network Docker fleet.
#
# Stacks:  minecraft (PaperMC), terraria (vanilla), cloudflared (Cloudflare Tunnel).
#
# Usage:
#   fleet.sh setup            Create .env + data dirs (first run)
#   fleet.sh up               Pull + start all stacks in the background
#   fleet.sh down             Stop and remove the fleet containers
#   fleet.sh restart          Restart all containers
#   fleet.sh pull             Pull the latest images for all stacks
#   fleet.sh status|ps        Show container/port status
#   fleet.sh logs [service]   Follow logs (optionally one service)
#   fleet.sh console <svc>    Attach to a service console (minecraft/terraria)
#   fleet.sh info             Live CPU/RAM of the fleet (resource pressure check)
#   fleet.sh budget           Print the JVM RAM budget used (.clinerules: <= 3G)
#   fleet.sh cloudflared      One-shot: provision the Cloudflare Tunnel
#
# Shares env from servers/.env (auto-created from .env.example on `setup`).

set -euo pipefail

SERVERS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SERVERS_DIR/.env"
ENV_EXAMPLE="$SERVERS_DIR/.env.example"
COMPOSE=(docker compose --project-directory "$SERVERS_DIR" -f "$SERVERS_DIR/docker-compose.yml")

c_green='\033[1;32m'; c_yellow='\033[1;33m'; c_red='\033[1;31m'; c_reset='\033[0m'
ok()   { printf "${c_green}[✓]${c_reset} %s\n" "$*"; }
warn() { printf "${c_yellow}[!]${c_reset} %s\n" "$*"; }
err()  { printf "${c_red}[✗]${c_reset} %s\n" "$*" >&2; }

require_docker() {
    command -v docker >/dev/null 2>&1 || {
        err "docker not found — run the bootstrap first: bash deb-base/ubuntu-apps.sh"
        exit 1
    }
    # Compose 'include' needs the plugin (not the legacy docker-compose v1).
    docker compose version >/dev/null 2>&1 || {
        err "docker compose plugin not available — apt install docker-compose-plugin"
        exit 1
    }
}

setup() {
    # 1) Shared environment file
    if [[ ! -f "$ENV_FILE" ]]; then
        cp "$ENV_EXAMPLE" "$ENV_FILE"
        warn "Created $ENV_FILE — edit it to set passwords / your domain."
    else
        ok "Using $ENV_FILE"
    fi

    # 2) Data directories owned by the invoking user (so containers can write)
    for d in minecraft/data terraria/worlds cloudflared/credentials; do
        mkdir -p "$SERVERS_DIR/$d"
    done
    ok "Data directories ready under $SERVERS_DIR"

    # 4) Pre-pull images so first `up` is fast
    require_docker
    "${COMPOSE[@]}" pull
    ok "Images pulled. Start everything with: $0 up"
}

up() {
    require_docker
    "${COMPOSE[@]}" up -d --remove-orphans
    ok "Fleet up. Status:"
    "${COMPOSE[@]}" ps
}

down() {
    require_docker
    "${COMPOSE[@]}" down
    ok "Fleet down (containers removed; data volumes on disk preserved)."
}

restart() {
    require_docker
    "${COMPOSE[@]}" restart
}

pull() {
    require_docker
    "${COMPOSE[@]}" pull
}

status() {
    require_docker
    "${COMPOSE[@]}" ps
}

logs() {
    require_docker
    if [[ $# -gt 0 ]]; then
        "${COMPOSE[@]}" logs -f --tail=100 "$1"
    else
        "${COMPOSE[@]}" logs -f --tail=100
    fi
}

console() {
    require_docker
    [[ $# -gt 0 ]] || { err "Usage: $0 console <service>  (minecraft | terraria)"; exit 1; }
    # Attach and keep the attached console open (Ctrl-P Ctrl-Q to detach).
    docker attach "$1"
}

info() {
    require_docker
    printf "${c_yellow}Fleet containers${c_reset} (name / status / publish):\n"
    docker ps -a --filter "name=^(minecraft|terraria|cloudflared)$" \
        --format 'table\t{{.Names}}\t{{.Status}}\t{{.Ports}}'
    printf "\n${c_yellow}Live CPU/mem for running fleet containers${c_reset}:\n"
    docker stats --no-stream \
        --format "table;%containerName\t%cpu\t%mem(1)\t%memUsage" \
        $(docker ps --filter "name=^(minecraft|terraria|cloudflared)$" --format '{{.Names}}')
}

budget() {
    local conf="$ENV_FILE"
    [[ -f "$conf" ]] || conf="$ENV_EXAMPLE"
    # Only Java services count against the 3G JVM budget. Minecraft is JVM;
    # Terraria is a native binary (no JVM heap).
    local mc_heap
    mc_heap="$(grep -E '^MC_MEMORY=' "$conf" 2>/dev/null | tail -n1 | cut -d= -f2)"
    mc_heap="${mc_heap:-2G}"

    printf "${c_yellow}JVM RAM budget (.clinerules: NEVER exceed 3 GB total)${c_reset}\n"
    printf "  Minecraft heap (Xmx): %s\n" "$mc_heap"
    printf "  Terraria           : native binary, no JVM heap (~600 MB)\n"
    printf "  Remaining JVM headroom from a %s cap: " "$mc_heap"
    # crude: confirm the configured Minecraft heap is within the 3G cap
    if [[ "$mc_heap" =~ ^[0-9]+[gG]$ ]] && (( ${mc_heap%[gG]} > 3 )); then
        printf "${c_red}OVER 3G — lower MC_MEMORY!${c_reset}\n"
    else
        printf "OK (within 3G).${c_reset}\n"
    fi
}

cloudflared() {
    # One-shot provision: install cloudflared, login, create tunnel, gen config.
    # Run on the Ubuntu/Debian host (needs sudo + browser). CF_RUN_MODE=systemd
    # installs a native systemd unit instead of using Docker.
    "$SERVERS_DIR/cloudflared/setup.sh"
}

usage() {
    sed -n '2,20p' "${BASH_SOURCE[0]:-}" | sed 's/^# \{0,1\}//'
    exit 0
}

cmd="${1:-usage}"
shift || true
case "$cmd" in
    setup)   setup ;;
    up)      up ;;
    down)    down ;;
    restart) restart ;;
    pull)    pull ;;
    status|ps) status ;;
    logs)    logs "$@" ;;
    console) console "$@" ;;
    cloudflared) cloudflared ;;
    info)    info ;;
    budget)  budget ;;
    help|-h|--help|usage) usage ;;
    *) err "Unknown command: $cmd"; usage ;;
esac