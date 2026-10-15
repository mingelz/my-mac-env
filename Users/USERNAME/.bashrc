# bash rc 层入口
#
# 加载时机：交互式 bash。login shell 由 .bash_profile 显式转发到此，
#           非 login 的交互 shell（在 zsh 中敲 bash、tmux、docker exec 等）只读本文件
# 用途：alias、函数、快捷键绑定等只在交互场景有意义的配置


# ------------------------------------------------------------------------------
# 入口守卫与 env 层兜底
# ------------------------------------------------------------------------------

# 非交互 shell 直接返回，避免 bind 等交互专用命令报错
case $- in
  *i*) ;;
  *) return ;;
esac

# 非 login 场景不会经过 .bash_profile，此处补加载 env 层
# （path 层不在此补加载：非 login shell 的 PATH 由父进程继承，
#   确实需要完整 PATH 的场景请使用 `bash -l`）
if [ -z "${_SHELL_ENV_DONE:-}" ]; then
  source "$HOME/.config/shell/env.sh"

  # private*.env.sh 同属 env 层：.bash_profile 未执行时它同样没被加载，兜底需完整复刻其 env 段
  for f in "$HOME"/.config/shell/private*.env.sh; do
    [ -f "$f" ] || continue
    source "$f"
  done
fi


# ------------------------------------------------------------------------------
# 通用配置
# ------------------------------------------------------------------------------

# alias、历史记录、各语言工具
source "$HOME/.config/shell/rc.sh"
# 快捷键
source "$HOME/.config/shell/rc_keys.sh"


# ------------------------------------------------------------------------------
# private 配置
# ------------------------------------------------------------------------------

# private*.rc.sh: 私有 rc 层配置（zsh/bash 共用部分）
for f in "$HOME"/.config/shell/private*.rc.sh; do
  [ -f "$f" ] && source "$f"
done

# private*.rc.bash: 私有 rc 层配置（bash 专属部分）
for f in "$HOME"/.config/shell/private*.rc.bash; do
  [ -f "$f" ] && source "$f"
done


# ------------------------------------------------------------------------------
# 其他配置（当有应用修改此文件时可快速识别）
# ------------------------------------------------------------------------------
