# path 层 - PATH 构建（通用 + 各语言与工具）
#
# 加载入口：.zprofile（zsh login）、.bash_profile（bash login）
#
# 为什么 PATH 归 path 层而不是 env 层：
# macOS 的 /etc/zprofile 会执行 path_helper 把系统路径重排到前面，
# 写在 .zshenv 里的 PATH 顺序在 login shell 中必然被打乱。
# ~/.zprofile 在 path_helper 之后执行，因此是构建 PATH 的正确位置。
#
# 判重统一使用 POSIX 的 `case ":$PATH:" in` 而非 [[ ]]，保证 bash/zsh/sh 下均可用。
# 两侧补冒号是必须的，否则位于 PATH 首尾的条目匹配不到，会被重复添加。
#
# 各领域的环境变量见 env.sh，交互功能（alias/函数）见 rc.sh


# ------------------------------------------------------------------------------
# 通用
# ------------------------------------------------------------------------------

## 添加用户 bin 路径
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac


# ------------------------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------------------------

## ARM 版本的 brew 需要手动初始化，通过 brew shellenv 设置 HOMEBREW_PREFIX / PATH / MANPATH / INFOPATH
if ! command -v brew >/dev/null 2>&1 && [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi


# ------------------------------------------------------------------------------
# Java & Maven
# ------------------------------------------------------------------------------

## 设置 JAVA_HOME
## 按优先级依次尝试，使用第一个命中的版本（JDK 8 必须写 1.8，java_home 不认 `-v 8`）
for _jdk_ver in 25 21 17 11 1.8; do
  # 使用 -F failfast，避免 -v 过滤回退到非目标版本
  if /usr/libexec/java_home -v "$_jdk_ver" -F >/dev/null 2>&1; then
    export JAVA_HOME="$(/usr/libexec/java_home -v "$_jdk_ver")"
    break
  fi
done
unset _jdk_ver

## 将命中的 JAVA_HOME 添加进 PATH
if [ -n "$JAVA_HOME" ]; then
  case ":$PATH:" in
    *":$JAVA_HOME/bin:"*) ;;
    *) export PATH="$JAVA_HOME/bin:$PATH" ;;
  esac
fi


# ------------------------------------------------------------------------------
# Ruby & Gem
# ------------------------------------------------------------------------------

## 设置 gem 安装目录
## 在 .gemrc 中通过设置 --user-install 将安装目录调整到用户目录，需要在此设置 PATH 保证 bin 文件可以被覆盖到
if command -v ruby >/dev/null 2>&1 && command -v gem >/dev/null 2>&1; then
  _gem_bin="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin"
  case ":$PATH:" in
    *":$_gem_bin:"*) ;;
    *) export PATH="$_gem_bin:$PATH" ;;
  esac
  unset _gem_bin
fi
