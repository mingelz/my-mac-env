# Homebrew

# 通过修改为国内镜像源提高国内访问速度
# * 阿里云源：https://developer.aliyun.com/mirror/homebrew
# * TUNA 源：https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
# * USTC 源：https://mirrors.ustc.edu.cn/help/brew.git.html

export HOMEBREW_INSTALL_FROM_API=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

## ARM 版本的 brew 需要手动指定环境变量
eval "$(/opt/homebrew/bin/brew shellenv)"

## alias
### 列出安装项目的依赖关系，omz 的 brew 插件没提供类似能力，所以自己加一个
alias bldeps="brew leaves | xargs brew deps --tree --include-build"
