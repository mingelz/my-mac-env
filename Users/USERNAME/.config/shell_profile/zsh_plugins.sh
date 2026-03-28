# ohmyzsh 插件

## 插件配置 - brew
### 列出安装项目的依赖关系，插件中没提供，只好自己加一个
alias bldeps="brew leaves | xargs brew deps --tree --include-build"

## 插件配置 - z
ZSHZ_CMD=j

## 插件配置 - vi
#VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
#VI_MODE_SET_CURSOR=true

## 启用的插件
## 默认插件在 $ZSH/plugins/
## 自定义插件在 $ZSH_CUSTOM/plugins/
## 更多插件可以参考 https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(
  brew
  z
)

## 插件配置 - brew 安装 [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
#ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
#source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## 插件配置 - brew 安装 [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
#source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
