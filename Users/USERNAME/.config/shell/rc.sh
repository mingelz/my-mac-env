# rc 层 - 交互功能（通用 alias、历史记录、各语言与工具的 alias/函数/hook）
#
# 加载入口：.zshrc（位于 omz 之前）、.bashrc
#
# omz 相关的时序约束：
# - 本文件在 omz 启动之前加载（HISTFILE 必须先于 omz 设置）
# - omz 会重置 keymap，快捷键见 rc_keys.sh（omz 之后加载）
# - omz 前置/后置配置见 rc_omz.pre.zsh / rc_omz.post.zsh
#
# 各领域的环境变量见 env.sh，PATH 构建见 path.sh


# ------------------------------------------------------------------------------
# 通用 alias
# ------------------------------------------------------------------------------

## 提供列表形式、查看所有文件的 ls
alias la="ls -AlhG"

## 让 vim 命令使用 macvim，支持高级特性
## 从 macOS 12 开始系统自带的 vim 已经 +clipboard，不需要额外安装 MacVim 了
#alias vim="mvim -v"

## 不带任何配置启动 vim 命令，适合打开大文件
alias vimc="vim -u NONE -c 'set syntax=no filetype=text'"

## 使用 sudo 命令执行上一条命令
## 注意因为命令中有反引号，所以外边只能使用单引号包裹，而不能用双引号
alias please='sudo `fc -nl -1`'


# ------------------------------------------------------------------------------
# 历史记录
#
# 1. HISTFILE 不能 export，否则会泄漏给子 shell，导致在 zsh 中启动的 bash 把命令写进 zsh 的历史文件
# 2. 两种 shell 的配置项一一对应，改动时请同步两侧：
#   | 意图             | zsh                      | bash                    |
#   |------------------|--------------------------|-------------------------|
#   | 历史文件位置     | HISTFILE                 | HISTFILE                |
#   | 内存保留条数     | HISTSIZE                 | HISTSIZE                |
#   | 落盘保留条数     | SAVEHIST                 | HISTFILESIZE            |
#   | 忽略空格前缀命令 | setopt hist_ignore_space | HISTCONTROL=ignorespace |
# ------------------------------------------------------------------------------

_state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"
_hist_size=50000
mkdir -p "$_state_dir/zsh" "$_state_dir/bash"

if [ -n "$ZSH_VERSION" ]; then
  ## zsh 历史记录文件位置，默认 ~/.zsh_history
  HISTFILE="$_state_dir/zsh/history"
  ## 显式设置而不依赖 omz：omz 只把 SAVEHIST 提到 10000，会与 bash 侧差 5 倍
  HISTSIZE=$_hist_size
  SAVEHIST=$_hist_size
  ## 以 <space> 开头的命令不记录进 history（omz 也会设置，此处显式声明以不依赖 omz）
  setopt hist_ignore_space
elif [ -n "$BASH_VERSION" ]; then
  ## bash 历史记录文件位置，默认 ~/.bash_history
  HISTFILE="$_state_dir/bash/history"
  HISTSIZE=$_hist_size
  HISTFILESIZE=$_hist_size
  ## 以 <space> 开头的命令不记录进 history
  HISTCONTROL=ignorespace
fi

unset _state_dir _hist_size


# ------------------------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------------------------

## 列出安装项目的依赖关系，omz 的 brew 插件没提供类似能力，所以自己加一个
alias bldeps="brew leaves | xargs brew deps --tree --include-build"


# ------------------------------------------------------------------------------
# Java & Maven
# ------------------------------------------------------------------------------

