# My Mac Environment

## Quick Start

### 前置依赖

- Apple Silicon + macOS（推荐最新版本）
- [Xcode Command Line Tools](https://developer.apple.com/xcode/)：`xcode-select --install`
- [Homebrew](https://brew.sh/)：部分模块依赖 brew 安装的工具

### 安装配置

克隆当前仓库，执行：

```bash
./install.sh --list              # 列出所有模块
./install.sh                     # 安装全部配置
./install.sh shell git vim       # 选择性安装指定模块配置
```

> 或参考 [Mac 环境安装配置一条龙](./setup.md) 自行配置

## Tree

```
/ (Root Directory)
|-- assets/
|-- etc/
|-- opt/
|-- Users/USERNAME/ ($HOME)
|   |-- .agents/
|   |-- .config/
|   |-- .local/
|   |-- .ssh/
|   |-- Library/
|   |-- .bash_profile
|   |-- .zshrc
|-- install.sh
|-- setup.md
```
