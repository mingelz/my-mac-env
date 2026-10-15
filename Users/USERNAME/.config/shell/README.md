# shell - Shell 配置分层说明

本目录存放 bash / zsh 共享的配置片段，由 home 目录下的入口文件按**加载时机**分层引入。

## 一、为什么要分层

bash 与 zsh 各有一组启动文件，读不读取决于两个正交维度：**是否 login**、**是否 interactive**。四种组合读取的文件子集完全不同（表中省略 `/etc` 下的同名系统文件）：

| login | interactive | 典型场景 | zsh 读取（按序） | bash 读取 |
|:---:|:---:|---|---|---|
| ✓ | ✓ | 终端 App 新开窗口；`ssh host` | zshenv → zprofile → zshrc | bash_profile（内部显式 source bashrc；并完整执行） |
| ✓ | ✗ | `zsh -lc`（`bash -lc` 同理） | zshenv → zprofile | bash_profile（内部显式 source bashrc；但 bashrc 开头检测到非交互，直接 return） |
| ✗ | ✓ | 在 zsh 里敲 `bash`、tmux、`docker exec -it` | zshenv → zshrc | bashrc |
| ✗ | ✗ | `zsh -c cmd`、shell 脚本、scp/rsync、Raycast script command | zshenv | 无（仅 `$BASH_ENV` 可指定） |

分层的目的就是让每类配置写在**恰好覆盖其全部使用场景**的最小入口上：

- 环境变量希望任何场景都生效 → 写所有行都读的 `zshenv`（env 层）
- PATH 只需 login 时构建一次 → 写只有 login 行读的 `zprofile`（path 层），非 login 场景由父进程继承
- alias、快捷键只在交互时有意义 → 写只有交互行读的 `zshrc`（rc 层）

## 二、三层模型

上表自然划出三个加载时机，对应本目录的三个层：

| 层 | 放什么 | zsh 入口 | bash 入口 |
|---|---|---|---|
| **env** | 纯环境变量：`XDG_*`、`EDITOR`、各工具的镜像/配置路径 | `.zshenv`（所有调用） | `.bash_profile`；`.bashrc` 兜底 |
| **path** | PATH 构建，以及 `brew shellenv`、`JAVA_HOME` 等需要跑子进程的初始化 | `.zprofile`（login） | `.bash_profile`（login） |
| **rc** | alias、函数、快捷键、oh-my-zsh、补全与高亮、历史记录 | `.zshrc`（交互） | `.bashrc`（交互） |

bash 没有与 `.zshenv` 对应的文件，env 层靠双入口补齐：login 走 `.bash_profile`，非 login 交互走 `.bashrc` 的兜底守卫（`_SHELL_ENV_DONE` 未设置时补加载）。非交互 bash 两者都不读，依赖父进程环境继承——env 层清一色 `export`，正常父进程拉起的 bash 都能拿到。

## 三、各层注意事项

### env 层：无输出、稳态零 fork

`.zshenv` 会在**每一次** zsh 调用时执行，包括脚本以及 `scp` / `rsync` 等依赖干净输出的场景。因此 `env.sh` 中：

- 只允许纯变量赋值
- 禁止调用子进程（如 `$(...)`、`command -v`）
- 禁止任何输出

唯一的例外是**目录保障**：允许为本层声明的变量所指向的路径创建目录，但必须同时满足：

- **存在性守卫 + 失败静默**：`[ -d ... ] || mkdir -p ... 2>/dev/null`。守卫判断约 1μs，稳态零 fork；不加守卫则每次调用多付一次 fork（实测 `mkdir -p` 约 12ms/次）。
- **范围仅限本层声明的变量**：不允许"顺便"为其他工具建目录，否则 env 层会滑向脚本。

XDG 四个基目录（config / local / state / cache）无需在 env 层加守卫，在真实需要用到的地方自然会被守卫创建出来。

### path 层：必须排在 path_helper 之后

macOS 的 `/etc/zprofile` 会执行 `path_helper`，把 `/etc/paths` 与 `/etc/paths.d` 中的系统路径重排到最前面。写在 `.zshenv` 里的 PATH 顺序在 login shell 中必然被打乱，因此 PATH 必须在 `path_helper` 之后、即 `~/.zprofile` 中构建。这也是 Homebrew 官方要求把 `brew shellenv` 写进 `.zprofile` 的原因。