## 切换 JDK 版本函数，如 `jdk 8` 即切换到 JDK 8（不带参数显示当前版本）
### 必须是函数而非 ~/.local/bin 脚本：要 export JAVA_HOME 并改写调用者的 PATH，
### 脚本跑在子进程里，内部即使用 eval 也只作用于子进程本身，退出即蒸发；
### 想影响父 shell 只能让调用方自己包装（eval "$(jdk 8)"），交互体验变差，故留在此处
jdk() {
  if [ -z "$1" ]; then
    java -version 2>&1 | head -1
    echo "JAVA_HOME=$JAVA_HOME"
    printf '\nInstalled versions:\n'
    ## java_home 把版本列表写在 stderr、默认版本路径写在 stdout，这里只要列表；
    ## 丢弃 stdout 必须用花括号分组：zsh 默认开启 MULTIOS，会把
    ## `cmd 2>&1 >/dev/null | pipe` 当成 tee，仍将 stdout 写进管道（bash 无此行为）
    { /usr/libexec/java_home -V >/dev/null; } 2>&1 | tail -n +2
    return
  fi

  ## java_home 只认 1.8 不认 8，这里做一次归一化
  local _ver="$1"
  [ "$_ver" = "8" ] && _ver=1.8

  if ! /usr/libexec/java_home -v "$_ver" -F >/dev/null 2>&1; then
    echo "JDK $1 not found. Installed versions:"
    ## 同上：花括号分组以避免 zsh 的 MULTIOS 把 stdout 也写进管道
    { /usr/libexec/java_home -V >/dev/null; } 2>&1 | tail -n +2
    return 1
  fi

  ## 先从 PATH 中摘掉当前版本，避免反复切换后 PATH 里堆积多个 JDK
  ## 注意：模式不能加引号，zsh 下 ${var//"pat"/rep} 不会发生替换
  if [ -n "$JAVA_HOME" ]; then
    local _old="$JAVA_HOME/bin"
    PATH=":$PATH:"
    PATH="${PATH//:$_old:/:}"
    PATH="${PATH#:}"
    PATH="${PATH%:}"
  fi

  export JAVA_HOME="$(/usr/libexec/java_home -v "$_ver")"
  export PATH="$JAVA_HOME/bin:$PATH"
  echo "Switched to JDK $1: $JAVA_HOME"
}


# ------------------------------------------------------------------------------
# Node.js & npm
# ------------------------------------------------------------------------------

## 指定 cnpm 而不是安装独立的 bin
alias cnpm="npm --registry=https://registry.npmmirror.com"
### ncu 命令由 [npm-check-updates](https://www.npmjs.com/package/npm-check-updates) 提供
alias cncu="ncu --registry=https://registry.npmmirror.com"

## 初始化 Node 版本管理器：装了哪个就用哪个，两个都有时优先 fnm
### 两者的检测方式不同：fnm 是可执行文件，用 command -v 即可；
### nvm 本身是 source 进来的 shell 函数，source 之前 command -v 查不到，只能判断脚本文件是否存在
### 相关环境变量（FNM_DIR / NVM_DIR / 镜像）见 env.sh
if command -v fnm >/dev/null 2>&1; then
  ## --use-on-cd 表示切换目录时识别项目依赖的 node 版本并自动切换，
  ## 依赖 shell 自身的 hook 机制（zsh 用 chpwd、bash 用 PROMPT_COMMAND），故属于 rc 层。
  ## --shell 必须与当前 shell 匹配，否则会向另一种 shell 输出无法识别的语法。
  if [ -n "$ZSH_VERSION" ]; then
    eval "$(fnm env --use-on-cd --shell zsh)"
  elif [ -n "$BASH_VERSION" ]; then
    eval "$(fnm env --use-on-cd --shell bash)"
  fi
elif [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]; then
  . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
fi


# ------------------------------------------------------------------------------
# Python & pip & uv
# ------------------------------------------------------------------------------

### 注意: 覆盖 python/python3 后，复杂参数（如 -m venv、-- 分隔参数）可能行为不一致
### 建议日常使用 `uv run python`，需要 venv 等高级功能时直接用完整命令
if command -v uv >/dev/null 2>&1; then
  alias python='uv run python'
  alias python3='uv run python'
fi
