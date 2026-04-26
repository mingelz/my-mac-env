# oh-my-zsh 插件

# --------------------------------------
# 插件前序配置，在启动插件前要配置的环境变量
# --------------------------------------

## 插件配置 - z
### 用习惯 autojump 了，所以继续用 j 做快捷键
ZSHZ_CMD=j

## 插件配置 - vi
#VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
#VI_MODE_SET_CURSOR=true


# --------------------------------------
# 启用插件
# --------------------------------------

## 默认插件在 $ZSH/plugins/
## 自定义插件在 $ZSH_CUSTOM/plugins/
## 更多插件可以参考 https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(
  brew
  z
)


# --------------------------------------
# 插件后序配置，启动插件后要补充执行的命令
# --------------------------------------

## 插件配置 - brew 安装 [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
#ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
#source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## 插件配置 - brew 安装 [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
#source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
