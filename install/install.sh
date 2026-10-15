#!/bin/bash
#
# my-mac-env 自动安装脚本，通过 symlink 将配置文件链接到对应位置
#
# 用法:
#   install/install.sh all          # 安装全部模块
#   install/install.sh shell git    # 只安装指定模块
#   install/install.sh --list       # 列出所有可用模块
#   install/install.sh --status     # 查看当前安装状态
#   install/install.sh --help       # 显示帮助信息
#

set -e

# ============================================================
# 常量定义
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DOTFILES_DIR="$ROOT_DIR/Users/USERNAME"
HOME_DIR="$HOME"
# 清单哈希门控的状态记录位置（XDG state 目录）
STATE_DIR="$HOME/.local/state/my-mac-env"

# 可用模块清单（注册表）在 install/modules.txt，由 _load_modules 按需加载：
# --list / --status / 模块分发都以它为唯一来源。
# 帮助类命令（--help、无参数）不依赖注册表，注册表缺失不影响查看用法。

# ============================================================
# 工具函数
# ============================================================

# 输出彩色日志
_info()  { printf "\033[0;34m[INFO]\033[0m  %s\n" "$*"; }
_ok()    { printf "\033[0;32m[OK]\033[0m    %s\n" "$*"; }
_warn()  { printf "\033[0;33m[WARN]\033[0m  %s\n" "$*"; }
_error() { printf "\033[0;31m[ERROR]\033[0m %s\n" "$*"; }

# 检查 symlink 状态，返回: ok / missing / wrong / conflict / not_set
_check_link() {
    local src="$1"
    local dst="$2"

    if [ ! -e "$src" ]; then
        echo "missing"  # 源文件不存在
        return
    fi

    if [ -L "$dst" ]; then
        if [ "$(readlink "$dst")" = "$src" ]; then
            echo "ok"
        else
            echo "wrong"
        fi
    elif [ -e "$dst" ]; then
        echo "conflict"  # 是普通文件/目录
    else
        echo "not_set"
    fi
}

# 创建 symlink，带冲突检测与备份
# 用法: _link <源文件> <目标位置>
_link() {
    local src="$1"
    local dst="$2"

    # 源文件不存在
    if [ ! -e "$src" ]; then
        _warn "源文件不存在，跳过: $src"
        return
    fi

    # 确保目标父目录存在
    mkdir -p "$(dirname "$dst")"

    # 目标已存在
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        # 已经是指向正确位置的 symlink，跳过
        if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
            _ok "已链接，跳过: $dst"
            return
        fi

        # 已经是 symlink 但指向别处，直接替换
        if [ -L "$dst" ]; then
            _warn "替换已有链接: $dst (旧目标: $(readlink "$dst"))"
            ln -sf "$src" "$dst"
            _ok "已链接: $dst -> $src"
            return
        fi

        # 是普通文件/目录，备份到统一目录后替换
        local bak_dir="$HOME_DIR/.config/_bak"
        local bak="$bak_dir$(echo "$dst" | sed "s|^$HOME_DIR||").$(date +%Y%m%d%H%M%S)"
        mkdir -p "$(dirname "$bak")"
        _warn "目标已存在且非 symlink，备份为: $bak"
        mv "$dst" "$bak"
    fi

    ln -sf "$src" "$dst"
    _ok "已链接: $dst -> $src"
}

# ============================================================
# 清单读取（install/*.txt）与哈希门控
# ============================================================

# 逐行读取清单，自动跳过空行和 # 开头的注释行，再调用处理函数
# 行内字段用 | 分隔（不用空格，因为仓库里存在含空格的路径），各字段自动去除首尾空白
# 用法: _each_manifest <清单文件> <处理函数>
#   处理函数在当前 shell 中被调用，按 $1 $2 ... 收到该行的各字段，
#   因此可以直接往调用方的数组里追加，例如：
#     local -a pkgs=()
#     _each_manifest "$f" _append_pkg     # _append_pkg() { pkgs+=("$1"); }
_each_manifest() {
    local manifest="$1" handler="$2"
    if [ ! -f "$manifest" ]; then
        _warn "清单文件不存在: $manifest"
        return 0
    fi
    local line i f
    local -a fields
    while IFS= read -r line || [ -n "$line" ]; do
        # 去掉行首空白后判断是否为空行或注释行
        line="${line#"${line%%[![:space:]]*}"}"
        case "$line" in ''|'#'*) continue ;; esac
        # 按 | 切分字段并逐个去除首尾空白
        IFS='|' read -r -a fields <<< "$line"
        for i in "${!fields[@]}"; do
            f="${fields[$i]}"
            f="${f#"${f%%[![:space:]]*}"}"
            f="${f%"${f##*[![:space:]]}"}"
            fields[i]="$f"
        done
        "$handler" "${fields[@]}"
    done < "$manifest"
}

