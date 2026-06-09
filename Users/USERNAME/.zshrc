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
# zsh 专属配置
# ------------------------------------------------
# 快捷键配置
source "$HOME/.config/shellrc/base_keys.zsh"

# oh-my-zsh
source "$HOME/.config/shellrc/omz_env.sh"
source "$HOME/.config/shellrc/omz_plugin.sh"

# zsh 历史记录文件位置（与 bash 共用 HISTFILE 配置名称），默认 ~/.zsh_history
export HISTFILE="$XDG_STATE_HOME/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"


# ------------------------------------------------
# private 配置
# ------------------------------------------------
# private*.sh: 私有通用配置
for f in "$HOME"/.config/shellrc/private*.sh(N); do
  [[ "$f" != *.example ]] && source "$f"
done

# private*.pre.zsh: 适合放在 omz 启动前的私有 zsh 专属配置（如设置环境变量等）
for f in "$HOME"/.config/shellrc/private*.pre.zsh(N); do
  [[ "$f" != *.example ]] && source "$f"
done

# === 启动 oh-my-zsh ===
if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  echo "[WARN] oh-my-zsh 未安装，跳过加载。请先安装: https://ohmyz.sh/"
fi

# private*.post.zsh: 适合放在 omz 启动后的私有 zsh 专属配置（如依赖 omz 环境中的命令等）
for f in "$HOME"/.config/shellrc/private*.post.zsh(N); do
  [[ "$f" != *.example ]] && source "$f"
done


# ------------------------------------------------
# 其他配置（当有应用修改此文件时可快速识别）
# ------------------------------------------------
