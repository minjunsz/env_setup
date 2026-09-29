#!/usr/bin/env bash
# zsh 가 없으면 pixi global 로 설치한다 (sudo 불필요).
source "$(dirname "$0")/lib.sh"

if have zsh; then
    log "zsh already installed: $(zsh --version)"
else
    have pixi || die "pixi 가 필요합니다 (scripts/pixi.sh 먼저 실행)"
    log "installing zsh via pixi global"
    pixi global install zsh
fi
