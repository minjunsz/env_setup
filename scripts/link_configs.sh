#!/usr/bin/env bash
# configs/ 의 파일을 홈 디렉토리에 symlink 로 연결한다.
source "$(dirname "$0")/lib.sh"

C="$SETUP_ENV_DIR/configs"

link "$C/vimrc"                 "$HOME/.vimrc"
link "$C/gitconfig"             "$HOME/.gitconfig"
link "$C/gitignore_global"      "$HOME/.config/git/ignore"
link "$C/herdr/config.toml"     "$HOME/.config/herdr/config.toml"

# git 사용자 정보는 repo 에 올리지 않고 ~/.gitconfig.local 에 둔다.
# 비대화형 실행 시: GIT_NAME=... GIT_EMAIL=... ./install.sh
if [ ! -f "$HOME/.gitconfig.local" ]; then
    name="${GIT_NAME:-}"; email="${GIT_EMAIL:-}"
    if [ -z "$name" ] && [ -t 0 ]; then read -rp "git user.name: " name; fi
    if [ -z "$email" ] && [ -t 0 ]; then read -rp "git user.email: " email; fi
    if [ -n "$name" ] && [ -n "$email" ]; then
        printf '[user]\n\tname = %s\n\temail = %s\n' "$name" "$email" > "$HOME/.gitconfig.local"
        log "created: ~/.gitconfig.local"
    else
        warn "git user 정보 미설정. ~/.gitconfig.local 을 직접 만드세요."
    fi
fi
