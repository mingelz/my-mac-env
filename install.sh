#!/bin/bash
#
# my-mac-env 自动安装脚本，通过 symlink 将配置文件链接到对应位置
#
# 用法:
#   ./install.sh all          # 安装全部模块
#   ./install.sh shell git    # 只安装指定模块
#   ./install.sh --list       # 列出所有可用模块
#   ./install.sh --status     # 查看当前安装状态
#   ./install.sh --help       # 显示帮助信息
#

set -e

# ============================================================
# 常量定义
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/Users/USERNAME"
ASSETS_DIR="$SCRIPT_DIR/assets"
HOME_DIR="$HOME"

# 所有可用模块（有序，依赖信息）
# - brew (安装 omz 插件) -> shell (启用 omz 插件)
# - brew (安装 fnm) -> node (安装 node, 安装 npm 包)
ALL_MODULES=(brew shell ssh git vim ideavim node python ruby karabiner raycast agents bin vscode)

# ============================================================
# 工具函数
# ============================================================

# 颜色输出
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

        # 是普通文件/目录，备份后替换（加时间戳避免多次运行覆盖备份）
        local bak="${dst}.bak.$(date +%Y%m%d%H%M%S)"
        _warn "目标已存在且非 symlink，备份为: $bak"
        mv "$dst" "$bak"
    fi

    ln -sf "$src" "$dst"
    _ok "已链接: $dst -> $src"
}

# ============================================================
# 安装模块
# ============================================================

install_shell() {
    _info "安装模块: shell"
    _link "$DOTFILES_DIR/.bash_profile" "$HOME_DIR/.bash_profile"
    _link "$DOTFILES_DIR/.zshrc" "$HOME_DIR/.zshrc"
    _link "$DOTFILES_DIR/.config/shellrc" "$HOME_DIR/.config/shellrc"
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

install_vim() {
    _info "安装模块: vim"
    _link "$DOTFILES_DIR/.config/vim" "$HOME_DIR/.config/vim"
}

install_ideavim() {
    _info "安装模块: ideavim"
    _link "$DOTFILES_DIR/.config/ideavim" "$HOME_DIR/.config/ideavim"
}

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

    # 安装全局 npm 包
    local pkg_file="$DOTFILES_DIR/.config/npm/npm-global-packages.txt"
    if [ -f "$pkg_file" ]; then
        local pkgs
        pkgs=$(grep -v '^\s*#' "$pkg_file" | grep -v '^\s*$' || true)
        if [ -n "$pkgs" ]; then
            _info "安装全局 npm 包: $(echo "$pkgs" | tr '\n' ' ')..."
            echo "$pkgs" | xargs npm install -g
            _ok "全局 npm 包已安装"
        fi
    fi
}

install_python() {
    _info "安装模块: python"
    _link "$DOTFILES_DIR/.config/pip" "$HOME_DIR/.config/pip"

    if command -v uv &>/dev/null; then
        _info "检测到 uv，安装最新版 Python..."
        uv python install
        _ok "Python 已通过 uv 安装"
    else
        _warn "uv 未安装，跳过 Python 安装。请先通过 brew 安装 uv"
    fi
}

