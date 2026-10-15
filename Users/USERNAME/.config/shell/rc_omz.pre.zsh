# rc 层 - oh-my-zsh 前置配置（omz 相关变量、设置项、主题、插件列表）
#
# 加载入口：.zshrc，在 `source $ZSH/oh-my-zsh.sh` 之前（守卫内，未装 omz 不加载）
# 需要在 omz 启动后才能加载的内容见 rc_omz.post.zsh
#
# 内部各段相互独立、先后无关（唯一顺序依赖：ZSH_COMPDUMP 先于其 mkdir），整体只需先于 omz 启动

# ------------------------------------------------------------------------------
# omz 基础设施
# ------------------------------------------------------------------------------

## omz 安装目录：.zshrc 用它定位 oh-my-zsh.sh，omz 及其插件也依赖此变量。
## 虽然 omz 启动时也会自行设置，但显式声明可以不依赖其内部默认值
export ZSH="$HOME/.oh-my-zsh"

## 补全缓存文件位置（默认在 $HOME 根目录，这里迁到 XDG cache）。
## zsh 通过 compinit 初始化自动补全系统（按 Tab 补全命令或参数），
## 并将缓存保存在 zcompdump 文件中，位置由 ZSH_COMPDUMP 变量控制
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump-${ZSH_VERSION}"
mkdir -p "$(dirname "$ZSH_COMPDUMP")"

# ------------------------------------------------------------------------------
# omz 行为开关（启动时读取，无路径语义与副作用）
# ------------------------------------------------------------------------------

# 命令大小写不敏感
CASE_SENSITIVE="false"
# Waiting状态
COMPLETION_WAITING_DOTS="true"
# 针对VCS仓库状态检测进行提速，忽略未跟踪文件
DISABLE_UNTRACKED_FILES_DIRTY="true"
# 命令自动修复
ENABLE_CORRECTION="true"
# 命令连字符（包括 _ 和 - ）不敏感
HYPHEN_INSENSITIVE="true"
# 跳过不安全目录的验证
ZSH_DISABLE_COMPFIX="true"

# ------------------------------------------------------------------------------
# 主题
# 官方主题可参考 https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ------------------------------------------------------------------------------

ZSH_THEME="ys"

# ------------------------------------------------------------------------------
# 插件
# 官方插件可参考 https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
# ------------------------------------------------------------------------------

## 插件配置 - vi
#VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
#VI_MODE_SET_CURSOR=true

## 插件配置 - z
### 用习惯 autojump 了，所以继续用 j 做快捷键
ZSHZ_CMD=j
## z 的历史数据文件；其所在目录由 rc.sh 的历史记录段 mkdir -p 保障（rc.sh 先于本文件加载）
ZSHZ_DATA="$XDG_STATE_HOME/zsh/z"

## 启用插件（默认插件在 $ZSH/plugins/、自定义插件在 $ZSH_CUSTOM/plugins/）
plugins=(
  brew
  z
)