zsh 的完整加载顺序：

```
/etc/zshenv -> ~/.zshenv -> /etc/zprofile -> ~/.zprofile -> /etc/zshrc -> ~/.zshrc
```

**非 login shell** 不读 `.zprofile` / `.bash_profile`，其 PATH 从父进程继承。对于 Raycast script command、LaunchAgent 这类由 GUI 直接拉起、PATH 很贫瘠的场景，约定**显式使用 `zsh -l -c`**，而不是把 PATH 逻辑塞进 env 层去做去重与重排。

### rc 层：函数与脚本的判据

什么放 rc 层做成函数、什么放 `~/.local/bin` 做成脚本，判据是**要不要修改调用者 shell 的状态**，而不是「是否通用」：

- 必须是 shell 函数：会 `cd`、`export`、定义 `alias`、`setopt` 或注册 shell hook 的，例如 `jdk()`（改 `JAVA_HOME` 与 `PATH`）、fnm 的 `--use-on-cd`。否则脚本跑在子进程里，内部即使用 `eval` 也只作用于子进程本身。
- 应该做成独立脚本：只读取参数、产出输出，不碰调用者状态的，例如 `lg`、`sgrep`。做成脚本后在非交互场景（`zsh -c`、Raycast、Makefile、其他语言的 subprocess）同样可用，且不占用 shell 的函数命名空间。

这类脚本放在仓库的 `.local/bin/`，后续由安装脚本链接到 `~/.local/bin`。

## 四、文件命名规则

分隔符即语义：**点号只用于固定语法标记（`private` 前缀、层 `env`/`path`/`rc`、时机 `pre`/`post`、shell `zsh`/`bash`/`sh`），下划线连接自由命名的词**。看名字即可分清哪些是机制、哪些是人起的名字，受管与 private 共用这一套。

- `env` / `path` 各自是整层唯一文件，直接以层名为文件名
- rc 层内容最多，且被 oh-my-zsh 三明治切成多个加载时机，以 `rc_` 前缀聚合，ls 排序天然按层分组
- `rc_omz.pre` / `rc_omz.post` 的时机标记与 `private*.rc.pre.zsh` / `private*.rc.post.zsh` 对应，在 `.zshrc` 中按位置一一相邻
- 扩展名：`.sh` 表示 bash / zsh 通用，`.zsh` / `.bash` 表示某一 shell 专属
- private 后缀的完整形态是 `.<层>[.<时机>].<shell>`：层标记参与 glob 路由（决定哪个入口加载），因此 `env` / `path` / `rc` 不可省略

```
shell/
├── README.md
│
├── env.sh             env  层：XDG_*、EDITOR、LESSHISTFILE + Homebrew / 各语言环境变量
├── path.sh            path 层：~/.local/bin + Homebrew / Java / Ruby 的 PATH
├── rc.sh              rc   层：通用 alias、历史记录 + Homebrew / Java / Node / Python 交互配置
├── rc_keys.sh         rc   层：快捷键绑定（必须在 omz 之后加载）
├── rc_omz.pre.zsh     rc   层：omz 相关变量、设置项、主题、插件列表（omz 启动前，zsh 专属）
├── rc_omz.post.zsh    rc   层：语法高亮、自动建议（omz 启动后，zsh 专属）
│
├── private.example.sh 私人配置模板
└── private*           私人配置，已被 .gitignore 忽略
```

### 什么时候用 `.sh` + 分支，什么时候拆 `.zsh` / `.bash`

判据是**两种 shell 的配置是否在表达同一个意图**：

- 同一意图、只是方言不同 → 合在一个 `.sh` 里用 `if [ -n "$ZSH_VERSION" ]` 分支。两侧相邻才看得出它们说的是同一件事，不容易只改一边。`rc.sh` 的历史记录段（`SAVEHIST` 对 `HISTFILESIZE`）与 `rc_keys.sh`（`bindkey` 对 `bind`）属于此类。
- 意图本身不同、没有逐行对应关系 → 拆成 `.zsh` / `.bash`，文件名即文档。`rc_omz.post.zsh` 属于此类（bash 根本没有对应概念）。

