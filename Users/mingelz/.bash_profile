# alias
alias la="ls -AlhG"
alias vim="mvim -v"
alias vimhuge="vim -u NONE -c 'set syntax=no filetype=text'"
alias please='sudo `fc -nl -1`'
alias dnpm="npm --registry=https://registry.npm.taobao.org --cache=$HOME/.npm/.cache/cnpm --disturl=https://npm.taobao.org/dist --userconfig=$HOME/.cnpmrc"
alias cncu="ncu --registry=https://registry.npm.taobao.org"

# 默认 editor
export EDITOR=vim

# 以 <space> 开头的命令不会记录进 .bash_history
export HISTCONTROL=ignorespace

# java, 修改最后的版本号实现切换 JAVA_HOME
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
#export PATH=$JAVA_HOME/bin:$PATH

# nvm
export NVM_NODEJS_ORG_MIRROR="https://npm.taobao.org/dist"
export NVM_DIR=~/.nvm
source "/usr/local/opt/nvm/nvm.sh"

# autojump
[[ -s /usr/local/etc/profile.d/autojump.sh ]] && . /usr/local/etc/profile.d/autojump.sh

# brew, 填入 github 管理后台生成的 token
export HOMEBREW_GITHUB_API_TOKEN=""
