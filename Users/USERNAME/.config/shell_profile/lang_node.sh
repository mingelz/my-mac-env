# Node.js & npm & nvm/fnm

# 通过修改为国内镜像源提高国内访问速度
# * npmmirror 源：https://npmmirror.com/
# * 阿里云源：https://developer.aliyun.com/mirror/NPM, https://developer.aliyun.com/mirror/nodejs-release
# * TUNA 源：https://mirrors.tuna.tsinghua.edu.cn/help/nodejs-release/
# * USTC 源：https://mirrors.ustc.edu.cn/help/npm.html, https://mirrors.ustc.edu.cn/help/node.html

## nvm 我现在改用 fnm 了，效率更高
#export NVM_NODEJS_ORG_MIRROR="https://npmmirror.com/mirrors/node"
#export NVM_DIR="$HOME/.nvm"
#[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

## fnm
export FNM_NODE_DIST_MIRROR="https://npmmirror.com/mirrors/node"
#export FNM_DIR="$HOME/.fnm" # 默认位置 .local/share/fnm 挺好的，无需修改
### 初始化 fnm，其中 --use-on-cd 表示使用 fnm 切换目录时自动切换 node
### 此配置 可能与 zsh 冲突，如果配置不好可能会影响 cd 命令的自动完成功能，此时可以把 --use-on-cd 参数去掉
eval "$(fnm env --use-on-cd --shell zsh)"

## alias
alias cnpm="npm --registry=https://registry.npmmirror.com --disturl=https://npmmirror.com/mirrors/node"
alias cncu="ncu --registry=https://registry.npmmirror.com" # ncu 命令由 [npm-check-updates](https://www.npmjs.com/package/npm-check-updates) 提供
