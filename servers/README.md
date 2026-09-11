# Game & Network Fleet (Docker Compose)

Lightweight game servers + remote-access agent for the Debian 13 mini PC,
built to the `.clinerules` resource budget: **never exceed 3 GB total JVM RAM**.

| Stack      | Image                          | Purpose                          | Data dir        |
|------------|--------------------------------|----------------------------------|-----------------|
| Minecraft  | `itzg/minecraft-server:latest` | PaperMC (latest MC + latest Java)| `minecraft/data`|
| Terraria   | `iceoid/terraria-server:latest`| Vanilla server (lightweight)     | `terraria/worlds`|
| Cloudflare | `cloudflare/cloudflared:latest`| Secure HTTPS remote web access    | `cloudflared/`  |

## Quick start

```bash
# 1) First run: create .env, data dirs, pull images
./servers/fleet.sh setup

# 2) Edit the shared config (passwords, domain, heap size)
$EDITOR servers/.env

# 3) Provision + start the Cloudflare Tunnel (guides login/create/config):
./servers/fleet.sh cloudflared        # then follow the prompts
./servers/fleet.sh up
```

## Day-to-day

```bash
./servers/fleet.sh status        # container status + published ports
./servers/fleet.sh logs          # tail all logs
./servers/fleet.sh logs minecraft
./servers/fleet.sh console minecraft   # attach (detach: Ctrl-P, Ctrl-Q)
./servers/fleet.sh info          # live CPU/RAM of the fleet
./servers/fleet.sh budget        # confirm JVM heap is within the 3G cap
./servers/fleet.sh down          # stop + remove containers (keeps data)
```

## Ports

| Service   | Port  | Protocol |
|-----------|-------|----------|
| Minecraft | 25565 | TCP + UDP (game) |
| Minecraft | 25599 | TCP (RCON admin) |
| Terraria  | 7777  | TCP + UDP (game) |
| Cloudflare| —     | host networking; HTTPS ingress via config.yml |

## Resource & idle policy (`.clinerules`)

- **JVM budget:** Minecraft default `MC_MEMORY=2G`, the only JVM service.
  Terraria's server is a native binary and does not consume JVM heap.
- **Idle cost:** Minecraft can auto-pause when empty — set `MC_AUTOPAUSE=true`
  in `servers/.env` (JVM drops to ~0 CPU/RAM while nobody is connected).
- **Terraria** is lightweight (≈ a few hundred MB) and stays quiet when idle.

## Notes

- **First Minecraft boot** downloads the PaperMC jar, so give it a minute; watch
  with `./servers/fleet.sh logs minecraft`.
- **Terraria** auto-creates its world on first boot from `TERRARIA_WORLDNAME`.
- **Cloudflare Tunnel** exposes HTTP(S) dashboards (e.g. Dockge on `:5001`) via
  `CF_DOMAIN`. Provision it once with `./servers/fleet.sh cloudflared` (or
  `sudo bash servers/cloudflared/setup.sh`) — it installs `cloudflared`, runs
  `cloudflared tunnel login` + `tunnel create minipc-tunnel`, and generates
  `cloudflared/config.yml` + credentials. `CF_RUN_MODE=systemd` installs the
  native systemd service instead of Docker. For inbound SSH/game traffic
  (Minecraft/Terraria) use a VPN or LAN — Cloudflare Tunnel is HTTP/HTTPS only.
- Everything is idempotent — re-running `fleet.sh setup` / `up` is safe.