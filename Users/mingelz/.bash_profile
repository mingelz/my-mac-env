# alias
alias la="ls -alhG"
alias vim="mvim -v"

# editor
export EDITOR=vim

# 以 <space> 开头的命令不会记录进 .bash_history
export HISTCONTROL=ignorespace

# nvm
export NVM_NODEJS_ORG_MIRROR="https://npm.taobao.org/dist"
export NVM_DIR=~/.nvm
source "/usr/local/opt/nvm/nvm.sh"

# mybin path
export PATH=~/.mybin:$PATH

# java, 修改最后的版本号实现切换 JAVA_HOME
export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
#export PATH=$JAVA_HOME/bin:$PATH

# brew, 填入 github 管理后台生成的 token
export HOMEBREW_GITHUB_API_TOKEN=""