# 内容哈希门控：清单内容没变化就跳过安装动作，避免每次执行都重复联网核对
# 记录只在安装命令成功之后写入（见 _onchange_done），失败则下次自动重试
# 用法: if _onchange_pending <名称> <清单文件>; then <安装命令> && _onchange_done <名称> <清单文件>; fi
_onchange_pending() {
    local stamp="$STATE_DIR/$1.sha256"
    local current
    current=$(_manifest_hash "$2")
    if [ -f "$stamp" ] && [ "$(cat "$stamp")" = "$current" ]; then
        return 1
    fi
    return 0
}

_onchange_done() {
    mkdir -p "$STATE_DIR"
    _manifest_hash "$2" > "$STATE_DIR/$1.sha256"
}

_manifest_hash() {
    shasum -a 256 "$1" | cut -d' ' -f1
}

# ============================================================
# 模块注册表（install/modules.txt）
# ============================================================

MODULE_NAMES=()
MODULE_DESCS=()

# 把注册表的行字段收进数组（字段: 模块名 | 说明）
_append_module() { MODULE_NAMES+=("$1"); MODULE_DESCS+=("${2:-}"); }

# 加载模块注册表。文件缺失或内容为空属于配置损坏，直接报错退出（必配项不留回落）
_load_modules() {
    MODULE_NAMES=()
    MODULE_DESCS=()
    _each_manifest "$SCRIPT_DIR/modules.txt" _append_module
    if [ ${#MODULE_NAMES[@]} -eq 0 ]; then
        _error "模块注册表为空或不存在: $SCRIPT_DIR/modules.txt"
        exit 1
    fi
}

# $1 是否为注册表中的模块
_is_registered_module() {
    local m
    for m in "${MODULE_NAMES[@]}"; do
        [ "$m" = "$1" ] && return 0
    done
    return 1
}

# ============================================================
# 安装模块
# ============================================================

install_brew() {
    _info "安装模块: brew"
    local brewfile="$SCRIPT_DIR/Brewfile"
    if [ ! -f "$brewfile" ]; then
        _warn "Brewfile 不存在: $brewfile"
        return
    fi
    if ! command -v brew &>/dev/null; then
        _warn "brew 未安装，跳过。请先安装 Homebrew: https://brew.sh/"
        return
    fi
    _info "执行 brew bundle..."
    brew bundle --file="$brewfile"
    _ok "brew bundle 完成"

    # maven 使用 ignore-dependencies 安装，pin 住避免 brew upgrade 时拉入 openjdk
    # 后续如果需要更新 maven 版本，请执行：brew unpin maven && brew install maven --ignore-dependencies && brew pin maven
    if brew list maven &>/dev/null && ! brew list --pinned 2>/dev/null | grep -q "^maven$"; then
        brew pin maven
        _ok "已 pin: maven (避免 upgrade 时安装 openjdk 依赖)"
    fi
}

status_brew() {
    # 已安装包数比注册表说明更有信息量，动态取
    if command -v brew &>/dev/null; then
        local brew_count
        brew_count=$(brew list 2>/dev/null | wc -l | tr -d ' ')
        _status_line "brew" "ok" "$brew_count 个已安装包"
    else
        _status_line "brew" "not_set" "Homebrew 未安装"
    fi
}

install_shell() {
    _info "安装模块: shell"

    # oh-my-zsh 本体，.zshrc 依赖它（Brewfile 无法执行任意命令，所以放在这里）
    # RUNZSH=no: 避免装完自动开 zsh 卡住流程；KEEP_ZSHRC=yes: 防止覆盖已有的 .zshrc
    if [ -d "$HOME_DIR/.oh-my-zsh" ]; then
        _ok "oh-my-zsh 已安装，跳过"
    else
        _info "安装 oh-my-zsh..."
        # 先把安装脚本下载到变量再执行：若直接写 sh -c "$(curl ...)"，
        # curl 失败时命令替换得到空串，sh -c "" 会返回 0，从而误报安装成功。
        # 下载成功但响应体为空是同一种坑，一并拦下
        local omz_installer
        if ! omz_installer=$(curl -fsSL https://install.ohmyz.sh/); then
            _warn "oh-my-zsh 安装脚本下载失败，请检查网络后重试（参考 setup.md 的国内镜像说明）"
        elif [ -z "$omz_installer" ]; then
            _warn "oh-my-zsh 安装脚本下载为空，请检查网络后重试"
        elif RUNZSH=no KEEP_ZSHRC=yes sh -c "$omz_installer"; then
            _ok "oh-my-zsh 已安装"
        else
            _warn "oh-my-zsh 安装脚本执行失败"
        fi
    fi

    # env / path / rc 三层入口，各层定位见 .config/shell/README.md
    _link "$DOTFILES_DIR/.zshenv" "$HOME_DIR/.zshenv"
    _link "$DOTFILES_DIR/.zprofile" "$HOME_DIR/.zprofile"
    _link "$DOTFILES_DIR/.zshrc" "$HOME_DIR/.zshrc"
    _link "$DOTFILES_DIR/.bash_profile" "$HOME_DIR/.bash_profile"
    _link "$DOTFILES_DIR/.bashrc" "$HOME_DIR/.bashrc"
    _link "$DOTFILES_DIR/.config/shell" "$HOME_DIR/.config/shell"

    # 预建历史记录与补全缓存目录（运行时自愈由 rc.sh / rc_omz.pre.zsh 负责）
    mkdir -p "$HOME_DIR/.local/state/zsh" \
             "$HOME_DIR/.local/state/bash" \
             "$HOME_DIR/.local/state/less" \
             "$HOME_DIR/.cache/zsh"
}

# ---- 各模块状态检查（--status 用）----
# 约定: $1 是注册表里该模块的说明。静态模块直接转发；
# 动态模块（node / idea / vscode / brew）自行计算更有信息量的描述，忽略 $1。

status_shell() {
    _status_line "shell" "$(_check_link "$DOTFILES_DIR/.zshrc" "$HOME_DIR/.zshrc")" "$1"
}

install_bin() {
    _info "安装模块: bin"
    # ~/.local/bin 是与其他工具共用的目录，因此逐个链接文件而非链接整个目录
    # 该目录由 .config/shell/path.sh 加入 PATH
    mkdir -p "$HOME_DIR/.local/bin"
    local f
    for f in "$DOTFILES_DIR/.local/bin"/*; do
        [ -f "$f" ] || continue
        _link "$f" "$HOME_DIR/.local/bin/$(basename "$f")"
    done
}

status_bin() {
    # 逐个链接的目录没法整体校验，抽查 lg 作为代表
    _status_line "bin" "$(_check_link "$DOTFILES_DIR/.local/bin/lg" "$HOME_DIR/.local/bin/lg")" "$1"
}

install_ssh() {
    _info "安装模块: ssh"
    mkdir -p "$HOME_DIR/.ssh"
    chmod 700 "$HOME_DIR/.ssh"
    # SSH config 包含因人而异的 Host 配置，使用复制而非链接
    local ssh_config="$HOME_DIR/.ssh/config"
    if [ -f "$ssh_config" ]; then
        _ok "已存在，跳过: $ssh_config"
    else
        cp "$DOTFILES_DIR/.ssh/config" "$ssh_config"
        _warn "已复制: $ssh_config (请根据实际情况修改 Host 和 IdentityFile)"
    fi
}

status_ssh() {
    if [ -f "$HOME_DIR/.ssh/config" ]; then
        _status_line "ssh" "ok" "$1"
    else
        _status_line "ssh" "not_set" "$1"
    fi
}

install_git() {
    _info "安装模块: git"
    _link "$DOTFILES_DIR/.config/git" "$HOME_DIR/.config/git"

    # 私人配置（user.name, user.email 等）需要手动创建
    local private_config="$HOME_DIR/.config/git/private_config"
    if [ ! -f "$private_config" ]; then
        cp "$DOTFILES_DIR/.config/git/private_config.example" "$private_config"
        _warn "已创建: $private_config (请修改其中的 user.name 和 user.email)"
    fi
}

status_git() {
    _status_line "git" "$(_check_link "$DOTFILES_DIR/.config/git" "$HOME_DIR/.config/git")" "$1"
}

install_vim() {
    _info "安装模块: vim"
    _link "$DOTFILES_DIR/.config/vim" "$HOME_DIR/.config/vim"
}

status_vim() {
    _status_line "vim" "$(_check_link "$DOTFILES_DIR/.config/vim" "$HOME_DIR/.config/vim")" "$1"
}

# 把 npm-packages.txt 的每行收进数组（每行一个包名）
_append_npm_pkg() { npm_pkgs+=("$1"); }

install_node() {
    _info "安装模块: node"
    _link "$DOTFILES_DIR/.config/npm" "$HOME_DIR/.config/npm"

    if ! command -v fnm &>/dev/null; then
        _warn "fnm 未安装，跳过 Node LTS 和全局包安装。请先通过 brew 安装 fnm"
        return
    fi

    eval "$(fnm env)"

    _info "检测到 fnm，安装 Node LTS..."
    fnm install --lts

    # 获取刚安装的 LTS 版本并设为 default
    local lts_version
    lts_version=$(fnm current 2>/dev/null || true)
    if [ -n "$lts_version" ] && [ "$lts_version" != "none" ]; then
        fnm default "$lts_version"
        _ok "Node ($lts_version) 已安装并设为默认"
    else
        _ok "Node LTS 已安装（请手动执行 fnm default <version> 设置默认版本）"
    fi

    # 安装全局 npm 包（清单与脚本同目录，格式说明在该文件头部）
    local pkg_file="$SCRIPT_DIR/npm-packages.txt"
    local -a npm_pkgs=()
    _each_manifest "$pkg_file" _append_npm_pkg

    if [ ${#npm_pkgs[@]} -eq 0 ]; then
        _warn "清单里没有可安装的全局包: $pkg_file"
    elif _onchange_pending "npm-global-packages" "$pkg_file"; then
        _info "安装全局 npm 包: ${npm_pkgs[*]}"
        if npm install -g "${npm_pkgs[@]}"; then
            _onchange_done "npm-global-packages" "$pkg_file"
            _ok "全局 npm 包已安装"
        else
            _warn "npm install -g 执行失败，下次运行时会重试"
        fi
    else
        _ok "npm 全局包清单未变化，跳过（改动 $pkg_file 后会自动重装）"
    fi
}

status_node() {
    # fnm 版本比注册表说明更有信息量，动态取
    local st
    st=$(_check_link "$DOTFILES_DIR/.config/npm" "$HOME_DIR/.config/npm")
    _status_line "node" "$st" "fnm: $(command -v fnm &>/dev/null && fnm current 2>/dev/null || echo '未安装')"
}

install_python() {
    _info "安装模块: python"
    _link "$DOTFILES_DIR/.config/pip" "$HOME_DIR/.config/pip"
    _link "$DOTFILES_DIR/.config/uv" "$HOME_DIR/.config/uv"

    if command -v uv &>/dev/null; then
        _info "检测到 uv，安装最新版 Python..."
        # --default: 同时把该版本设为默认，并生成 python / python3 可执行入口
        uv python install --default
        _ok "Python 已通过 uv 安装"
    else
        _warn "uv 未安装，跳过 Python 安装。请先通过 brew 安装 uv"
    fi
}

status_python() {
    local pip_st uv_st
    pip_st=$(_check_link "$DOTFILES_DIR/.config/pip" "$HOME_DIR/.config/pip")
    uv_st=$(_check_link "$DOTFILES_DIR/.config/uv" "$HOME_DIR/.config/uv")
    # 两个目录都落位时沿用注册表说明；否则把各自状态摊开，便于看出是哪一个没就位
    if [ "$pip_st" = "ok" ] && [ "$uv_st" = "ok" ]; then
        _status_line "python" "ok" "$1"
    elif [ "$pip_st" != "ok" ]; then
        _status_line "python" "$pip_st" "pip: $pip_st, uv: $uv_st"
    else
        _status_line "python" "$uv_st" "pip: $pip_st, uv: $uv_st"
    fi
}

install_ruby() {
    _info "安装模块: ruby"
    _link "$DOTFILES_DIR/.config/gem/gemrc" "$HOME_DIR/.config/gem/gemrc"
}

status_ruby() {
    _status_line "ruby" "$(_check_link "$DOTFILES_DIR/.config/gem/gemrc" "$HOME_DIR/.config/gem/gemrc")" "$1"
}

install_appdir() {
    _info "安装模块: appdir"
    # ~/Applications 是 Brewfile 里 cask_args appdir 指定的安装位置，但 brew 要到装第一个 cask
    # 时才会创建它，这里先建好，让后续动作有个确定的落点
    mkdir -p "$HOME_DIR/Applications"

    # .localized 是 Finder 的标记文件：只看存在与否、不读内容，有它 Finder 才按系统语言显示
    # 目录名（中文系统下显示「应用程序」）。
    local localized="$HOME_DIR/Applications/.localized"
    if [ -e "$localized" ]; then
        _ok "已存在，跳过: $localized"
    else
        cp "$DOTFILES_DIR/Applications/.localized" "$localized"
        _ok "已创建: $localized"
    fi
}

status_appdir() {
    if [ -d "$HOME_DIR/Applications" ] && [ -e "$HOME_DIR/Applications/.localized" ]; then
        _status_line "appdir" "ok" "$1"
    else
        _status_line "appdir" "not_set" "$1"
    fi
}

install_karabiner() {
    _info "安装模块: karabiner"
    # Karabiner 会写回配置文件（删旧写新），symlink 会被破坏，因此使用复制
    local karabiner_dst="$HOME_DIR/.config/karabiner/karabiner.json"
    mkdir -p "$(dirname "$karabiner_dst")"
    if [ -f "$karabiner_dst" ]; then
        _ok "已存在，跳过: $karabiner_dst"
    else
        cp "$DOTFILES_DIR/.config/karabiner/karabiner.json" "$karabiner_dst"
        _ok "已复制: $karabiner_dst"
    fi
    _warn "Karabiner 会写回配置，如有更新请手动同步回仓库"
}

status_karabiner() {
    if [ -f "$HOME_DIR/.config/karabiner/karabiner.json" ]; then
        _status_line "karabiner" "ok" "$1"
    else
        _status_line "karabiner" "not_set" "$1"
    fi
}

install_ghostty() {
    _info "安装模块: ghostty"
    _link "$DOTFILES_DIR/.config/ghostty" "$HOME_DIR/.config/ghostty"
}

status_ghostty() {
    _status_line "ghostty" "$(_check_link "$DOTFILES_DIR/.config/ghostty" "$HOME_DIR/.config/ghostty")" "$1"
}

install_raycast() {
    _info "安装模块: raycast"
    local providers_dst="$HOME_DIR/.config/raycast/ai/providers.yaml"
    mkdir -p "$(dirname "$providers_dst")"
    if [ -f "$providers_dst" ]; then
        _ok "已存在，跳过: $providers_dst"
    else
        cp "$DOTFILES_DIR/.config/raycast/ai/providers.yaml" "$providers_dst"
        _ok "已复制: $providers_dst"
    fi
}

status_raycast() {
    if [ -f "$HOME_DIR/.config/raycast/ai/providers.yaml" ]; then
        _status_line "raycast" "ok" "$1"
    else
        _status_line "raycast" "not_set" "$1"
    fi
}

install_vscode() {
    _info "安装模块: vscode"
    local vscode_src="$DOTFILES_DIR/Library/Application Support/Code/User"
    local vscode_dst="$HOME_DIR/Library/Application Support/Code/User"
    mkdir -p "$vscode_dst"
    local file dst
    for file in settings.json keybindings.json; do
        dst="$vscode_dst/$file"
        if [ -f "$dst" ]; then
            _ok "已存在，跳过: $dst"
        else
            cp "$vscode_src/$file" "$dst"
            _ok "已复制: $dst"
        fi
    done

    # key-repeating（长按触发按键重复）是 defaults 域设置，Brewfile 表达不了，只能放在这里
    # VSCodeVim 等插件依赖它: https://github.com/VSCodeVim/Vim#mac
    local vscode_repeat
    vscode_repeat="$(defaults read com.microsoft.VSCode ApplePressAndHoldEnabled 2>/dev/null || true)"
    if [ "$vscode_repeat" = "0" ]; then
        _ok "已开启 key-repeating: com.microsoft.VSCode ApplePressAndHoldEnabled"
    else
        defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
        _ok "已开启 key-repeating: com.microsoft.VSCode ApplePressAndHoldEnabled（重启 VSCode 生效）"
    fi
}

status_vscode() {
    # 已落盘文件数比注册表说明更有信息量，动态取
    local vscode_src_dir="$DOTFILES_DIR/Library/Application Support/Code/User"
    local vscode_dst_dir="$HOME_DIR/Library/Application Support/Code/User"
    local file vscode_total=0 vscode_ok=0
    for file in settings.json keybindings.json; do
        [ -f "$vscode_src_dir/$file" ] || continue
        vscode_total=$((vscode_total + 1))
        if [ -f "$vscode_dst_dir/$file" ]; then
            vscode_ok=$((vscode_ok + 1))
        fi
    done
    if [ "$vscode_total" -eq "$vscode_ok" ] && [ "$vscode_total" -gt 0 ]; then
        _status_line "vscode" "ok" "$vscode_ok/$vscode_total files"
    elif [ "$vscode_ok" -gt 0 ]; then
        _status_line "vscode" "wrong" "$vscode_ok/$vscode_total files"
    else
        _status_line "vscode" "not_set" "settings.json + keybindings.json"
    fi
}

# 把 idea-plugins.txt 的行字段收进数组（字段: xmlId | 插件目录名 | 说明）
# 目录名由插件自己定义，与 xmlId 不一定一致（如 MavenRunHelper -> MavenHelper），仅 --status 核对时用
_append_idea_id() { idea_plugin_ids+=("$1"); }
_append_idea_dir() { if [ -n "${2:-}" ]; then idea_plugin_dirs+=("$2"); fi; }

install_idea() {
    _info "安装模块: idea"

    # IdeaVim 配置链接（原 ideavim 模块并入）：放在两个跳过分支（IDE 未装 / 运行中）之前，
    # 保证无论本次插件装不装，ideavimrc 都先就位
    _link "$DOTFILES_DIR/.config/ideavim" "$HOME_DIR/.config/ideavim"

    # `idea` 命令由 intellij-idea cask 的 command wrapper 提供；手动安装时回退到 app 内路径
    local idea_bin
    if command -v idea &>/dev/null; then
        idea_bin="$(command -v idea)"
    else
        idea_bin="$HOME_DIR/Applications/IntelliJ IDEA.app/Contents/MacOS/idea"
    fi

    if [ ! -x "$idea_bin" ]; then
        _warn "未找到 IntelliJ IDEA，跳过插件安装。请先执行 install/install.sh brew 安装 intellij-idea cask"
        return
    fi

    # installPlugins 是 IDE 启动阶段的命令，IDE 运行中执行会与之冲突
    if pgrep -f "IntelliJ IDEA.app/Contents/MacOS/idea" &>/dev/null; then
        _warn "IntelliJ IDEA 正在运行，安装插件需完全退出 IDE，跳过。退出后重新执行 install/install.sh idea"
        return
    fi

    # 插件清单与脚本同目录（清单内容与格式说明都在该文件里）
    local manifest="$SCRIPT_DIR/idea-plugins.txt"
    local -a idea_plugin_ids=()
    _each_manifest "$manifest" _append_idea_id

    if [ ${#idea_plugin_ids[@]} -eq 0 ]; then
        _warn "清单里没有可安装的插件: $manifest"
    elif _onchange_pending "idea-plugins" "$manifest"; then
        _info "安装插件: ${idea_plugin_ids[*]}"
        # installPlugins 没有 --force，重复安装时的行为未经确认，因此不让它的非 0 退出中断整个脚本
        if "$idea_bin" installPlugins "${idea_plugin_ids[@]}"; then
            _onchange_done "idea-plugins" "$manifest"
            _ok "插件安装完成，下次启动 IDEA 生效"
        else
            _warn "installPlugins 返回非 0，可能是部分插件已安装或网络异常，请在 IDEA 的 Plugins 面板核对"
        fi
    else
        _ok "插件清单未变化，跳过（改动 $manifest 后会自动重装）"
    fi
}

status_idea() {
    # IdeaVim 链接状态先取：无论后面 IDEA 配置目录存在与否，它都是本模块的一部分
    local ideavim_st
    ideavim_st="$(_check_link "$DOTFILES_DIR/.config/ideavim" "$HOME_DIR/.config/ideavim")"

    # 已装插件数比注册表说明更有信息量，动态取
    # 配置目录名带版本号（如 IntelliJIdea2026.2），大版本升级会变，因此动态取最新的一个
    local idea_cfg
    idea_cfg=$(ls -d "$HOME_DIR/Library/Application Support/JetBrains/"IntelliJIdea* 2>/dev/null | sort -V | tail -1 || true)
    if [ -z "$idea_cfg" ]; then
        _status_line "idea" "not_set" "未找到 IntelliJ IDEA 配置目录（ideavim: $ideavim_st）"
        return
    fi

    local -a idea_plugin_dirs=()
    _each_manifest "$SCRIPT_DIR/idea-plugins.txt" _append_idea_dir
    local idea_total=${#idea_plugin_dirs[@]} idea_ok=0 idea_d
    if [ "$idea_total" -eq 0 ]; then
        _status_line "idea" "not_set" "插件清单为空（ideavim: $ideavim_st）"
        return
    fi

    for idea_d in "${idea_plugin_dirs[@]}"; do
        if [ -d "$idea_cfg/plugins/$idea_d" ]; then
            idea_ok=$((idea_ok + 1))
        fi
    done
    local idea_desc="$idea_ok/$idea_total plugins ($(basename "$idea_cfg")) + ideavim: $ideavim_st"
    # 链接未就位时即使插件全齐也不报 ok；插件一个没装且链接正常才报 not_set
    if [ "$idea_ok" -eq "$idea_total" ] && [ "$ideavim_st" = "ok" ]; then
        _status_line "idea" "ok" "$idea_desc"
    elif [ "$idea_ok" -gt 0 ] || [ "$ideavim_st" != "ok" ]; then
        _status_line "idea" "wrong" "$idea_desc"
    else
        _status_line "idea" "not_set" "$idea_desc"
    fi
}

# ============================================================
# 命令: --help
# ============================================================

show_help() {
    cat <<EOF
用法: install/install.sh [选项] [模块...]

将 my-mac-env 中的配置文件通过 symlink 链接到系统对应位置。

选项:
  --help,   -h    显示此帮助信息
  --list,   -l    列出所有可用模块
  --status, -s    查看各模块安装状态，并反查仓库中未被任何模块认领的路径

模块:
  指定一个或多个模块名（用空格分隔），或用 all 安装全部模块。
  不指定任何模块时显示本帮助信息。

示例:
  install/install.sh all          安装全部模块
  install/install.sh shell        只安装 shell
  install/install.sh shell git    只安装 shell 和 git

可用模块列表请使用 --list 查看。
EOF
}

# ============================================================
# 命令: --list
# ============================================================

show_list() {
    _load_modules
    local i
    echo "可用模块:"
    echo ""
    for i in "${!MODULE_NAMES[@]}"; do
        printf "  %-10s  %s\n" "${MODULE_NAMES[$i]}" "${MODULE_DESCS[$i]}"
    done
}

# ============================================================
# 仓库覆盖率反查（--status 用）
# ============================================================
#
# 从 install.sh 自身提取所有 $DOTFILES_DIR/xxx 字面量，作为「已被模块认领」的路径；
# 再遍历 Users/USERNAME/，列出没有任何模块认领的文件/目录（例如新增内容后忘了写安装逻辑）。
# 认领列表从脚本现取而非单独维护，避免与安装逻辑脱节。

_CLAIMED=()

# 提取脚本中出现的 $DOTFILES_DIR/ 路径字面量，输出相对 DOTFILES_DIR 的路径，去重排序
# 说明: 模式首个字符类 [A-Za-z._] 不含 [，因此本行不会匹配到自己的源码文本
_claimed_paths() {
    grep -v '^[[:space:]]*#' "${BASH_SOURCE[0]}" \
        | grep -oE '\$DOTFILES_DIR/[A-Za-z._][^"*]*' \
        | sed 's|^\$DOTFILES_DIR/||' \
        | sort -u
}

# $1 是否已被认领（自身命中，或位于某个被认领的目录之下）
_rel_is_claimed() {
    local rel="$1" c
    for c in "${_CLAIMED[@]}"; do
        if [ "$rel" = "$c" ]; then
            return 0
        fi
        case "$rel" in "$c"/*) return 0 ;; esac
    done
    return 1
}

# 是否有认领路径位于目录 $1 之下（据此决定是否要递归进这个目录）
_rel_has_claim_under() {
    local rel="$1" c
    for c in "${_CLAIMED[@]}"; do
        case "$c" in "$rel"/*) return 0 ;; esac
    done
    return 1
}

# 遍历 $1（相对 DOTFILES_DIR 的目录，空串表示根）输出未被认领的路径
# 目录内部若完全没有认领路径，就整体报这个目录，不再往下展开
_scan_unclaimed() {
    local rel_dir="$1"
    local abs_dir="$DOTFILES_DIR${rel_dir:+/$rel_dir}"
    local f base rel
    for f in "$abs_dir"/* "$abs_dir"/.[!.]*; do
        [ -e "$f" ] || [ -L "$f" ] || continue
        base="$(basename "$f")"
        rel="${rel_dir:+$rel_dir/}$base"
        if _rel_is_claimed "$rel"; then
            continue
        fi
        if [ -d "$f" ] && _rel_has_claim_under "$rel"; then
            _scan_unclaimed "$rel"
        else
            printf '%s\n' "$rel"
        fi
    done
}

# ============================================================
# 命令: --status
# ============================================================

show_status() {
    _load_modules

    printf "\n%-12s %-9s  %s\n" "Module" "Status" "Description"
    printf "%s\n" "------------------------------------------------------------"

    local i mod
    for i in "${!MODULE_NAMES[@]}"; do
        mod="${MODULE_NAMES[$i]}"
        if declare -F "status_$mod" &>/dev/null; then
            "status_$mod" "${MODULE_DESCS[$i]}"
        else
            # 未实现状态检查的模块，直接用注册表说明占位
            _status_line "$mod" "not_set" "${MODULE_DESCS[$i]}"
        fi
    done

    # coverage — 反查仓库里存在、但没有被任何模块认领的路径
    _CLAIMED=()
    local p
    while IFS= read -r p; do
        _CLAIMED+=("$p")
    done < <(_claimed_paths)

    local -a unclaimed=()
    while IFS= read -r p; do
        unclaimed+=("$p")
    done < <(_scan_unclaimed "" | sort)

    if [ ${#unclaimed[@]} -eq 0 ]; then
        _status_line "coverage" "ok" "仓库内所有路径都已被模块认领"
    else
        _status_line "coverage" "uncovered" "${#unclaimed[@]} 处路径未被任何模块认领:"
        for p in "${unclaimed[@]}"; do
            printf "%-12s %-9s  - %s\n" "" "" "$p"
        done
    fi

    printf "\n状态说明: OK=已安装, SKIP=未配置, CONFLICT=存在同名文件/目录, WRONG=symlink指向错误, MISSING=源文件缺失, UNCOVERED=仓库中存在但未被任何模块认领的路径\n\n"
}

_status_line() {
    local mod="$1"
    local status="$2"
    local desc="$3"

    local status_label
    case "$status" in
        ok)        status_label="OK       " ;;
        not_set)   status_label="SKIP     " ;;
        conflict)  status_label="CONFLICT " ;;
        wrong)     status_label="WRONG    " ;;
        missing)   status_label="MISSING  " ;;
        uncovered) status_label="UNCOVERED" ;;
        *)         status_label="$status" ;;
    esac

    printf "%-12s %-9s  %s\n" "$mod" "$status_label" "$desc"
}

# ============================================================
# 主流程
# ============================================================

main() {
    # 解析参数
    local modules=()

    for arg in "$@"; do
        case "$arg" in
            --help|-h)
                show_help
                exit 0
                ;;
            --list|-l)
                show_list
                exit 0
                ;;
            --status|-s)
                show_status
                exit 0
                ;;
            -*)
                _error "未知选项: $arg"
                _info "使用 --help 查看帮助"
                exit 1
                ;;
            *)
                modules+=("$arg")
                ;;
        esac
    done

    # 无参数则显示帮助
    if [ ${#modules[@]} -eq 0 ]; then
        show_help
        exit 0
    fi

    # 加载模块注册表（帮助类命令在上面已经各自处理过，到这里才需要它）
    _load_modules

    # all 展开为所有模块
    if [ ${#modules[@]} -eq 1 ] && [ "${modules[0]}" = "all" ]; then
        modules=("${MODULE_NAMES[@]}")
    fi

    echo ""

    # 执行安装
    local mod fn
    for mod in "${modules[@]}"; do
        if ! _is_registered_module "$mod"; then
            _error "未知模块: $mod"
            _info "使用 --list 查看所有可用模块"
            exit 1
        fi
        fn="install_$mod"
        if ! declare -F "$fn" &>/dev/null; then
            _error "模块 $mod 已在注册表登记，但脚本未实现 $fn"
            _info "请检查 install.sh 与 install/modules.txt 是否一致"
            exit 1
        fi
        "$fn"
        echo ""
    done

    _ok "安装完成!"
}

main "$@"
