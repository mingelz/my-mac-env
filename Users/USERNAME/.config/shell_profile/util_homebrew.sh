# Homebrew

# 通过修改为国内镜像源提高国内访问速度
# * 阿里云源：https://developer.aliyun.com/mirror/homebrew
# * TUNA 源：https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
# * USTC 源：https://mirrors.ustc.edu.cn/help/brew.git.html

export HOMEBREW_API_DOMAIN="https://mirrors.aliyun.com/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/homebrew-core.git"
export HOMEBREW_INSTALL_FROM_API=1
export HOMEBREW_NO_ENV_HINTS=1

## ARM 版本的 brew 需要手动指定环境变量
eval "$(/opt/homebrew/bin/brew shellenv)"
