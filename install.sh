#!/usr/bin/env bash
# 새 서버 환경 세팅 진입점 (sudo 불필요, 재실행 안전).
#
#   ./install.sh                # 전체
#   ./install.sh pixi herdr     # 일부 step 만
#
# git user 를 비대화형으로 지정: GIT_NAME=... GIT_EMAIL=... ./install.sh
set -euo pipefail
cd "$(dirname "$0")"

# 순서 중요: zsh 는 pixi 필요, zshrc 는 oh-my-zsh 템플릿 필요
STEPS=(pixi zsh oh-my-zsh fzf herdr nvitop zshrc link_configs login_shell)
[ "$#" -gt 0 ] && STEPS=("$@")

for s in "${STEPS[@]}"; do
    f="scripts/$s.sh"
    [ -f "$f" ] || { echo "unknown step: $s (available: $(ls scripts | sed -n 's/\.sh$//p' | grep -v '^lib$' | tr '\n' ' '))" >&2; exit 1; }
    echo "==== $s ===="
    bash "$f"
done

echo "완료. 새 셸을 열거나 'exec zsh' 를 실행하세요."
