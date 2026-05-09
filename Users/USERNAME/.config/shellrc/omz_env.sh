# oh-my-zsh 基本配置

## 一些设置项
ZSH_DISABLE_COMPFIX="true" #跳过不安全目录的验证
CASE_SENSITIVE="false" #命令大小写不敏感
HYPHEN_INSENSITIVE="true" #命令连字符（包括 _ 和 - ）不敏感
#ENABLE_CORRECTION="true" #命令自动修复
COMPLETION_WAITING_DOTS="true" #Waiting状态
#DISABLE_UNTRACKED_FILES_DIRTY="true" #针对VCS仓库状态检测进行提速，忽略未跟踪文件

## 关于 compinit 和 zcompdump 文件
### zsh 通过 compinit 命令初始化自动补全系统（tab-completion, 按 Tab 自动补全命令或参数），
### 并将缓存保存在 zcompdump 文件中，缓存文件位置通过 ZSH_COMPDUMP 环境变量进行设置。
ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump-${ZSH_VERSION}"
mkdir -p "$(dirname "$ZSH_COMPDUMP")"

## 主题
### 官方主题列表可参考 https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="ys"

## 配置路径
export ZSH="$HOME/.oh-my-zsh"
