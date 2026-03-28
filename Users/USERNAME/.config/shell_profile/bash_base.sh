# 系统内置命令配置

## alias
alias la="ls -AlhG"
#alias vim="mvim -v" #从 macOS 12 开始系统自带的 vim 已经 +clipboard，不需要额外安装 MacVim 了
alias vimhuge="vim -u NONE -c 'set syntax=no filetype=text'"
alias please='sudo `fc -nl -1`' #注意因为命令中有反引号，所以外边只能使用单引号包裹，而不能用双引号

## settings
export EDITOR=vim # 默认 editor
export HISTCONTROL=ignorespace # 以 <space> 开头的命令不记录进 .bash_history
