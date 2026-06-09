# ------------------------------------------------
# 通用配置
# ------------------------------------------------
# base
source "$HOME/.config/shellrc/base_alias.sh"
source "$HOME/.config/shellrc/base_env.sh"
source "$HOME/.config/shellrc/base_func.sh"

# lang
source "$HOME/.config/shellrc/lang_java.sh"
source "$HOME/.config/shellrc/lang_node.sh"
source "$HOME/.config/shellrc/lang_python.sh"
source "$HOME/.config/shellrc/lang_ruby.sh"

# util
source "$HOME/.config/shellrc/util_homebrew.sh"


# ------------------------------------------------
# bash 专属配置
# ------------------------------------------------
# 快捷键配置
source "$HOME/.config/shellrc/base_keys.bash"

# bash 历史记录文件位置（与 zsh 共用 HISTFILE 配置名称），默认 ~/.bash_history
export HISTFILE="$XDG_STATE_HOME/bash/history"
mkdir -p "$(dirname "$HISTFILE")"


# ------------------------------------------------
# private 配置
# ------------------------------------------------
# private*.sh: 私有通用配置
for f in "$HOME"/.config/shellrc/private*.sh; do
  [[ -f "$f" && "$f" != *.example ]] && source "$f"
done

# private*.bash: 私有 bash 专属配置
for f in "$HOME"/.config/shellrc/private*.bash; do
  [[ -f "$f" && "$f" != *.example ]] && source "$f"
done


# ------------------------------------------------
# 其他配置（当有应用修改此文件时可快速识别）
# ------------------------------------------------
