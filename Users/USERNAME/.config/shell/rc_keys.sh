# rc 层 - 快捷键绑定
#
# 加载入口：.zshrc（必须在 omz 启动之后）、.bashrc
#
# 为何必须在 omz 之后：omz 的 lib/key-bindings.zsh 会执行 bindkey -e，
# 把整个 keymap 重置为 emacs 默认，在此之前做的自定义绑定会被静默冲掉（不报错）。
#
# 注意：bash 的 bind 仅在交互 shell 可用，由 .bashrc 开头的 interactive guard 保障

# 一些默认配置中有用的快捷键（两种 shell 通用）
# * `^a`: 移动到行首
# * `^e`/`^k`: 移动到行尾
# * `^d`: 删除光标下的字符
# * `^w`: 向后（左）删除一个单词
# * `^q`/`^u`: 清空当前行
# * `^t`: 交换光标所在字符与前一个字符位置

# 下面两侧绑定的是同一组快捷键，只是 zsh 用 zle、bash 用 readline，改动时请同步
if [ -n "$ZSH_VERSION" ]; then
  ## Control+b 向后（左）移动一个单词（原来是向后（左）移动一个字符）
  bindkey '^b' backward-word
  ## Control+f 向前（右）移动一个单词（原来是向前（右）移动一个字符）
  bindkey '^f' forward-word
elif [ -n "$BASH_VERSION" ]; then
  ## Control+b 向后（左）移动一个单词（原来是向后（左）移动一个字符）
  bind '"\C-b": backward-word'
  ## Control+f 向前（右）移动一个单词（原来是向前（右）移动一个字符）
  bind '"\C-f": forward-word'
fi
