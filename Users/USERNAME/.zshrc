# zsh rc 层入口
#
# 加载时机：交互式 zsh
# 用途：alias、函数、快捷键绑定、oh-my-zsh 等只在交互场景有意义的配置
#
# env 层见 .zshenv，path 层见 .zprofile


# ------------------------------------------------------------------------------
# env 层兜底
# 正常情况下 .zshenv 已加载完 env 层，此处只覆盖异常场景，如外部工具用自定义 ZDOTDIR 启动 zsh
# ------------------------------------------------------------------------------

if [ -z "${_SHELL_ENV_DONE:-}" ]; then
  # 直接复用 .zshenv 而非复刻其内容：env 段只在 .zshenv 维护一份，兜底自动跟进其后续变化
  # （幂等由 env 层「纯赋值」约束保证；绝对路径恰好绕开 ZDOTDIR，加载的正是家目录那份）
  source "$HOME/.zshenv"
fi


# ------------------------------------------------------------------------------
# 通用配置
# ------------------------------------------------------------------------------
source "$HOME/.config/shell/rc.sh"


# ------------------------------------------------------------------------------
# private 配置（omz 启动前）
# ------------------------------------------------------------------------------
# private*.rc.sh: 私有 rc 层配置（zsh/bash 共用部分）
# 后缀已按层分化（.rc.sh 与 .env.sh/.path.sh 互不匹配），无需 case 排除
for f in "$HOME"/.config/shell/private*.rc.sh(N); do
  source "$f"
done

# private*.rc.zsh: rc 层 zsh 专属私有配置（不依赖 omz，未装 omz 也加载）
for f in "$HOME"/.config/shell/private*.rc.zsh(N); do
  source "$f"
done


# ------------------------------------------------------------------------------
# zsh 专属配置：oh-my-zsh 完整生命周期
# ------------------------------------------------------------------------------
if [[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
  # 1. omz 启动前：设置项、主题、插件列表
  source "$HOME/.config/shell/rc_omz.pre.zsh"

  # private*.rc.pre.zsh: omz 前置私有配置（如 $plugins；未装 omz 不加载）
  for f in "$HOME"/.config/shell/private*.rc.pre.zsh(N); do
    source "$f"
  done

  # 2. 启动 omz
  source "$ZSH/oh-my-zsh.sh"

  # 3. omz 启动后：语法高亮、自动建议等依赖 omz 环境的插件
  source "$HOME/.config/shell/rc_omz.post.zsh"

  # 4. omz 启动后私有配置（compdef、依赖 omz 环境的命令等）
  for f in "$HOME"/.config/shell/private*.rc.post.zsh(N); do
    source "$f"
  done
else
  echo "[WARN] oh-my-zsh 未安装，跳过加载。请先安装: https://ohmyz.sh/"
fi

# 快捷键绑定必须在 omz 之后：omz 的 lib/key-bindings.zsh 会执行 bindkey -e，
# 把整个 keymap 重置为 emacs 默认，在此之前的自定义绑定会被静默冲掉。
# 若 omz 未装，bindkey 本身仍生效，只是没有"被重置"这一步。
source "$HOME/.config/shell/rc_keys.sh"


# ------------------------------------------------------------------------------
# 其他配置（当有应用修改此文件时可快速识别）
# ------------------------------------------------------------------------------
