#!/usr/bin/env bash
# 로그인 셸을 zsh 로 바꾼다.
#   1) 이미 zsh 면 skip
#   2) chsh 시도 (zsh 가 /etc/shells 에 있고 tty 가 있을 때만; 비밀번호를 물을 수 있음)
#   3) 실패하면 ~/.bashrc 에서 interactive 시 zsh 로 exec
source "$(dirname "$0")/lib.sh"

zsh_path="$(command -v zsh || true)"
[ -n "$zsh_path" ] || die "zsh 를 찾을 수 없습니다"

current="$(getent passwd "$(id -un)" | cut -d: -f7)"
if [ "$current" = "$zsh_path" ] || [ "$(basename "$current")" = zsh ]; then
    log "로그인 셸이 이미 zsh: $current"
    exit 0
fi

if grep -qxF "$zsh_path" /etc/shells 2>/dev/null && [ -t 0 ]; then
    log "chsh 시도: $zsh_path"
    if chsh -s "$zsh_path"; then
        log "chsh 성공 (다음 로그인부터 적용)"
        exit 0
    fi
    warn "chsh 실패 → ~/.bashrc 방식으로 대체"
else
    warn "chsh 불가 ($zsh_path 가 /etc/shells 에 없거나 tty 없음) → ~/.bashrc 방식으로 대체"
fi

rc="$HOME/.bashrc"
begin="# >>> setup_env: exec zsh >>>"
end="# <<< setup_env: exec zsh <<<"

touch "$rc"
if grep -qF "$begin" "$rc"; then
    log "~/.bashrc 에 이미 설정됨"
    exit 0
fi

cat >> "$rc" <<BLOCK

$begin
case \$- in
    *i*)
        if [ -z "\${ZSH_VERSION:-}" ] && command -v zsh >/dev/null 2>&1; then
            export SHELL="\$(command -v zsh)"
            exec zsh -l
        fi
        ;;
esac
$end
BLOCK
log "~/.bashrc 에 zsh exec block 추가"
