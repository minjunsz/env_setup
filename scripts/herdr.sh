#!/usr/bin/env bash
# herdr 설치 (~/.local/bin). 이미 있으면 skip.
source "$(dirname "$0")/lib.sh"

if have herdr; then
    log "herdr already installed: $(herdr --version)"
else
    log "installing herdr"
    curl -fsSL https://herdr.dev/install.sh | sh
fi
