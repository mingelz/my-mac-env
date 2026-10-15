# Mac 环境安装配置一条龙

2022-10-12

## 一、制作安装盘

* 在 App Store 中搜索最新版的 macOS，并点击「下载」
    * 或者访问苹果官网 [如何下载 macOS](https://support.apple.com/zh-cn/HT211683) 找需要的版本
* 从 10.14 开始系统安装从 App Store 转到 「系统偏好设置」-「软件更新」中了，点击【现在升级】即可
* 下载完成后，会弹出安装提示，不要理会。可以点击状态栏左上角「安装 macOS」-「退出安装 macOS」关闭安装
* 接下来，根据你的实际情况，选择制作U盘安装盘，还是光盘安装盘

### 1.1 制作U盘安装盘

参考苹果官网文档 [创建可引导的 macOS 安装器](https://support.apple.com/zh-cn/HT201372)

* 找一个大于 8G 的U盘
* 清空磁盘
    * 通过 Spotlight 或 Launchpad 启动「磁盘工具」，并点击「继续」
    * 从左侧的列表中选择插入的U盘，然后选择「抹掉」标签
    * 格式【Mac OS 扩展（日志式）】
    * 磁盘名称【MyVolume】（此名称可随便起，后边会用到）
    * 点击「抹掉」
* 创建安装盘
    * 通过 Spotlight 或 Launchpad 启动「终端」
    * 刚才下载的 macOS 会放在 `/Applications` 目录下，假设文件名为 `Install macOS Monterey.app`
    * 执行：`sudo /Applications/Install\ macOS\ Monterey.app/Contents/Resources/createinstallmedia --volume /Volumes/MyVolume`
        * 如果 macOS 小于 10.14，还需要追加 `--applicationpath /Applications/Install\ macOS\ Catalina.app` 参数
    * 之后会给出提示并输入【Y】确认，然后开始制作安装盘，分三步：
        * 清空磁盘 `Erasing disk`，只需几秒
        * 制作引导盘 `Making disk bootable`，需几分钟（貌似只在 MacOS 12 中见到了）
        * 复制文件 `Copying to disk`，时间较长，约 30 ~ 70 分钟

### 1.2 制作光盘安装盘（ISO文件）

* 在 `/tmp` 下创建一个 8G 的虚拟磁盘：`hdiutil create -o /tmp/Catalina -size 8G -layout SPUD -fs HFS+J -type SPARSE`
    * 制作的磁盘会默认有 `.sparseimage` 后缀
* 将此盘挂载到系统中：`hdiutil attach /tmp/Catalina.sparseimage -noverify -mountpoint /Volumes/MyVolume`
* 制作安装盘：`sudo /Applications/Install\ macOS\ Catalina.app/Contents/Resources/createinstallmedia --volume /Volumes/MyVolume`
* 取消挂载，否则磁盘被占用，无法执行后续操作：`hdiutil detach /Volumes/Install\ macOS\ Catalina/`
* 将 `.sparseimage` 文件转为 ISO 文件：`hdiutil convert /tmp/Catalina.sparseimage -format UDTO -o /tmp/Catalina.iso`
* 前一步生成的文件名会自动添加 `.cdr` 后缀，改回来放桌面：`mv /tmp/Catalina.iso.cdr ~/Desktop/Catalina.iso`
* 最后删掉中间文件：`rm /tmp/Catalina.sparseimage`

参考文档：

* [VirtualBox: How to create a macOS High Sierra VM to run on a Mac host system](https://tobiwashere.de/2017/10/virtualbox-how-to-create-a-macos-high-sierra-vm-to-run-on-a-mac-host-system/)
* [Creating a macOS High Sierra VM for VirtualBox (Mac Host)](https://blog.caffeinesecurity.com/creating-a-macos-high-sierra-vm-for-virtualbox-mac-host-bb67eada27af)

## 二、系统安装

### 2.1 通过U盘安装

* ARM(Apple Silicon) 版本关机后，长按开机键直到显示启动菜单; X86(Intel) 版本重启电脑并按住 option 键，在启动菜单中选择刚刚制作的U盘
* 建议整个安装过程联网，否则可能会提示「安装器有效负载签名检查失败」
* 如果需要全新安装，在安装进程进行到「macOS 实用工具」时选择「磁盘工具」，抹掉硬盘上的内容（格式请选择「APFS」）
* 同样在「macOS 实用工具」选择「全新安装 macOS」开始安装系统
* 安装中会有几次重启，无需干预，整个过程大概 10 分钟

### 2.2 通过网络安装

针对 ARM(Apple Silicon) 版本，与【2.1 通过U盘安装】一致，没插入U盘时，选择「全新安装 macOS」就会从网络下载并进行安装。

## 三、系统设置

以下流程，基于 Monterey 的设置界面排序，且在安装时已联网并登录 iCloud 账号，所以可能会缺少一些关于 iCloud 的配置细节。

### 3.1 系统偏好设置

* 网络
    * 关闭雷雳网桥
    * 启用防火墙
* 通用
    * 关于本机
        * 名称：修改本机名称
    * 软件更新
        * 自动更新：全都打开
    * 储存空间
        * 存储在 iCloud 中：在【iCloud】中统一设置，不需要在这里管理了
    * 登录项与扩展
        * 酌情关闭不需要的项目
* 辅助功能
    * 指针控制
        * 触控板选项
            * 使用触控板进行拖移：打开
            * 拖移样式：三批拖移
* 外观
    * 在滚动条中点按
        * 跳到点按的位置
* 控制中心
    * 其他模块
        * 电池
            * 显示百分比：打开
* 桌面与程序坞
    * 程序坞
        * 大小：最小
        * 放大：看情况
        * 置于屏幕上的位置：左侧
        * 在程序坞中显示建议App和最近使用的App：关闭
    * 桌面与台前调度
        * 占按墙纸以显示桌面：仅在台前调度中
    * 调度中心
        * 根据最近的使用情况自动重新排列空间：关闭
    * 触发角：关闭所有
* 显示器
    * 夜览
        * 定时：日出到日落
* 屏幕保护程序
    * 随机播放航拍：全部随机
* 聚焦
    * 关闭所有
    * 帮助Apple改进搜索：关闭
* 声音
    * 提醒音量：适当调整
* 锁定屏幕
    * 只有「启动屏幕保护」时间小于「关闭显示器」时间，才能正常启动屏保
* iCloud
    * 关闭不希望同步的项目
* 键盘
    * 键盘快捷键
        * 启动台与程序坞：关闭所有
        * 显示器：关闭所有
        * 调度中心：关闭所有
        * 窗口：保留「通用-居中」和「二等分」，其他关闭
        * 键盘：仅保留以下
            * 将焦点移到下一窗口：Command+`
        * 输入法：仅保留以下
            * 选择上一个输入法：Option+Space
        * 截屏：仅保留以下
            * 截屏和录制选项
        * 演讲者前置：关闭所有
        * 服务：关闭所有
        * 聚焦：关闭所有
        * 辅助功能：仅保留以下
            * 反转颜色，并将快捷键设置为 Command+Q
        * App快捷键：关闭所有
        * 修饰键：调换 大写锁定和Control
    * 输入法
        * 编辑
            * 自动纠正拼写：关闭
            * 自动大写字词的首字母：关闭
            * 连按两下空格键插入句号：关闭
* 触控板
    * 查询与数据检测器：三指轻点
    * 轻点来点按：打开
    * 轻扫切换页面：关闭
    * App Expose：四指向下轻扫

### 3.2 Finder 偏好设置

* 通用
    * 【勾选】以下项目
        * 外置磁盘
        * CD、DVD 和 iPod
    * 开启新 Finder 窗口时打开: 【<家目录>】
* 边栏
    * 【勾选】以下项目，其他全部取消勾选
        * 个人收藏
            * AirDrop（隔空投送）
            * 桌面
            * 文稿
            * 下载
            * <家目录>
        * iCloud
            * iCloud Drive（iCloud 云盘）
        * 位置
            * 当前电脑名
            * 硬盘（保持部分勾选不要动）
            * 外置磁盘
            * CD、DVD 和 iOS 设备
            * 云端存储空间
* 高级
    * 【勾选】显示所有文件的扩展名
    * 将以下位置的文件夹保持在顶部：
        * 【勾选】按名称排序时的窗口中
        * 【勾选】桌面上

### 3.3 系统顶部菜单栏

* 按住 Command 可拖动
* 右向左顺序：时间、控制中心、聚焦搜索、电池、Wifi、输入法

### 3.4 系统 Docker 栏

* 保留：Finder、日历、iPhone镜像、浏览器、iTerm、Editor

### 3.5 系统右侧通知栏

* 根据喜好配置
* 个人配置：
    * 提醒事项
    * 日历
    * 天气 + 时钟

### 3.6 启动台

* 保留：Safari、App Store
* 其他都放在两个文件夹中：工具、其他

### 3.7 Safari 偏好设置

* 通用
    * 【取消勾选】下载后打开「安全」文件
* 标签页
    * 标签页布局：紧凑
* 扩展
    * [Vimari](https://github.com/televator-apps/vimari)，VIM快捷键，另在 MAS 中有 Vimlike, Vimkey 可选
    * JSON Peep for Safari （通过 MAS 安装），格式化 JSON 数据
* 高级
    * 智能搜索栏
        * 【勾选】显示完整网站地址
    * 【勾选】在菜单栏中显示「开发」菜单
* 工具栏
    * 显示
        * 【勾选】显示状态栏

### 3.8 词典

* 调整词典及顺序（三指触发翻译时会使用第1项）
    1. 牛津英汉汉英词典（简体中文-英语）
    2. 现代汉语规范词典（简体中文）
    3. 汉语成语词典（简体中文）

### 3.9 Terminal 偏好设置

* 通用
    * 使用描述文件新建窗口: Homebrew
* 描述文件
    * Homebrew （因为前边选了 Homebrew，这里仅配置这一个主题）
        * 设置为默认
        * 文本
            * 字体
                * Andale Mono 18 磅
        * Shell
            * 当 shell 退出时: 关闭窗口

## 四、应用安装

应用软件查找及下载参考 [Awesome Mac](https://github.com/jaywcjlove/awesome-mac)，以下仅列出本人较常用应用

### 4.1 App Store

* [Agenda](https://agenda.com/)
* [Boop](https://apps.apple.com/cn/app/id1518425043?mt=12)
* [CotEditor](https://coteditor.com/)
* [Caffeinated](https://apps.apple.com/cn/app/id1362171212?mt=12)
* [Dingtalk](https://www.dingtalk.com)
* [iWorks](https://www.apple.com/cn/iwork/): Pages, Numbers, Keynote
* [Longshot](https://longshot.chitaner.com/)
* [QQ](http://im.qq.com/macqq/)
* 无线鼠标(Remote Mouse)，手机安装同名软件可以将手机变身为翻页笔
* 屏幕画笔(Screen Brush Ultra)
* [The Unarchiver](http://theunarchiver.com/)
* [WeChat](https://weixin.qq.com/)
* [Xcode](http://developer.apple.com/xcode)
* [XMind](http://www.xmind.net/)
* [宁波上官](https://www.better365.cn/) 有很多优秀的产品

### 4.2 命令行安装

#### Oh My Zsh

* 官方链接：[官网](https://ohmyz.sh/)、[源码](https://github.com/ohmyzsh/ohmyzsh)
* 建议使用国内源改善访问速度，参考本文【附录：开源镜像站】

> **注意**
> 1. 依赖的 omz 插件统一在 Homebrew 维护，参考 [Brewfile](/install/Brewfile) 及 [rc_omz.pre.zsh](/Users/USERNAME/.config/shell/rc_omz.pre.zsh)

#### Homebrew

* 官方链接：[官网](https://brew.sh/)、[源码](https://github.com/Homebrew/homebrew-core)、[cask](https://formulae.brew.sh/cask/)
* 建议使用国内源改善访问速度，参考本文【附录：开源镜像站】
* 通过 [Brewfile](/install/Brewfile) 统一管理 brew 项

> **注意**
> 1. brew 依赖 Xcode Command Line Tools，建议先在命令行执行 `xcode-select --install` 进行安装，虽然 brew 的安装脚本中会检测并自动安装，但我还是习惯先手动把依赖处理好
> 2. Homebrew 的 ARM 版本安装路径在 `/opt/`，X86 版本安装路径为 `/usr/bin/`

### 4.3 字体安装

由于系统默认字体英文与中文宽度非 1:2 （英文宽600，中文宽1000），导致在代码注释中进行中英混排时无法对齐。
所以我在一些代码相关的 App 中（如编辑器、终端工具）中使用了以下字体（目前在用 `Maple-Mono-NF-CN`）：

* [更纱黑体](https://github.com/be5invis/Sarasa-Gothic)，特点：英文字体较窄（英文宽500，中文宽1000）
    * [Gitee镜像](https://gitee.com/mirrors/Sarasa-Gothic)、[TUNA镜像](https://mirrors.tuna.tsinghua.edu.cn/github-release/be5invis/Sarasa-Gothic)
    * [更纱黑体这么多版本，要怎么选？](https://zhuanlan.zhihu.com/p/627059922)
    * [Vscode 等宽字体](https://jqtmviyu.github.io/post/vscode-mono-font/)
    * 推荐 Sarasa-Term-Slab-SC-TTF （带连字/带字体微调/term=半宽破折号/slab=粗衬线体/sc=集成简体中文字形/ttf=单一字形）
* [Maple Mono](https://github.com/subframe7536/maple-font)，特点：中文字体间距较大（英文宽600，中文宽1200）
    * [Gitee镜像](https://gitee.com/subframe7536/Maple)
    * [官网](https://font.subf.dev/) 提供 [在线特性测试](https://font.subf.dev/zh-cn/playground/)
    * 推荐 Maple-Mono-NF-CN-unhinted （带连字/nf=集成[Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)/cn=集成中日文字形/unhinted=无字体微调）


### 4.4 常用软件列表

我常用的软件已经都列在了 [Brewfile](/install/Brewfile) 中了，这里列出主要是想多说些碎碎念。
另外如果希望家目录下的 `~/Applications` 显示中文名，可以在文件夹中创建名为 `.localized` 的文件即可（无需内容）。

* 输入法：除系统自带的输入法外，额外推荐：
    * [RIME](https://rime.im/)，强大的输入法平台，macOS 下叫鼠须管（语出自欧阳修「酌君以荆州鱼枕之蕉，赠君以宣城鼠须之管」）
    * [清歌](https://qingg.im/)，开箱即用，我现在用它
    * [百度输入法](https://srf.baidu.com/input/mac.html)，之前的点讯梅花输入法，且 [RIME 作者也曾就职于此](https://www.ituring.com.cn/article/118072)
* 浏览器：
    * [Microsoft Edge](https://www.microsoft.com/edge)，使用 Edge 是为了方便在国内同步书签
    * [Google Chrome](https://www.google.com/chrome/)
* 启动器：
    * [Tinycast](https://tinycast.dev)，作者用爱(AI)发电，无死角抄 Raycast（甚至支持 Raycast 插件市场），还开源免费，反正我是没把持住
    * [Raycast](https://www.raycast.com/)，免费的 Alfred 不够用，但 Raycast 免费部分足够了
    * [Alfred](https://www.alfredapp.com/)，早期神器，我已经转投 ~~Raycast~~ Tinycast
    * [uTools](http://www.u.tools/)，之前号称 Alfred 国产平替，其实我没用过
* 终端：
    * [iTerm](https://www.iterm2.com)
    * [ghostty](https://ghostty.org/)
* 编辑器：
    * [IntelliJ IDEA](https://www.jetbrains.com/idea/)
    * [Visual Studio Code](https://code.visualstudio.com/)，如果下载慢可[参考此文](https://zhuanlan.zhihu.com/p/536236143)将下载地址域名 `https://az764295.vo.msecnd.net` 换为 `https://vscode.cdn.azure.cn`
* 未归类
    * [Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements)，从系统层面绑定快捷键
    * [Rectangle](https://rectangleapp.com/)，移动+缩放窗口到屏幕指定位置，因 Raycast/Tinycast 自带类似能力，所以目前暂未用到了
    * [Snipaste](https://zh.snipaste.com/)，截图+贴图，目前我已转投 Longshot(MAS)
    * [Floaty](https://www.floatytool.com/)，将任意窗口置顶
    * [draw.io](https://www.drawio.com/)
    * [Fork](https://fork.dev/)
    * [SwitchHosts](https://github.com/oldj/SwitchHosts)
    * [DB Browser for SQLite](https://sqlitebrowser.org/)、[SQLiteStudio](https://github.com/pawelsalawa/sqlitestudio)，SQLite 管理器
    * [Reqable](https://reqable.com/)、[whistle](https://github.com/avwo/whistle)、[Charles Proxy](https://www.charlesproxy.com/)，抓包及代理工具
    * [Netease Music](https://music.163.com)、[QQ Music](https://y.qq.com/)，因沙箱限制 MAS 版无法使用键盘控制播放，官网下载安装的版本可以
    * [Steam](https://www.steampowered.com/)
    * [OnyX](https://www.titanium-software.fr/en/onyx.html)，Mac 优化工具，同时此开发者还有其他一些 Mac 小工具
    * [BackgroundMusic](https://github.com/kyleneideck/BackgroundMusic)，为每个App设置不同的音量
    * [xbar(bitbar)](https://github.com/matryer/xbar)、[SwiftBar](https://github.com/swiftbar/SwiftBar)，在菜单栏展示自定义脚本内容
    * [ImageOptim](https://imageoptim.com/mac)，图片压缩，[pngquant](https://pngquant.org/) 的 Mac UI 版
    * 如下载 [Oracle JDK](https://www.oracle.com/java/technologies/downloads/) 时不想注册，可以换成 Adobe 的 CDN 链接直接下载，可参考以下地址自行找规律：`https://cfdownload.adobe.com/pub/adobe/coldfusion/java/java8/java8u481/jdk/jdk-8u481-macosx-aarch64.dmg`。当然我已经转投 brew+temurin，没用 [SDKMAN!](https://sdkman.io/) 是觉得 brew 够用了


## 五、应用配置

下文中依赖的配置文件已经在此 Repo 中提供

### Shell

运行 `install/install.sh shell` 安装 Bash/Zsh 配置，包括 `.zshenv`、`.zprofile` 、`.zshrc`、`.bash_profile`、`.bashrc` 及 `.config/shell/` 下的分层配置。

配置按加载时机分为 env / path / rc 三层，命名规则、层约束、私人配置示例等详见 [.config/shell/README.md](./Users/USERNAME/.config/shell/README.md)。

* Git: `install/install.sh git`，链接 `.config/git/` 目录；私人配置参考 `.config/git/private_config.example`
* SSH: `install/install.sh ssh`，复制 `.ssh/config` 文件
* Node & NPM: `install/install.sh node`，链接 `.config/npm/` 目录；若已装 fnm 则同时安装 Node LTS 与全局 npm 包（清单见 [install/npm-packages.txt](./install/npm-packages.txt)，内容没变则跳过）
* Python & PyPI: `install/install.sh python`，链接 `.config/pip/` 目录；若已装 uv 则同时安装最新版 Python
* Ruby & Gem: `install/install.sh ruby`，链接 `.config/gem/gemrc`
* Bin: `install/install.sh bin`，将 `.local/bin/` 下的实用脚本链接到 `~/.local/bin`

> 完整模块列表（含 `karabiner`、`ghostty`、`brew` 等）请运行 `install/install.sh --list` 查看，各自的详细配置见下文对应小节。

> 部分模块的安装项（npm 全局包、IDEA 插件等）放在 [install/](./install) 下的清单文件里，格式说明写在各文件头部；增删条目只需要改清单，不必动 shell 脚本。清单内容变化后才会重新执行安装（哈希记录在 `~/.local/state/my-mac-env/`），用 `install/install.sh --status` 还可以反查仓库里有没有未被任何模块认领的路径。

#### SSH

* 运行 `install/install.sh ssh`，会将 `.ssh/config` 复制到 `~/.ssh/config`
* 使用 `ssh-keygen` 生成针对每个站点的 SSH key
* 编辑 `~/.ssh/config` 文件分别指向刚才生成的密钥
* 在相应站点配置公钥

#### Nginx

* 复制 `./opt/homebrew/etc/nginx` 目录
* 根据实际需要编辑 `nginx.conf` 文件，其中有较详细的注释
* 如需要支持 https，使用 `gen-ssl-csr.sh` 生成证书

### Vim & MacVim

* 运行 `install/install.sh vim`，链接 `.config/vim/` 目录
* 配置文件位于 `~/.config/vim/vimrc`，运行时文件（viminfo、undo、swap、backup）统一存放在 `~/.local/state/vim/` 下

#### Vundle

* 安装 [Vundle](https://github.com/VundleVim/Vundle.vim)
* 编辑 `~/.config/vim/vimrc` 文件，选择需要的插件
* 通过 Vundle 安装插件：`:PluginsInstall`
* 由于我已不再使用 Vim 开发，目前把 `vimrc` 中的插件都注释掉了

#### MacVim

> 从 macOS 12 开始系统自带的 vim 已经 `+clipboard`，如果不使用图形界面就不需要额外安装 MacVim 了

* 配置 MacVim 可在命令行启动：`ln -s ~/Applications/MacVim.app/Contents/bin/mvim /usr/local/bin/mvim`
    * 注意 `/usr/local/bin` 需要安装了 brew 后才会有
* 偏好设置
    * General
        * After last window closes => Quit MacVim

### Karabiner-Elements

运行 `install/install.sh karabiner`，会将 `.config/karabiner/karabiner.json` 复制到 `~/.config/karabiner/karabiner.json`（目标已存在则跳过，不覆盖）。Karabiner 会写回配置文件，如有更新请手动同步回仓库。

> 一些备忘
>
> **键位写法约定**:
> 修饰键之间用 `+` 连接且不加空格（如 `CONTROL+OPTION+SHIFT`），修饰键（组）与被触发的实键之间的 `+` 两侧加空格（如 `MehKey + H`、`LEFT_CONTROL + H/J/K/L`），多个可选实键用 `/` 分隔
>
> **关于 `karabiner.json`**:
> 我通过 Karabiner 把物理 CONTROL 与 CAPS_LOCK 互换（`simple_modifications`），不常用的 CAPS_LOCK 键当 CONTROL 用；互换后的物理 CONTROL 键再映射成 CONTROL+OPTION+SHIFT（`complex_modifications`），**后续如果看到键位是 `MehKey` 或 `MEH_KEY` 即表示此组合键**
> - Karabiner 会先应用 `simple_modifications` 再应用 `complex_modifications`，上面两步是串联依赖：complex 规则的 `from` 写的是 `caps_lock`，但它命中的是已被 simple 换过来的物理 CONTROL 键。净效果是 物理 CONTROL 键 → MehKey、物理 CAPS_LOCK 键 → CONTROL
> - 配置内含三个 profile：`full-featured`（当前选中，含下列全部规则）、`simple`（仅保留 CONTROL 与 CAPS_LOCK 互换）、`empty`（不做任何修改，排查问题时可临时切过去）
> - `LEFT_CONTROL + H/J/K/L` 映射为方向键 左/下/上/右，任何应用内都能用 vim 式移动。该规则带 `meh_key_pressed` 变量条件，MehKey 按下期间不生效，避免 `MehKey + H/J/K/L` 被它抢先处理
> - `LEFT_CONTROL + P/N` 映射为方向键 上/下，同样带 `meh_key_pressed` 条件
> - `RIGHT_SHIFT` 单击切换输入法（ABC ↔ 系统自带五笔，走 `select_input_source` 原生 API）
> - 两条 `[65% Keyboard]` 规则仅对 Keychron K6（vendor 1452 / product 591）生效：`COMMAND + ESC` → `COMMAND + ~`、`SHIFT + ESC` → `~`，弥补 65% 键盘没有独立的 `~` 键
>
> 一些历史配置留档（已从配置文件中移除）:
> - *CAPS_LOCK to COMMAND+CONTROL+OPTION+SHIFT*: 替换为 CONTROL+OPTION+SHIFT 三键，原因是 `COMMAND+CONTROL+OPTION+SHIFT + .` 快捷键由内核 HID 层直接判定（不走 symbolic hotkeys），无法通过 Karabiner 覆盖，改为三键组合可规避误触问题
> - *COMMAND+SHIFT+OPTION+CONTROL + Period/Comma to f17/f18*: 原因同上一条。[Apple 社区讨论](https://discussions.apple.com/thread/254787050)也认为这两个 chord 应视为被 macOS 保留（reserved to macOS）
>
> 小知识
> - *COMMAND+CONTROL+OPTION+SHIFT + .*: 触发系统诊断（sysdiagnose），生成系统全量快照，一般需要几分钟，产物约几百 MB，路径为 `/private/var/tmp`
> - *COMMAND+CONTROL+OPTION+SHIFT + ,*: 触发回溯诊断（tailspin，原意是飞机快速旋转坠落的状态），可用 `sudo tailspin enable/disable` 开启/关闭，系统默认关闭。启用后会有服务常驻后台循环记录进程调用栈，按快捷键后产物是按键前 20s 的回溯采样，用于排查无复现规律的问题
> - 人们一般将 `COMMAND(WIN)+CONTROL+OPTION(ALT)+SHIFT` 称为 `HyperKey`，把 `CONTROL+OPTION(ALT)+SHIFT` 称为 `MehKey`（Meh 意为 一般般、将就、尚可，MehKey 即表达「虽不如 HyperKey 但也够用的键」）
>    - 为什么 MehKey 去掉的是 `COMMAND(WIN)` 而非其他键：因为 `COMMAND(WIN)` 被称为 GUI 键，即它与操作系统绑定较深，当涉及菜单快捷键时会被优先考虑，导致它的键组合更容易产生冲突（`COMMAND` 绑定了大量 macOS 系统能力、`WIN` 看名字就知道和 Windows 扯不清瓜葛）
>    - 相比之下各操作系统和知名软件在定义快捷键时一般会避开 MehKey 组合，它确实更不容易冲突
>    - MehKey 只是社区约定并无强制约束，你也可以改成其他键组合

### iTerm2

* General
    * Closing
        * 【勾选】Quit when all windows are closed
    * Selection
        * 【取消勾选】Copy to pasteboard on selection
* Appearance
    * General
        * Theme: `Minimal`
    * Tabs
        * 【勾选】Show tab bar even when there is only one tab
        * 【取消勾选】Tabs have close buttons
        * 【取消勾选】Stretch tabs to fill bar
* Profiles - **Default**
    * General
        * Title
            * 勾选：`Session Name`, `Job Name`
        * Icon
            * 【选中】Built-in Icon from Current App
        * Initial Directory
            * 【选中】Reuse previous session's directory
    * Colors
        * Modes
            * 【取消勾选】Use separate colors for light and dark mode
        * Color Presets
            * 【选中】Solarized Dark
                * 这个配色下目录颜色有些浅，可以通过修改 Cyan 的 Bright 颜色来解决（比如 `#99ffff`）
        * Cursor Guide
            * 【选中】Use cursor guide _高亮光标所在行_
    * Text **_如果已经按照【4.4 字体安装】方案安装了字体_**
        * Font
            * `Maple Mono NF CN`, `Regular`, `18pt`
            * 【勾选】Use Ligatures _启用连字_
    * Text **_如果未额外安装字体_**
        * Font
            * `Monaco`, `Regular`, `18pt`
        * Non-ASCII Font
            * 【勾选】Use a different font for non-ASCII text
            * `PingFang SC`(苹方-简), `Regular`, `18pt`
    * Terminal
        * Scrollback lines
            * 【勾选】Unlimited scrollback
* Profiles - **Floaty** _(将 Default 配置好后复制一份并命名为 Floaty)_
    * _此配置用于浮动窗口（快捷终端），与 **Default** 相同的配置不再重复描述_
    * Window
        * New Windows
            * Style: `Full-Width Top of Screen`
    * Keys
        Hotkey window
            * 【勾选】A hotkey opens a deciceted window with this profile _唤起快捷终端_
            * Configure Hotkey window
                * Hotkey: `MehKey + O`
                * 【取消勾选】Floating window
                * On Dock icon click: `Show this Hotkey Window if no other window is open`
* Keys
    * Hotkey
        * 【勾选】Show/hide all windows with a system-wide hotkey: `MehKey + I`
* 菜单栏
    * iTerm2
        * Make iTerm2 Default Term

### 输入法

#### Rime

[Rime](https://rime.im) 输入法引擎对有特殊输入诉求的人非常友好，虽然我作为普通话+冀鲁官话使用者暂无特殊诉求，但 Rime 这个优秀方案仍然值得尝试。

安装共分两大步骤：
1. 安装 Rime 输入法引擎，可以去[官网下载页](https://rime.im/download/)下载对应平台安装包
2. 安装对应的输入方案，可以使用 [东风破](https://github.com/rime/plum) 或自己用 git 下载方案到配置目录

#### 输入方案

经过我个人实践，推荐两款输入方案：

* [oh-my-rime](https://github.com/Mintimate/oh-my-rime)，囊括了大部分社区优秀输入方案，包括全拼、双拼、五笔86、五笔98等
* [极点五笔输入配置方案](https://github.com/KyleBing/rime-wubi86-jidian)，我在 Windows 下最喜欢的就是极点五笔了

以下为自己用 git 下载方案配置目录的步骤：

```bash
# 1. 进入 Rime 鼠须管 配置目录（输入法中添加了鼠须管才会有此路径）
cd ~/Library/Rime
# 2. 将当前目录初始化为 git 仓库（因为路径不为空，不能直接 git clone）
git init
# 3. 设置输入方案 git 地址
git remote add origin git@github.com:KyleBing/rime-wubi86-jidian.git
# 4. 获取 master 最新代码
git fetch origin master --depth=1
# 5. 检出 master 分支代码到本地
git checkout -t origin/master
```

最后记得点击状态栏鼠须管图标，并「重新部署」使配置生效

### Microsoft Edge

* 登录 MSN 账号，配置已同步
* 关闭本地网络访问弹窗
    * 设置 - 隐私、搜索和服务 - 站点权限 - 所有权限 - 本地网络访问： 关闭
    * 进 `edge://flags` 把 `Local Network Access Checks` 项禁用

### Google Chrome

* 【勾选】退出前提示
* 登录 Google 账，配置已同步

### Raycast

* General
    * Raycast HotKey: `Command + Space`
    * Window Model: Compact
* Extensions
    * Clipboard History
        * Clipboard History: Hotkey: `Command + Control + C`
    * Quicklinks，可直接导入 [raycast-quicklinks.json](./assets/raycast-quicklinks.json) 文件
        * 并按个人习惯配置对应的 Alias
    * Snippets，可直接导入 [raycast-snippets.json](./assets/raycast-snippets.json) 文件
        * Search Snippets: Hotkey: `Command + Control + S`
    * Window Management
        * Maximize: HotKey: `MehKey + Enter`
        * Next Display: HotKey: `MehKey + M`
        * Restore: HotKey: `MehKey + \`
* Raycast AI:
    * Custom Providers
        * 运行 `install/install.sh raycast`，会将 `providers.yaml` 复制到 `~/.config/raycast/ai/providers.yaml`，自行配置 API Key 及模型等信息
    * Experiments
        * 【勾选】Custom Providers _开启自定义提供商能力_
* Account: 登录一下
* Advanced
    * Show Raycast on: Screen with active window
    * Navigation Bindings: Vim Style
* 常用插件
    * [Battery Health](https://www.raycast.com/o1y/battery-health)，查看电池状态
    * [Easy Dictionary](https://www.raycast.com/isfeng/easydict)，翻译
    * [iHosts](https://www.raycast.com/JinShi/ihosts)，hosts 管理
    * [Refresh Wifi](https://www.raycast.com/natterstefan/refresh-wifi)，刷新网络，切换 hosts 后快速生效

### Visual Studio Code

> VSCode 由 [Brewfile](./install/Brewfile) 中的 `cask "visual-studio-code"` 与 `vscode` 插件声明安装；配置复制与 key-repeating 开启由 [install.sh](./install/install.sh) 的 vscode 模块负责。

* 配置 VSCode 可在命令行启动：[Launching from the Command Line](https://code.visualstudio.com/docs/setup/mac#_launch-vs-code-from-the-command-line) （通过 Brew 安装会自动提供命令行能力，就无需自己搞了）
* 运行 `install/install.sh vscode`，会将 `settings.json` 和 `keybindings.json` 复制到 `~/Library/Application Support/Code/User/`，并开启 key-repeating
* 常用插件：
    * EditorConfig for VS Code: 自动应用 .editorconfig 配置
    * GitLens — Git supercharged: 非常强大的 Git 工具
    * TODO Highlight: 高亮指定关键字
    * Vim: Vim 模拟器
        * key-repeating（长按触发按键重复）已由 vscode 模块开启：`defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false`（参考 [官网文档](https://github.com/VSCodeVim/Vim#mac)）

### IntelliJ IDEA

* IDEA 由 [Brewfile](/install/Brewfile) 中的 `cask "intellij-idea"` 安装，该 cask 附带 command wrapper，装完 `idea` 命令即在 PATH 中，无需再手动执行 【Tools - Create Command-line Launcher...】
* 配置项在 [.../JetBrains/README.md](./Users/USERNAME/Library/Application%20Support/JetBrains/README.md) 中有明细
* 有几个项目配置是保存在具体项目的 `.idea` 目录下的，对应的配置可以通过复制 `Users/USERNAME/Library/Application Support/JetBrains/project.default.xml` 文件快速设置
* 推荐插件也在 [.../JetBrains/README.md](./Users/USERNAME/Library/Application%20Support/JetBrains/README.md) 中，其中实际纳入自动安装的是 [install/idea-plugins.txt](./install/idea-plugins.txt) 里列出的那几个
* 第三方插件: 运行 `install/install.sh idea`，通过 `idea installPlugins` 安装。注意该命令是 IDE 启动阶段的能力，执行前需完全退出 IDEA，且没有 `--force`，装完要重启才生效。清单没变时会自动跳过，增删插件改 [install/idea-plugins.txt](./install/idea-plugins.txt) 后重跑即可
* IdeaVim: 配置链接由 idea 模块随插件安装一并完成（`install/install.sh idea`），链接 `.config/ideavim/ideavimrc` 到 `~/.config/ideavim/ideavimrc`；链接排在插件安装之前，IDE 未装/运行中跳过插件时 ideavimrc 照常就位
* IntelliJ IDEA Ultimate 包含了 JetBrains 大部分产品能力，可参考 [Intellij IDEA has "exactly" the same functionality as webstorm as far as web is concerned?](https://intellij-support.jetbrains.com/hc/en-us/community/posts/207054055) 和 [Can IntelliJ IDEA encapsulate all of the functionality of WebStorm and PHPStorm through plugins?](https://stackoverflow.com/questions/13827214)。具体差异可以通过 [JetBrains Products Comparison](https://www.jetbrains.com/products/compare/) 页面进行对比查看。所以理论上有了 IDEA Ultimate 就不需要再安装 WebStorm、PHPStorm、PyCharm 等产品了。

### Xcode

* Preferences
    * Text Editing
        * Display
            * Show
                * 【勾选】Code folding ribbon
        * Editing
            * Reformat code at columns: 80
                * 【勾选】Show reformatting guide
            * While Editing
                * 【勾选】Including whitespcing-only lines
* Editor
    * 【勾选】Vim Mode (自从 v13 开始，Xcode 原生提供了 Vim Mode)
    * 【勾选】Invisibles

### Fork

* General
    * Default Source Folder: workspaces
* Integration
    * Terminal Client: iTerm2
    * Merge Tool: VSCode
    * External Diff Tool: VSCode
* Updates
    * Update channel: Stable(delayed 1 week)

### Rectangle

导入 [rectangle-config.json](./assets/rectangle-config.json) 文件

### 百度输入法

* 同步
    * 登录账号，以下配置可在登录账号后通过「下载配置」直接应用
* 常用
    * 状态指示：只勾选「浮动提示」和「QuickTip」
    * 【勾选】中文时使用成对符号（需要添加辅助功能授权）
* 按键
    * 翻页按键：只勾选「减号等号」
    * 切换按键：取消所有勾选
* 五笔
    * 【取消勾选】开启五笔调频
* 词库
    * 删除所有分类词库
    * 删除默认个性短语，重新导入 [baidu-ime-phrase.txt](./assets/baidu-ime-phrase.txt)
* QuickTip
    * 仅保留「表情/符号」
* 高级
    * 不启用「自动切换英文」
    * 不启用「翻译选中文本」

## 六、私人信息

以下目录或软件中可能存在私人信息，可能未体现在上述列表中，记得备份旧数据。

* etc/hosts
* Shell
    * `~/.config/shell/private*` 中的配置
* Git
    * `~/.config/git/private*` 中的配置
* SSH
    * 如需保留之前的密钥，需要备份 `~/.ssh` 目录下的文件
    * 注意私钥的文件权限应该是 `600`
* Nginx
    * `nginx.conf` 中的私人配置
* Raycast
    * 一些私人 quicklinks
    * 一些私人 snippets
* 输入法
    * Rime 词库： `~/Library/Rime/` 下的某些文件（与实际使用的输入方案有关）

## 七、附录

### 开源镜像站

因为众所周知的原因，在使用 github/pip/npm 等官方服务时速度不理想，前述多项配置涉及切换镜像源，这里简单列一下:

#### 企业

* [阿里云](https://developer.aliyun.com/mirror/)
* [腾讯云](https://mirrors.cloud.tencent.com/)
* [网易](http://mirrors.163.com/)
* [火山引擎(字节)](https://developer.volcengine.com/mirror/)
* [华为云](https://mirrors.huaweicloud.com/)

#### 高校

* [清华大学 TUNA](https://mirrors.tuna.tsinghua.edu.cn/)
* [北京外国语大学 BFSU](https://mirrors.bfsu.edu.cn/)
* [中国科学技术大学 USTC](https://mirrors.ustc.edu.cn/)
* [上海交通大学 SJTU](https://mirror.sjtu.edu.cn/)
* [南京大学 NJU](https://mirrors.nju.edu.cn/)
* [浙江大学 ZJU](https://mirrors.zju.edu.cn/)
* [重庆大学 CQU](https://mirrors.cqu.edu.cn/)

#### 专项

* [npmmirror](https://npmmirror.com/)
* RubyChina 的 [Ruby](https://ruby-china.org/wiki/ruby-mirror) 和 [Gems](https://gems.ruby-china.com/)
