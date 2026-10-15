# rc 层 - oh-my-zsh 启动后才能加载的逻辑
#
# 加载入口：.zshrc，在 `source $ZSH/oh-my-zsh.sh` 之后（守卫内，未装 omz 不加载）
#
# 为什么必须放在 omz 之后：zle widget 的包装是链式的——后加载者包装先加载者。
# omz 及其插件先定义了一批 widget，只有在其后加载的插件才能把它们一并纳入包装链。
# 凡是包装/注册 zle widget、或官方要求"放在 .zshrc 末尾"的插件，都属于本文件。
#
# 前置配置（omz 相关变量、设置项、主题、插件列表）见 rc_omz.pre.zsh

# ------------------------------------------------------------------------------
# zsh 插件
#
# zsh-syntax-highlighting 与 zsh-autosuggestions 都通过包装 zle widget 工作，
# 官方均要求在 .zshrc 末尾加载，以便把 omz 及其插件定义的 widget 一并纳入。
# ------------------------------------------------------------------------------

## zsh-syntax-highlighting 命令语法高亮 https://github.com/zsh-users/zsh-syntax-highlighting
if [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  # 如果提示 "highlighters directory not found" 可以取消下面一行的注释
  # ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/highlighters"
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

## zsh-autosuggestions 根据历史命令自动补全建议（灰色提示） https://github.com/zsh-users/zsh-autosuggestions
## 注意：需在 zsh-syntax-highlighting 之后加载
if [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
