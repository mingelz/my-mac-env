# alias
alias la="ls -AlhG"
#alias vim="mvim -v" #从 MacOS 12 开始系统自带的 vim 已经 +clipboard，不需要额外安装 MacVim 了
alias vimhuge="vim -u NONE -c 'set syntax=no filetype=text'"
alias plz='sudo `fc -nl -1`'
alias cnpm="npm --registry=https://registry.npmmirror.com --cache=$HOME/.npm/.cache/cnpm --disturl=https://npmmirror.com/mirrors/node --userconfig=$HOME/.cnpmrc"
alias j="z"

# 默认 editor
export EDITOR=vim

# 以 <space> 开头的命令不会记录进 .bash_history
export HISTCONTROL=ignorespace

# java, 修改最后的版本号实现切换 JAVA 版本
#export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
#export PATH=$JAVA_HOME/bin:$PATH

# brew
# ARM 系统安装的 brew 需要手动指定环境变量
eval "$(/opt/homebrew/bin/brew shellenv)"
# 提供 bottle 路径，加快安装速度
#export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"

# nvm, 用 brew 安装的 nvm 需要手动添加环境变量，同时使用 cnpm 源以加快速度
export NVM_NODEJS_ORG_MIRROR="https://npmmirror.com/mirrors/node"
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" # for X86
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh" # for ARM


## private 私人配置

# brew, 填入 github 管理后台生成的 token
export HOMEBREW_GITHUB_API_TOKEN=""
