# alias
alias la="ls -alhG"
alias vim=~/Applications/MacVim.app/Contents/MacOS/Vim # MacVim 通过 Cask 安装，这个路径是通过软链接过去的

# editor
export EDITOR=vim

# 以 <space> 开头的命令不会记录进 .bash_history
export HISTCONTROL=ignorespace

# nvm
export NVM_NODEJS_ORG_MIRROR="https://npm.taobao.org/dist"
export NVM_DIR=~/.nvm
source "/usr/local/opt/nvm/nvm.sh"

# java
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
#export PATH=$JAVA_HOME/bin:$PATH
