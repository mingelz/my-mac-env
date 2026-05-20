# Homebrew

export HOMEBREW_INSTALL_FROM_API=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_BREW_GIT_REMOTE="https://mirror.nju.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirror.nju.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_API_DOMAIN="https://mirror.nju.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirror.nju.edu.cn/homebrew-bottles"
export HOMEBREW_PIP_INDEX_URL="https://mirror.nju.edu.cn/pypi/web/simple"

## ARM 版本的 brew 需要手动指定环境变量
if [[ -z "${HOMEBREW_PREFIX:-}" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

## alias
### 列出安装项目的依赖关系，omz 的 brew 插件没提供类似能力，所以自己加一个
alias bldeps="brew leaves | xargs brew deps --tree --include-build"
