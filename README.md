# setup_env

새 서버에서 개발 환경을 세팅하는 스크립트와 config 모음. sudo 불필요, 재실행 안전.

```bash
git clone <repo> ~/setup_env && cd ~/setup_env
./install.sh                 # 전체
./install.sh herdr fzf       # 일부 step 만
GIT_NAME=me GIT_EMAIL=me@x ./install.sh   # git user 비대화형 지정
```

## Steps (실행 순서)

| step | 내용 |
|---|---|
| `pixi` | pixi 설치 (`~/.pixi/bin`) |
| `zsh` | zsh 가 없으면 `pixi global install zsh` |
| `oh-my-zsh` | oh-my-zsh + zsh-autosuggestions + zsh-syntax-highlighting |
| `fzf` | fzf release binary → `~/.local/bin` |
| `herdr` | herdr → `~/.local/bin` |
| `nvitop` | `pixi global install nvitop` |
| `zshrc` | oh-my-zsh 기본 템플릿에서 `~/.zshrc` 생성 (plugins 치환 + 공통 block) |
| `link_configs` | `configs/` → `~` symlink, `~/.gitconfig.local` 생성 |
| `login_shell` | `chsh` 시도, 실패하면 `~/.bashrc` 에서 `exec zsh` |

## 구조

- `configs/` : symlink 로 연결되는 config (vimrc, gitconfig, gitignore_global, herdr/config.toml)
- `scripts/` : step 별 스크립트, `lib.sh` 는 공통 helper
- 서버별 값(CUDA, GPU 등)은 `~/.zshrc.local`, git user 는 `~/.gitconfig.local` 에 둔다. repo 에는 올라가지 않는다.
- 기존 파일이 있으면 `.bak.<timestamp>` 로 백업 후 덮어쓴다.
