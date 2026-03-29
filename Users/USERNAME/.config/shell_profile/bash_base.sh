# 系统内置命令配置

## alias
### 提供列表形式、查看所有文件的 ls
alias la="ls -AlhG"
### 让 vim 命令使用 macvim，支持高级特性
#alias vim="mvim -v" #从 macOS 12 开始系统自带的 vim 已经 +clipboard，不需要额外安装 MacVim 了
### 不带任何配置启动 vim 命令，适合打开大文件
alias vimhuge="vim -u NONE -c 'set syntax=no filetype=text'"
### 使用 sudo 命令执行上一条命令
alias please='sudo `fc -nl -1`' #注意因为命令中有反引号，所以外边只能使用单引号包裹，而不能用双引号

## settings
export EDITOR=vim # 默认 editor
export HISTCONTROL=ignorespace # 以 <space> 开头的命令不记录进 .bash_history
