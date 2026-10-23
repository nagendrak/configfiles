#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_LOCAL="${SCRIPT_DIR}/.env.local"
ENV_EXAMPLE="${SCRIPT_DIR}/.env.example"

# Ensure .env.local exists; fallback or prompt from .env.example
if [ ! -f "$ENV_LOCAL" ]; then
  if [ -f "$ENV_EXAMPLE" ]; then
    echo "[!] No .env.local found. Initializing from .env.example..."
    cp "$ENV_EXAMPLE" "$ENV_LOCAL"
  else
    echo "[-] Error: Neither .env.local nor .env.example found."
    exit 1
  fi
fi

# Load variables
set -a
source "$ENV_LOCAL"
set +a

# Defaults if not defined in .env.local
STORAGE_ROOT="${STORAGE_ROOT:-$HOME/srv/docker}"
TIMEZONE="${TIMEZONE:-Asia/Kolkata}"
PUID="${PUID:-$(id -u)}"
PGID="${PGID:-$(id -g)}"

cmd="${1:-}"
service="${2:-}"

usage() {
  cat <<USAGE
Usage: $(basename "$0") <command> <service>

Commands:
  run | up      Ensure directories exist, pull, and start the container
  stop | down   Stop and tear down the container
  restart       Restart the container
  status | ps   View container status
  logs          Follow live log output

Available services in repository:
$(ls -1 "${SCRIPT_DIR}/services" 2>/dev/null | sed 's/^/  - /' || echo "  (none)")
USAGE
  exit 1
}

[ -z "$cmd" ] || [ -z "$service" ] && usage

SERVICE_DIR="${SCRIPT_DIR}/services/${service}"
COMPOSE_FILE="${SERVICE_DIR}/docker-compose.yml"

if [ ! -f "$COMPOSE_FILE" ]; then
  echo "[-] Service definition not found: ${COMPOSE_FILE}"
  exit 1
fi

# Step-specific pre-requisite directory creation
ensure_directories() {
  case "$service" in
    homepage)
      mkdir -p "${STORAGE_ROOT}/homepage/config"
      ;;
    pihole)
      mkdir -p "${STORAGE_ROOT}/pihole/etc-pihole"
      mkdir -p "${STORAGE_ROOT}/pihole/etc-dnsmasq.d"
      ;;
    *)
      mkdir -p "${STORAGE_ROOT}/${service}"
      ;;
  esac
}

case "$cmd" in
  run|up)
    echo "[*] Ensuring persistent directories exist in ${STORAGE_ROOT}/${service}..."
    ensure_directories
    echo "[*] Starting ${service}..."
    docker compose -f "$COMPOSE_FILE" --project-directory "$SERVICE_DIR" up -d
    ;;
  stop|down)
    echo "[*] Stopping ${service}..."
    docker compose -f "$COMPOSE_FILE" --project-directory "$SERVICE_DIR" down
    ;;
  restart)
    echo "[*] Restarting ${service}..."
    docker compose -f "$COMPOSE_FILE" --project-directory "$SERVICE_DIR" restart
    ;;
  status|ps)
    docker compose -f "$COMPOSE_FILE" --project-directory "$SERVICE_DIR" ps
    ;;
  logs)
    docker compose -f "$COMPOSE_FILE" --project-directory "$SERVICE_DIR" logs -f
    ;;
  *)
    usage
    ;;
esac
