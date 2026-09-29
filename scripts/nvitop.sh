#!/usr/bin/env bash
# nvitop (GPU 모니터링) 을 pixi global 로 설치.
source "$(dirname "$0")/lib.sh"

have pixi || die "pixi 가 필요합니다 (scripts/pixi.sh 먼저 실행)"

if have nvitop; then
    log "nvitop already installed: $(nvitop --version)"
else
    log "installing nvitop via pixi global"
    pixi global install nvitop
fi
