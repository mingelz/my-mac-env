### base
### ----------------------------------------------------------------------------

## alias
alias la="ls -AlhG"
alias please='sudo `fc -nl -1`' #注意因为命令中有反引号，所以外边只能使用单引号包裹，而不能用双引号
#alias vim="mvim -v" #从 macOS 12 开始系统自带的 vim 已经 +clipboard，不需要额外安装 MacVim 了
alias vimhuge="vim -u NONE -c 'set syntax=no filetype=text'"

## settings
export EDITOR=vim # 默认 editor
export HISTCONTROL=ignorespace # 以 <space> 开头的命令不记录进 .bash_history


### function
### ----------------------------------------------------------------------------

# grep 时根据窗口宽度自动截断而不换行，在查询大量应用日志时会有帮助
function sgrep { tput rmam; command grep "$@"; tput smam; }


### software
### ----------------------------------------------------------------------------

## Oh My Zsh
alias j="z" #虽然换用 oh-my-zsh 的 z 插件，但还是习惯 autojump 的 j 命令

## Homebrew
# ARM 版本的 brew 需要手动指定环境变量
eval "$(/opt/homebrew/bin/brew shellenv)"
# 通过 TUNA 镜像安装和更新 brew 以提高国内访问速度，见 https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
export HOMEBREW_INSTALL_FROM_API=1
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
alias bldeps="brew leaves | xargs brew deps --include-build --tree" # 列出安装项目的依赖关系，omz的插件中没提供，只好自己加一个

## Java
#export JAVA_HOME=$(/usr/libexec/java_home -v 1.8) # 当安装了多个 Java 版本时，可以通过修改最后的版本号实现切换版本
#export PATH=$JAVA_HOME/bin:$PATH

## Node.js & npm & nvm
# 通过 brew 安装的 nvm 需要手动添加环境变量
export NVM_NODEJS_ORG_MIRROR="https://npmmirror.com/mirrors/node"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
# 使用 cnpm 源提高 npm 包的查询和下载速度
alias cnpm="npm --registry=https://registry.npmmirror.com --cache=$HOME/.npm/.cache/cnpm --disturl=https://npmmirror.com/mirrors/node --userconfig=$HOME/.cnpmrc"
alias cncu="ncu --registry=https://registry.npmmirror.com" # ncu 命令由 [npm-check-updates](https://www.npmjs.com/package/npm-check-updates) 提供

## Ruby & Gem
# 在 .gemrc 中通过设置 --user-install 将安装目录调整到用户目录，需要在此设置 PATH 保证 bin 文件可以被覆盖到
#if which ruby >/dev/null && which gem >/dev/null; then
#    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
#fi

## Python & pip
# 通过 brew 安装 pyenv 后需要添加相应环境变量
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
# 另：如果需要针对 pip 安装提速，请复制 ~/.config/pip/pip.conf 文件


### private
### ----------------------------------------------------------------------------

## Homebrew
# 如果使用官方源，建议填入 github 管理后台生成的 token，确保 brew 能够正常更新
export HOMEBREW_GITHUB_API_TOKEN=""
