#!/usr/bin/env bash
# pixi 설치 (~/.pixi/bin). shell rc 는 건드리지 않는다 (zshrc 스크립트가 PATH 를 관리).
source "$(dirname "$0")/lib.sh"

if have pixi; then
    log "pixi already installed: $(pixi --version)"
else
    log "installing pixi"
    curl -fsSL https://pixi.sh/install.sh | PIXI_NO_PATH_UPDATE=1 bash
fi
