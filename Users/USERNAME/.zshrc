## 设置项
ZSH_DISABLE_COMPFIX="true" #跳过不安全目录的验证
ZSH_THEME="ys" #omz皮肤，所有主题可参考 https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_COMPDUMP="$HOME/.zcompdump" #指定compinit的缓存地址，更多信息我记录在此文件末尾
CASE_SENSITIVE="false" #命令大小写不敏感
HYPHEN_INSENSITIVE="true" #命令连字符（包括 _ 和 - ）不敏感
#ENABLE_CORRECTION="true" #命令自动修复
COMPLETION_WAITING_DOTS="true" #Waiting状态
#DISABLE_UNTRACKED_FILES_DIRTY="true" #针对VCS仓库状态检测进行提速，忽略未跟踪文件

## 安装 oh-my-zsh 的路径
export ZSH="$HOME/.oh-my-zsh"

## 插件，默认插件在 $ZSH/plugins/，自定义插件在 $ZSH_CUSTOM/plugins/，更多插件可以参考 https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(
  brew
  copyfile
  copypath
  z
)
## 通过 homebrew 引入的插件
# source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
# source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## 插件设置
#VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
#VI_MODE_SET_CURSOR=true

## 外部配置
source ~/.bash_profile
source $ZSH/oh-my-zsh.sh

## -----------------------------------------------------------------------------

## 关于 compinit 和 zcompdump 文件
# zsh 为了提供自动完成（tab-completion，通过按 Tab 键自动补全命令或参数）能力，
# 通过 compinit 函数对命令进行预加载，并将预加载数据保存在 zcompdump 文件中。
# zcompdump 文件的默认路径在 $ZSH/oh-my-zsh.sh 文件中指定，当然你也可以提前设置
# ZSH_COMPDUMP 这个环境变量修改文件位置。
