# oh-my-zsh 基本配置

## 一些设置项
ZSH_DISABLE_COMPFIX="true" #跳过不安全目录的验证
CASE_SENSITIVE="false" #命令大小写不敏感
HYPHEN_INSENSITIVE="true" #命令连字符（包括 _ 和 - ）不敏感
#ENABLE_CORRECTION="true" #命令自动修复
COMPLETION_WAITING_DOTS="true" #Waiting状态
#DISABLE_UNTRACKED_FILES_DIRTY="true" #针对VCS仓库状态检测进行提速，忽略未跟踪文件

## 关于 compinit 和 zcompdump 文件
### zsh 为了提供自动完成（tab-completion，通过按 Tab 键自动补全命令或参数）能力，
### 通过 compinit 函数对命令进行预加载，并将预加载数据保存在 zcompdump 文件中。
### zcompdump 文件的默认路径在 $ZSH/oh-my-zsh.sh 文件中指定，当然你也可以提前设置
### ZSH_COMPDUMP 这个环境变量修改文件位置。
#ZSH_COMPDUMP="$HOME/.zcompdump" #指定compinit的缓存地址
#autoload -Uz compinit && compinit -C #显式初始化补全系统，omz 会自动初始化，无需额外配置

## 主题
ZSH_THEME="ys" #omz皮肤，所有主题可参考 https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

## 配置路径
export ZSH="$HOME/.oh-my-zsh"
