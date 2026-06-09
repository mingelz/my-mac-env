# Node.js & npm & nvm/fnm

## npm XDG 规范：让 npm 读取 ~/.config/npm/npmrc，而不是 ~/.npmrc
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"

## nvm (目前我改用 fnm 了)
#export NVM_NODEJS_ORG_MIRROR="https://npmmirror.com/mirrors/node"
#export NVM_DIR="$HOME/.local/share/nvm"
#[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"

## fnm
export FNM_NODE_DIST_MIRROR="https://npmmirror.com/mirrors/node"
export FNM_DIR="$HOME/.local/share/fnm"
### 初始化 fnm
if command -v fnm &>/dev/null; then
    # 参数 --use-on-cd 表示切换目录时识别项目依赖的 node 版本并自动切换
    eval "$(fnm env --use-on-cd --shell zsh)"
fi

## alias
alias cnpm="npm --registry=https://registry.npmmirror.com"
### ncu 命令由 [npm-check-updates](https://www.npmjs.com/package/npm-check-updates) 提供
alias cncu="ncu --registry=https://registry.npmmirror.com"
