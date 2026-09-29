#!/usr/bin/env bash
# 공통 helper. 다른 스크립트에서 source 해서 사용한다.
set -euo pipefail

SETUP_ENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export SETUP_ENV_DIR
export PATH="$HOME/.local/bin:$HOME/.pixi/bin:$PATH"

log()  { printf '\033[1;34m[setup_env]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[setup_env] WARN:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[setup_env] ERROR:\033[0m %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

# link <repo 내 원본> <대상 경로>
# 대상이 이미 올바른 symlink 면 skip, 일반 파일이면 .bak.<timestamp> 로 백업 후 링크.
link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
        log "link ok: $dst"
        return
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        local bak="$dst.bak.$(date +%Y%m%d%H%M%S)"
        warn "backup: $dst -> $bak"
        mv "$dst" "$bak"
    fi
    ln -s "$src" "$dst"
    log "linked: $dst -> $src"
}

# 아키텍처 (x86_64 | aarch64)
ARCH="$(uname -m)"
