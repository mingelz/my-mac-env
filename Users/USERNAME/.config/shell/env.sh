# env 层 - 环境变量（通用 + 各语言与工具）
#
# 加载入口：.zshenv（zsh 全部调用）、.zshrc（zsh 异常兜底）、.bash_profile（bash login）、.bashrc（bash 非 login 兜底）
#
# 约束：只放纯变量赋值；允许为本层声明的变量所指向的路径做目录保障，
#       但必须 (a) 存在性守卫，保证稳态零 fork；(b) 失败静默，维持无输出。
# 原因：.zshenv 在每次 zsh 调用时都会执行，包括脚本以及 scp/rsync 等依赖干净输出的场景；
#       守卫判断 ~1.6μs 可忽略，而无条件执行命令每次要多付一次 fork（实测 mkdir -p ~12ms/次）。
# 各领域的 PATH 构建见 path.sh，交互功能（alias/函数）见 rc.sh


# ------------------------------------------------------------------------------
# 通用
# ------------------------------------------------------------------------------

## XDG 规范
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

## 设置默认 editor
export EDITOR=vim

## less 历史记录位置，默认 ~/.lesshst
## 需要保障父目录存在，否则 less 既不自动建目录也不告警，也不回落默认路径，只会静默丢弃历史
[ -d "$XDG_STATE_HOME/less" ] || mkdir -p "$XDG_STATE_HOME/less" 2>/dev/null
export LESSHISTFILE="$XDG_STATE_HOME/less/history"


# ------------------------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------------------------

## HOMEBREW_PREFIX 正常由 path.sh 的 brew shellenv 设置，此处兜底，
## 保证未加载 path 层的 shell（如 GUI 应用起的非 login shell）也能取到该变量
export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

## 从 API 拉取包清单，配合下方 HOMEBREW_API_DOMAIN 使用（brew 4.0 起已默认开启，保留是为了显式声明）
export HOMEBREW_INSTALL_FROM_API=1
## 关闭 brew 安装/升级后打印的后续步骤提示
#export HOMEBREW_NO_ENV_HINTS=1
## cask 默认安装在 ~/Applications 下
export HOMEBREW_CASK_OPTS="--appdir=~/Applications --require-sha"

## 指定镜像
export HOMEBREW_BREW_GIT_REMOTE="https://mirror.nju.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirror.nju.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_API_DOMAIN="https://mirror.nju.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirror.nju.edu.cn/homebrew-bottles"
export HOMEBREW_PIP_INDEX_URL="https://mirror.nju.edu.cn/pypi/web/simple"


# ------------------------------------------------------------------------------
# Node.js & npm
# ------------------------------------------------------------------------------

## npm XDG 规范：让 npm 读取 ~/.config/npm/npmrc，而不是 ~/.npmrc
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

## Node 版本管理器的数据目录与镜像（实际初始化见 rc.sh，装了哪个就用哪个）
## 不做存在性判断：未安装对应工具时这些变量不会被任何程序读取
export FNM_DIR="$XDG_DATA_HOME/fnm"
export FNM_NODE_DIST_MIRROR="https://npmmirror.com/mirrors/node"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export NVM_NODEJS_ORG_MIRROR="https://npmmirror.com/mirrors/node"


# ------------------------------------------------------------------------------
# Python & uv
# ------------------------------------------------------------------------------

## uv 镜像（另见 ~/.config/uv/uv.toml）
export UV_INDEX_URL="https://mirror.nju.edu.cn/pypi/web/simple"
export UV_EXTRA_INDEX_URL="https://mirror.nju.edu.cn/pypi/web/simple"


# ------------------------------------------------------------------------------
# 收尾
# ------------------------------------------------------------------------------

## 标记 env 层已加载，供 .zshrc / .bashrc 判断是否需要自行补加载
_SHELL_ENV_DONE=1
