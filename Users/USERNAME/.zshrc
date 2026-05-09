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

# oh-my-zsh
source "$HOME/.config/shellrc/omz_env.sh"
source "$HOME/.config/shellrc/omz_plugin.sh"

# zsh 历史记录文件位置
export HISTFILE="$XDG_STATE_HOME/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"

# ------------------------------------------------
# private 配置
# ------------------------------------------------
# private*.sh: 通用配置
for f in "$HOME"/.config/shellrc/private*.sh(N); do
  [[ "$f" != *.example ]] && source "$f"
done
# ------------------------------------------------
# private*.pre.zsh: 适合放在 omz 启动前的配置（如设置环境变量等）
for f in "$HOME"/.config/shellrc/private*.pre.zsh(N); do
  [[ "$f" != *.example ]] && source "$f"
done
# ------------------------------------------------
# === 启动 oh-my-zsh ===
source "$ZSH/oh-my-zsh.sh"
# ------------------------------------------------
# private*.post.zsh: 适合放在 omz 启动后的配置（如依赖 omz 环境中的命令等）
for f in "$HOME"/.config/shellrc/private*.post.zsh(N); do
  [[ "$f" != *.example ]] && source "$f"
done
# ------------------------------------------------
