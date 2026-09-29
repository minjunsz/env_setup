#!/usr/bin/env bash
# oh-my-zsh 와 plugin (zsh-autosuggestions, zsh-syntax-highlighting) 설치.
source "$(dirname "$0")/lib.sh"

have git  || die "git 이 필요합니다"
have curl || die "curl 이 필요합니다"

export ZSH="${ZSH:-$HOME/.oh-my-zsh}"

if [ -d "$ZSH" ]; then
    log "oh-my-zsh already installed"
else
    log "installing oh-my-zsh"
    # .zshrc 는 zshrc.sh 가 생성하므로 installer 는 건드리지 않게 한다.
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

plugin() {
    local name="$1" url="$2" dir="${ZSH_CUSTOM:-$ZSH/custom}/plugins/$1"
    if [ -d "$dir/.git" ]; then
        log "updating plugin: $name"
        git -C "$dir" pull --ff-only -q || warn "update failed: $name"
    else
        log "installing plugin: $name"
        git clone --depth 1 -q "$url" "$dir"
    fi
}

plugin zsh-autosuggestions     https://github.com/zsh-users/zsh-autosuggestions
plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting
