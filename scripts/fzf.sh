#!/usr/bin/env bash
# fzf 최신 release binary 를 ~/.local/bin 에 설치.
source "$(dirname "$0")/lib.sh"

if have fzf; then
    log "fzf already installed: $(fzf --version)"
    exit 0
fi

case "$ARCH" in
    x86_64)  target=linux_amd64 ;;
    aarch64) target=linux_arm64 ;;
    *) die "unsupported arch: $ARCH" ;;
esac

tag="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/junegunn/fzf/releases/latest)"
tag="${tag##*/}"          # v0.xx.y
ver="${tag#v}"
log "installing fzf $ver"

mkdir -p "$HOME/.local/bin"
curl -fsSL "https://github.com/junegunn/fzf/releases/download/$tag/fzf-$ver-$target.tar.gz" \
    | tar -xz -C "$HOME/.local/bin" fzf