install_ruby() {
    _info "安装模块: ruby"
    _link "$DOTFILES_DIR/.config/gem/gemrc" "$HOME_DIR/.config/gem/gemrc"
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

install_agents() {
    _info "安装模块: agents"
    local src_dir="$DOTFILES_DIR/.agents"
    local dst_dir="$HOME_DIR/.agents"
    local category
    for category in commands rules; do
        [ -d "$src_dir/$category" ] || continue
        mkdir -p "$dst_dir/$category"
        for item in "$src_dir/$category"/*; do
            [ -e "$item" ] || continue
            _link "$item" "$dst_dir/$category/$(basename "$item")"
        done
    done
}

install_bin() {
    _info "安装模块: bin"
    local src_dir="$DOTFILES_DIR/.local/bin"
    local dst_dir="$HOME_DIR/.local/bin"
    mkdir -p "$dst_dir"
    local item_name dst
    for item in "$src_dir"/*; do
        [ -e "$item" ] || continue
        item_name="$(basename "$item")"
        dst="$dst_dir/$item_name"
        _link "$item" "$dst"
    done
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
}

install_brew() {
    _info "安装模块: brew"
    local brewfile="$ASSETS_DIR/Brewfile"
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

# ============================================================
# 命令: --help
# ============================================================

show_help() {
    cat <<EOF
用法: ./install.sh [选项] [模块...]

将 my-mac-env 中的配置文件通过 symlink 链接到系统对应位置。

选项:
  --help,   -h    显示此帮助信息
  --list,   -l    列出所有可用模块
  --status, -s    查看各模块安装状态

模块:
  不指定模块时安装全部。指定一个或多个模块名，用空格分隔。

示例:
  ./install.sh              安装全部模块
  ./install.sh shell        只安装 shell
  ./install.sh shell git    只安装 shell 和 git

可用模块列表请使用 --list 查看。
EOF
}

# ============================================================
# 命令: --list
# ============================================================

show_list() {
    cat <<EOF
可用模块:

  shell       .bash_profile, .zshrc, .config/shellrc/
  ssh         .ssh/config
  git         .config/git/
  vim         .config/vim/
  ideavim     .config/ideavim/
  node        .config/npm/ + fnm install LTS + 全局 npm 包
  python      .config/pip/
  ruby        .config/gem/
  karabiner   .config/karabiner/
  raycast     .config/raycast/ai/providers.yaml
  agents      .agents/
  bin         .local/bin/
  vscode      settings.json, keybindings.json
  brew        执行 brew bundle (读取 assets/Brewfile)
EOF
}

# ============================================================
# 命令: --status
# ============================================================

show_status() {
    printf "\n%-12s %-8s  %s\n" "Module" "Status" "Description"
    printf "%s\n" "------------------------------------------------------------"

    # shell
    local st
    st=$(_check_link "$DOTFILES_DIR/.zshrc" "$HOME_DIR/.zshrc")
    _status_line "shell" "$st" ".zshrc, .bash_profile, .config/shellrc/"

    # ssh
    if [ -f "$HOME_DIR/.ssh/config" ]; then
        _status_line "ssh" "ok" ".ssh/config"
    else
        _status_line "ssh" "not_set" ".ssh/config"
    fi

    # git
    st=$(_check_link "$DOTFILES_DIR/.config/git" "$HOME_DIR/.config/git")
    _status_line "git" "$st" ".config/git/"

    # vim
    st=$(_check_link "$DOTFILES_DIR/.config/vim" "$HOME_DIR/.config/vim")
    _status_line "vim" "$st" ".config/vim/"

    # ideavim
    st=$(_check_link "$DOTFILES_DIR/.config/ideavim" "$HOME_DIR/.config/ideavim")
    _status_line "ideavim" "$st" ".config/ideavim/"

    # node
    st=$(_check_link "$DOTFILES_DIR/.config/npm" "$HOME_DIR/.config/npm")
    local node_info="fnm: $(command -v fnm &>/dev/null && fnm current 2>/dev/null || echo '未安装')"
    _status_line "node" "$st" "$node_info"

    # python
    st=$(_check_link "$DOTFILES_DIR/.config/pip" "$HOME_DIR/.config/pip")
    _status_line "python" "$st" ".config/pip/"

    # ruby
    st=$(_check_link "$DOTFILES_DIR/.config/gem/gemrc" "$HOME_DIR/.config/gem/gemrc")
    _status_line "ruby" "$st" ".config/gem/gemrc"

    # karabiner
    if [ -f "$HOME_DIR/.config/karabiner/karabiner.json" ]; then
        _status_line "karabiner" "ok" "karabiner.json"
    else
        _status_line "karabiner" "not_set" "karabiner.json"
    fi

    # raycast
    if [ -f "$HOME_DIR/.config/raycast/ai/providers.yaml" ]; then
        _status_line "raycast" "ok" "providers.yaml"
    else
        _status_line "raycast" "not_set" "providers.yaml"
    fi

    # agents — 逐个检查 symlink 是否正确指向
    local agents_src_dir="$DOTFILES_DIR/.agents"
    local agents_dst_dir="$HOME_DIR/.agents"
    local agents_total=0 agents_linked=0
    for category in commands rules; do
        [ -d "$agents_src_dir/$category" ] || continue
        for item in "$agents_src_dir/$category"/*; do
            [ -e "$item" ] || continue
            agents_total=$((agents_total + 1))
            local agents_name
            agents_name=$(basename "$item")
            if [ -L "$agents_dst_dir/$category/$agents_name" ] && [ "$(readlink "$agents_dst_dir/$category/$agents_name")" = "$item" ]; then
                agents_linked=$((agents_linked + 1))
            fi
        done
    done
    if [ "$agents_total" -eq "$agents_linked" ] && [ "$agents_total" -gt 0 ]; then
        _status_line "agents" "ok" "$agents_linked/$agents_total linked"
    elif [ "$agents_linked" -gt 0 ]; then
        _status_line "agents" "wrong" "$agents_linked/$agents_total linked"
    else
        _status_line "agents" "not_set" ".agents/"
    fi

    # bin — 只统计本项目管理的 symlink
    local bin_src_dir="$DOTFILES_DIR/.local/bin"
    local bin_dst_dir="$HOME_DIR/.local/bin"
    local bin_total=0 bin_linked=0
    if [ -d "$bin_src_dir" ]; then
        for item in "$bin_src_dir"/*; do
            [ -e "$item" ] || continue
            bin_total=$((bin_total + 1))
            local bin_name
            bin_name=$(basename "$item")
            if [ -L "$bin_dst_dir/$bin_name" ] && [ "$(readlink "$bin_dst_dir/$bin_name")" = "$item" ]; then
                bin_linked=$((bin_linked + 1))
            fi
        done
    fi
    if [ "$bin_total" -eq "$bin_linked" ] && [ "$bin_total" -gt 0 ]; then
        _status_line "bin" "ok" "$bin_linked/$bin_total linked"
    elif [ "$bin_linked" -gt 0 ]; then
        _status_line "bin" "wrong" "$bin_linked/$bin_total linked"
    else
        _status_line "bin" "not_set" ".local/bin/"
    fi

    # vscode — settings.json + keybindings.json
    local vscode_src_dir="$DOTFILES_DIR/Library/Application Support/Code/User"
    local vscode_dst_dir="$HOME_DIR/Library/Application Support/Code/User"
    local vscode_total=0 vscode_ok=0
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

    # brew
    if command -v brew &>/dev/null; then
        local brew_count
        brew_count=$(brew list 2>/dev/null | wc -l | tr -d ' ')
        _status_line "brew" "ok" "$brew_count 个已安装包"
    else
        _status_line "brew" "not_set" "Homebrew 未安装"
    fi

    printf "\n状态说明: OK=已安装, SKIP=未配置, CONFLICT=存在同名文件/目录, WRONG=symlink指向错误, MISSING=源文件缺失\n\n"
}

_status_line() {
    local mod="$1"
    local status="$2"
    local desc="$3"

    local status_label
    case "$status" in
        ok)       status_label="OK      " ;;
        not_set)  status_label="SKIP    " ;;
        conflict) status_label="CONFLICT" ;;
        wrong)    status_label="WRONG   " ;;
        missing)  status_label="MISSING " ;;
        *)        status_label="$status" ;;
    esac

    printf "%-12s %-8s  %s\n" "$mod" "$status_label" "$desc"
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

    # all 展开为所有模块
    if [ ${#modules[@]} -eq 1 ] && [ "${modules[0]}" = "all" ]; then
        modules=("${ALL_MODULES[@]}")
    fi

    echo ""

    # 执行安装
    for mod in "${modules[@]}"; do
        case "$mod" in
            shell)     install_shell ;;
            ssh)       install_ssh ;;
            git)       install_git ;;
            vim)       install_vim ;;
            ideavim)   install_ideavim ;;
            node)      install_node ;;
            python)    install_python ;;
            ruby)      install_ruby ;;
            karabiner) install_karabiner ;;
            raycast)   install_raycast ;;
            agents)    install_agents ;;
            bin)       install_bin ;;
            vscode)    install_vscode ;;
            brew)      install_brew ;;
            *)
                _error "未知模块: $mod"
                _info "使用 --list 查看所有可用模块"
                exit 1
                ;;
        esac
        echo ""
    done

    _ok "安装完成!"
}

main "$@"
