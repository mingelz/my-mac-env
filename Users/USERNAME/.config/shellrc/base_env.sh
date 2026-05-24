# 环境配置

## XDG 规范
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

## 设置默认 editor
export EDITOR=vim

## 以 <space> 开头的命令不记录进 history
export HISTCONTROL=ignorespace

## less 历史记录位置，默认 ~/.lesshst
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
mkdir -p "$(dirname "$LESSHISTFILE")"

## 添加用户 bin 路径（避免重复追加）
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