注意合并只能让对称性**可见**，不会替你**保证**对称：把某一侧的值委托给外部（比如依赖 omz 设 `SAVEHIST`）依旧会 drift，因此两侧均显式设值。

## 五、私人配置

| 文件 | 层 | 加载入口 | 适合放 |
|---|---|---|---|
| `private*.env.sh` | env | `.zshenv`、`.bash_profile` | 需要在非交互/脚本场景生效的私有变量、token |
| `private*.path.sh` | path | `.zprofile`、`.bash_profile` | PATH 前置 |
| `private*.rc.sh` | rc | `.zshrc`、`.bashrc` | 通用 alias、变量 |
| `private*.rc.bash` | rc | `.bashrc` | bash 专属 |
| `private*.rc.zsh` | rc | `.zshrc`（未装 omz 也加载） | zsh 专属、不依赖 omz 的配置 |
| `private*.rc.pre.zsh` | rc | `.zshrc`，omz 启动前（未装 omz 不加载） | omz 专属，`$plugins`、omz 变量覆盖等 |
| `private*.rc.post.zsh` | rc | `.zshrc`，omz 启动后（未装 omz 不加载） | omz 专属，`compdef`、依赖 omz 环境的命令 |

- `private*` 均被 `.gitignore` 忽略，可直接在当前目录下创建使用；仅模板 `private.example.sh` 被定向豁免入库，其后缀不被任何入口 glob 匹配，也不参与加载。
- **后缀互斥即隔离**：private 后缀的完整形态为 `.<层>[.<时机>].<shell>`，每个后缀都带显式层段参与 glob 路由，任意两个后缀互不匹配（`*.rc.zsh` 不会匹配 `*.rc.pre.zsh`）——各入口的 glob 天然精确，全部无需 case 排除。
- **env/path 层没有 shell 专属形态**：`.zsh` / `.bash` 只为 rc 层存在——方言分化（如 `bindkey` vs `bind`、补全系统）只发生在交互功能层，而 env/path 的配置语义是 POSIX 的（变量赋值、PATH 追加），zsh/bash 语法零差异。个别变量确需只在某一 shell 生效时，在共用文件里用 `$ZSH_VERSION` / `$BASH_VERSION` 条件分支即可，另一 shell 读到闲置变量也无害。
- `private*.env.sh` 的内容必须遵守 env 层约束：只放纯变量赋值，禁止子进程调用与任何输出（仅允许目录保障例外，见「env 层：无输出、稳态零 fork」）。

## 六、维护约定

1. **外部工具的写入**：某些安装脚本会往 `.zshrc`、`.bash_profile` 等入口文件末尾追加内容，且会在每次启动时检查，删掉又会被重新注入，所以我留了 `其他配置（当有应用修改此文件时可快速识别）` 段方便观察类似情况。
2. **bash 的三入口优先级**：bash 只读取 `~/.bash_profile`、`~/.bash_login`、`~/.profile` 中**第一个存在**的文件。本仓库提供了 `.bash_profile`，因此后两者永远不会生效——不要往它们里面写配置。
3. **新增配置时先定层**：能不依赖交互就放 env / path 层；需要 `alias`、`bind`、zle widget、shell hook 的一定放 rc 层。不修改 shell 状态的工具则做成 `.local/bin/` 下的脚本。
4. **omz 会重置 keymap**：omz 的 `lib/key-bindings.zsh` 执行 `bindkey -e`，把整个 keymap 重置为 emacs 默认。因此 zsh 侧的 `bindkey` 必须在 omz 启动**之后**执行。
5. **bash/zsh 共享片段的两个静默分歧**：新增共用代码后必须在 `zsh` 与 `bash` 下**各跑一遍对比**，只测其中一种必然漏掉：
   - **MULTIOS 会复制输出**：`cmd 2>&1 >/dev/null | pipe`（本意是丢弃 stdout、只取 stderr）在 bash 下正确，但 zsh 默认开启 MULTIOS，会把 stdout 像 `tee` 一样同时写进管道。需要花括号隔离：`{ cmd >/dev/null; } 2>&1 | pipe`。
   - **参数替换的 pattern 不能加引号**：`${var//"pat"/rep}` 在 bash 下正常，zsh 下完全不替换。要把 pattern 放进变量再不加引号引用。
