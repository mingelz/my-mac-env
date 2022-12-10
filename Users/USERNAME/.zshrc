# 设置项
ZSH_DISABLE_COMPFIX="true" #跳过不安全目录的验证
ZSH_THEME="ys" #omz皮肤，所有主题可参考 https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
CASE_SENSITIVE="false" #命令大小写不敏感
HYPHEN_INSENSITIVE="true" #命令连字符（包括 _ 和 - ）不敏感
# ENABLE_CORRECTION="true" #命令自动修复
COMPLETION_WAITING_DOTS="true" #Waiting状态
# DISABLE_UNTRACKED_FILES_DIRTY="true" #针对VCS仓库状态检测进行提速，忽略未跟踪文件

# 安装 oh-my-zsh 的路径
export ZSH="$HOME/.oh-my-zsh"

# 插件，默认插件在 $ZSH/plugins/，自定义插件在 $ZSH_CUSTOM/plugins/，更多插件可以参考 https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(
  brew
  copyfile
  copypath
  z
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# 插件设置
#VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
#VI_MODE_SET_CURSOR=true

# 外部配置
source ~/.bash_profile
source $ZSH/oh-my-zsh.sh
