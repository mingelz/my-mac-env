# Mac 环境安装配置一条龙

2021-02-18

## 一、制作安装盘

* 在 App Store 中搜索最新版的 macOS，并点击「下载」
    * [macOS Monterey 12](https://apps.apple.com/cn/app/macos-monterey/id1576738294)
    * [macOS Big Sur 11](https://apps.apple.com/cn/app/macos-big-sur/id1526878132)
    * [macOS Catalina 10.15](https://apps.apple.com/cn/app/macos-catalina/id1466841314)
* 从 10.14 开始系统安装从 App Store 转到 「系统偏好设置」-「软件更新」中了，点击【现在升级】即可
* 下载完成后，会弹出安装提示，不要理会。可以点击状态栏左上角「安装 macOS」-「退出安装 macOS」关闭安装
* 接下来，根据你的实际情况，选择制作U盘安装盘，还是光盘安装盘

### 1.1 制作U盘安装盘

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

* Intel 版本重启电脑并按住 option 键，在启动菜单中选择刚刚制作的U盘；M1 版本关机后，长按开机键直到显示启动菜单
* 建议整个安装过程联网，否则可能会提示「安装器有效负载签名检查失败」
* 如果需要全新安装，在安装进程进行到「macOS 实用工具」时选择「磁盘工具」，抹掉硬盘上的内容（格式优先选择「APFS」）
* 同样在「macOS 实用工具」选择「全新安装 macOS」开始安装系统
* 安装中会有几次重启，无需干预，整个过程大概 10 分钟

## 三、系统设置

以下流程，基于 Monterey 的设置界面排序，且在安装时已联网并登录 iCloud 账号，所以可能会缺少一些关于 iCloud 的配置细节。

### 3.1 系统偏好设置

* 通用
    * 外观 => 【自动】
    * 最近使用的项目 => 【5】
* 桌面与屏幕保护程序
    * 桌面
        * 动态
* Dock（程序坞与菜单栏）
    * 程序坞与菜单栏
        * 调整 Dock 大小
        * 置于屏幕上的位置 =>【左边】。因为普遍屏幕比较宽，横向位置够用而纵向稀缺
        * 【勾选】自动隐藏和显示程序坞
        * 【取消勾选】在程序坞中显示最近使用的应用程序
    * 电池
        * 【勾选】显示百分比
    * 时钟
        * 【勾选】使用24小时格式时钟
* Mission Control（调度中心）
    * 【取消勾选】根据最近的使用情况自动重新排列 Space
    * 触发角
        * 目前用不到还容易误触，先都取消吧
* Siri
    * 【取消勾选】启用“询问Siri”
    * 【取消勾选】在菜单栏中显示 Siri
* Spotlight（聚焦）
* 语言和地区
    * 时间格式 => 【24小时制】
* 通知与专注模式
    * 允许通知
        * 【取消勾选】当屏幕锁定时
* 互联网账户
    * iCloud
        * 【勾选】除「照片」与「股市」外的其他项
        * iCloud云盘：选项
            * 仅勾选需要的 App
* 密码
* 用户与群组
    * 【停用】客人用户
    * 登录项 =>【删除】无用的登录项目
* 辅助功能
    * 指针控制
        * 触控板选项
            * 【勾选】启用拖移【三指拖移】
* 屏幕使用时间
* 扩展
    * 【取消勾选】无用的项，特别是「共享菜单」中的项
* 安全性和隐私
    * 防火墙
        * 【打开防火墙】
    * 隐私
        * 调整相关软件的隐私策略，特别是在安装并运行软件后，可以在这里 Review
* 软件更新
    * 高级
        * 【取消勾选】下载可用更新
* 网络
    * 除「Wi-Fi」外，【停用】其他的连接方式（默认还有「蓝牙 PAN」和「Thunderbolt 网桥」）
* 蓝牙
* 声音
* 解控ID
* 键盘
    * 键盘
        * 按下Fn键时 => 不执行任何操作。我在输入法中将Fn设置为切换临时拼音，所以就不需要这个键切输入法了
        * 【勾选】将 F1、F2等键用作标准功能键（个人喜好）
        * 修饰键
            * 中/英键（大写锁定键） => 【Control】 （个人喜好，请慎重选择）
    * 文本
        * 【取消勾选】自动纠正拼写
        * 【取消勾选】自动大写字词的首字母
        * 【取消勾选】连按两下空格键插入句号
    * 快捷键
        * 根据自己的喜好做修改，我基本取消了所有勾选项，仅保留：
            * 键盘 - 将焦点移到新窗口：【Command+`】
            * 输入法 - 选择上一个输入法: 【Option+空格】。因为我把 Control 键移到了 Caps_lock 键上，导致原来的快捷键切输入法不方便
            * 辅助功能 - 反转颜色：【Command+Q】。这样当在某些 App 中不小心按了 ⌘Q 时就不至于直接退出应用
    * 听写
        * 快捷键 => 关闭
* 触控板
    * 光标与点按
        * 查询与数据检测器 => 【三指轻点】
        * 【勾选】轻点来点按 => 【单指轻点】
    * 更多手势
        * 【取消勾选】在页面之间轻扫
* 鼠标
* 显示器
    * Night Shift（夜览）
        * 设定时间 => 日落到日出
* 打印机与扫描仪
* Sidecar（随航）
* 电池
* 日期与时间
* 共享
    * 修改【电脑名称】（点【编辑】进行修改）
* 时间机器
* 启动磁盘
* Apple ID
    * 媒体与购买项目
        * 【勾选】使用触控ID购物
        * 免费下载 => 【始终不需要】
* 家人共享

### 3.2 Finder 偏好设置

* 通用
    * 【勾选】以下项目
        * 外置磁盘
        * CD、DVD 和 iPod
    * 开启新 Finder 窗口时打开 => 【<家目录>】
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

### 3.3 系统右侧通知栏

* 根据喜好配置

### 3.4 Safari 偏好设置

* 通用
    * 【取消勾选】下载后打开「安全」文件
* 标签页
    * 标签页布局：紧凑
* 扩展
    * [Vimari](https://github.com/televator-apps/vimari)，VIM快捷键
* 高级
    * 智能搜索栏
        * 【勾选】显示完整网站地址
    * 【勾选】在菜单栏中显示「开发」菜单
* 工具栏
    * 显示
        * 【勾选】显示状态栏

### 3.5 Terminal 偏好设置

* 通用
    * 使用描述文件新建窗口 => Homebrew
* 描述文件
    * Homebrew （因为前边选了 Homebrew，这里仅配置这一个主题）
        * 设置为默认
        * 文本
            * 字体
                * Andale Mono 18 磅
        * Shell
            * 当 shell 退出时 => 关闭窗口

## 四、安装应用

安装应用后，对应的要针对每个应用做配置。

### 4.1 App Store

* [Agenda](https://agenda.com/)
* [Bear](https://bear.app/)
* Boop
* [Cleaner One](https://helpcenter.trendmicro.com/en-us/product-support/cleaner-one/)
* [CotEditor](https://coteditor.com/)
* Caffeinated
* [Dingtalk](https://www.dingtalk.com)
* [Dr.Unarchiver](https://www.drcleaner.com/dr-unarchiver/)
* [Evernote](https://www.evernote.com)、[印象笔记](https://www.yinxiang.com/)
* [iWorks](https://www.apple.com/cn/iwork/)
    * Pages
    * Numbers
    * Keynote
* [Manico](https://manico.im/)
* [Microsoft OneNote](https://www.onenote.com)
* [Pocket](https://getpocket.com/)
* [QQ](http://im.qq.com/macqq/)
* QR Capture
* QR Creator Mini
* QR Journal
* QSpace
* [Reeder](http://reederapp.com/)
* [The Unarchiver](http://theunarchiver.com/)
* [Trello](https://trello.com/)
* [WeChat](https://weixin.qq.com/)
* [WPS Office](http://www.wps.cn/product/wpsmac/)
* [Xcode](http://developer.apple.com/xcode)
* [XMind Zen](http://www.xmind.net/)

### 4.2 下载

可以将下载的应用安装在自己的家目录下，此时需要在家目录下创建 `Applications` 文件夹（注意是复数形式），如果要让它显示中文名，在文件夹中创建一个名为 `.localized` 的文件即可（无需内容）。

* 输入法
    * [Baidu Input](http://srf.baidu.com/input/mac.html)，之前的梅花点迅输入法
    * [Sogou Input](https://pinyin.sogou.com/mac/)
* 网络 & 娱乐
    * [Google Chrome](https://www.google.com/chrome/)
    * [Wangwang](http://wangwang.taobao.com)
    * [Thunder](http://xunlei.com)
    * [Motrix](https://github.com/agalwood/Motrix)，国人开发的下载工具
    * [Baidu Netdisk](http://pan.baidu.com)
    * [Netease Music](http://music.163.com)，因沙箱限制 App Store 版无法使用键盘控制播放，官网下载安装的版本可以
    * [MPlayerX](https://github.com/niltsh/MPlayerX-Deploy/releases)，超强大的播放器，比 App Store 上的版本新
    * [IINA](https://iina.io/)，华人开发的开源免费播放器
    * [Steam](https://www.steampowered.com/)
* 生产力
    * [Alfred](https://www.alfredapp.com/)，竞品有 [Raycast](https://www.raycast.com/)，及国人开发的 [uTools](http://www.u.tools/)
    * [Mubu](https://mubu.com)
    * [Sketch](https://www.sketchapp.com/)
    * Adobe Photoshop
    * Axure
    * Microsoft Office
* 开发
    * [iTerm](http://www.iterm2.com)
    * [MacVim](https://github.com/macvim-dev/macvim/)
    * [Visual Studio Code](https://code.visualstudio.com/)
    * [IntelliJ IDEA](http://www.jetbrains.com/idea/)
    * [JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
    * [SourceTree](https://www.sourcetreeapp.com/)
    * [Charles Proxy](http://www.charlesproxy.com/)，商业软件，如果想用免费软件可以尝试 [whistle](https://github.com/avwo/whistle)
    * [SwitchHosts](https://github.com/oldj/SwitchHosts)
    * [Postman](https://www.getpostman.com)
* 小工具
    * [LICEcap](http://www.cockos.com/licecap/)，录屏
    * [flux](https://justgetflux.com/)，自动调整屏幕亮度及冷暖色
    * [XnViewMP](http://www.xnview.com/en/xnviewmp/)，看图软件
    * [ImageAlpha](http://pngmini.com/)，压缩图片
    * [Rectangle](https://rectangleapp.com/)，移动+缩放窗口到屏幕指定位置
    * [Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements)，从系统层面绑定快捷键
    * [Mos](https://github.com/Caldis/Mos)，鼠标增强，分别处理解控板和鼠标的滚动方向（如果用的罗技鼠标，建议选用官方的[Logi Options](https://www.logitech.com.cn/zh-cn/product/options)，功能更强一些）
    * [Vanilla](https://matthewpalmer.net/vanilla/)，隐藏菜单栏图标
    * [Shottr](https://shottr.cc/)，截屏工具，目前是免费的
    * [BetterTouchTool](https://folivora.ai/)，触控板增强
    * [Better And Better](https://www.better365.cn/bab2.html)，国人开发的触控板增强
    * [SwiftBar](https://github.com/swiftbar/SwiftBar)，在菜单栏展示自定义脚本内容
    * [Shadowsock](https://shadowsocks.org/), [ClashX](https://github.com/yichengchen/clashX)
    * [OnyX](https://www.titanium-software.fr/en/onyx.html)，Mac 优化工具
    * [https://www.irradiatedsoftware.com](https://www.irradiatedsoftware.com)，一个生产各种 Mac 小工具的开发商

### 4.3 命令行安装

个人不喜欢使用 cask 安装应用，会导致安装目录比较乱，可以通过 cask 查找要安装应用的下载地址后自主下载安装。

> **注意**
> 1. **brew 依赖 Xcode，且安装 brew 前要先执行 `xcode-select --install` 安装 Command Line Tools**
> 2. **x86与M1版本安装路径不同**

* [brew](http://brew.sh/) & [cask](https://formulae.brew.sh/cask/)(已经与 brew 集成，无需额外安装)
    * ~~git~~ (installed with Xcode)
    * lame
    * nginx
    * nvm & node & npm/cnpm
    * tree
    * ~~wget~~ (use curl)
    * [Android File Transfer](https://www.android.com/filetransfer/)
* [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
    * omz 的插件建议放在 omz 安装目录下的 `custom/plugins` 中，一般为 `~/.oh-my-zsh/custom/plugins`
    * omz 自带的 z 插件可以完全代替 autojump，所以无需再额外安装 autojump 了，如果实在习惯用 `j` 命令，就加个指向 `z` 的 alias
    * 语法高亮插件 [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting.git)
    * 命令补全插件 [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

### 4.4 软件配置

依赖的配置文件已经在此 Repo 中提供

* Google Chrome
    * 【勾选】退出前提示
    * 登录 Google 账号
* Bash & Oh My ZSH
    * 复制 `my-mac-env/Users/USERNAME/.bash_profile` 及 `my-mac-env/Users/USERNAME/.zshrc` 文件
* iTerm2
    * General
        * Closing
            * 【勾选】Quit when all windows are closed
        * Selection
            * 【取消勾选】Copy to pasteboard on selection
    * Appearance
        * Tabs
            * 【勾选】Show tab bar even when there is only one tab
            * 【取消勾选】Tabs have close buttons
            * 【取消勾选】Stretch tabs to fill bar
    * Profiles
        * General
            * Working Directory
                * 【选中】Reuse previous session's directory
        * Colors
            * Cursor Colors
                * 【选中】Cursor guide
            * Color Presets
                * 【选中】Solarized Dark
                    * 这个本色下目录颜色有些浅，可以通过修改 Cyan 的 Bright 颜色来解决
        * Text
            * Font
                * Monaco, Regular, 18pt
                * 【勾选】Use a different font for non-ASCII text
            * Non-ASCII Font
                * PingFang SC (苹方-简), Regular, 18pt
        * Terminal
            * Scrollback Buffer
                * 【勾选】Unlimited scrollback
    * Keys
        * Hotkey
            * 【勾选】Show/hide all windows with a system-wide hotkey => Control+Options+Shift+Command+I
    * 菜单栏
        * iTerm2
            * Make iTerm2 Default Term
* Karabiner-Elements
    * 复制 `my-mac-env/Users/USERNAME/.config/karabiner` 目录下的文件
* Rectangle
    * 导入 `my-mac-env/Users/USERNAME/backup/rectangle-config.json`
* 百度输入法
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
        * 删除默认个性短语，重新导入 `my-mac-env/Users/USERNAME/backup/baidu-ime-phrase.txt`
    * QuickTip
        * 仅保留「表情/符号」
    * 高级
        * 不启用「自动切换英文」
        * 不启用「翻译选中文本」
* MacVim
    * 配置 MacVim 可在命令行启动：`ln -s ~/Applications/MacVim.app/Contents/bin/mvim /usr/local/bin/mvim`
        * 注意 `/usr/local/bin` 需要安装了 brew 后才会有
    * 安装 [Vundle](https://github.com/VundleVim/Vundle.vim)
    * 复制 `my-mac-env/Users/USERNAME/.vim` 目录
    * 通过 Vundle 安装插件：`:PluginsInstall`，插件已经在 `vimrc` 中定义
    * 偏好设置
        * General
            * After last window closes => Quit MacVim
* Visual Studio Code
    * 配置 VSCode 可在命令行启动：[Launching from the Command Line](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line)
    * 复制 `my-mac-env/Users/USERNAME/Library/Application\ Support/Code/User/` 目录下的文件
    * 常用插件：
        * Auto Close Tag: 自动闭合 HTML 标签，VSCode 自带闭合标签功能，这个工具主要针对非 HTML 文件（比如`.vue`）
        * Auto Rename Tag: 修改 HTML 单侧标签时，自动修改对应的标签
        * Bracket Pair Colorize 2: 彩虹括号，认准 v2 性能更优
        * Chinese (Simplified) Language Pack: 中文简体语言包
        * Debugger for Chrome: 与 Chrome 联调
        * EditorConfig for VS Code: 自动应用 .editorconfig 配置
        * ESLint: 根据项目配置实时检查代码
        * file-icons: 给文件前加更符合文件类型的图标，个人习惯了 Atom 的图标，所以没有用另一个更大众的 vscode-icons
        * GitLens — Git supercharged: 非常强大的 Git 工具
        * Language Support for Java(TM) by Red Hat: Java 语法支持
        * One Dark Pro: Atom 上好看的主题，VSCode 上也可以用上了
        * Partial Diff: 支持各种 Diff 对比
        * PlantUML: 写 PlantUML 时实时预览
        * Markdown Preview Enhanced: 可自定义皮肤的 Markdown 预览
        * Prettier - Code formatter: 格式化代码，可以按照你的 ESLint 配置进行格式化
        * Settings Sync: 将配置项同步到个人的 gist 上
        * TabNine: 强大的代码自动完成工具，感觉不用装 Visual Studio IntelliCode 了
        * TODO Hightlight: 高亮指定关键字
        * Vetur: Vue 文件语法支持、格式化
        * Volar: Vue3 推出后，新推荐的 Vue 文件语法支持插件
        * Vim: Vim 模拟器
            * 安装后参考 [官网安装文档](https://github.com/VSCodeVim/Vim#mac) 开启 key-repeating 能力
        * Visual Studio IntelliCode: 微软官方提供的代码提示工具
        * xtemplate (bakso): `.xtpl` 文件语法支持
* IntelliJ IDEA
    * 配置 IDEA 可在命令行中启动：打开应用点击 【Tools - Create Command-line Launcher...】
    * 先启动一次 IDEA，再复制 `my-mac-env/Users/USERNAME/Library/Preferences/Idea` 目录下的文件到对应路径下的 `<PRODUCT><VERSION>` 目录中
    * 编辑器自带插件推荐（除了以下列出的，我都禁用了）：
        * Maven
        * Maven Extension (Ultimate only)
        * Database Tools and SQL (Ultimate only)
        * AOP Pointcut Language
        * JVM Microservices Frameworks
        * Spring (Ultimate only)
        * Spring Boot (Ultimate only)
        * Markdown
        * Properties
        * Shell Script
        * Lombok (built-in since v2020.3)
        * Git
        * EditorConfig
        * IntelliLang
        * Java Bytecode Decompiler
        * Java Internationalization
        * Shared Project Indexes
        * TextMate Bundles
    * 常用插件推荐：
        * .ignore: 高亮 `.*ignore` 文件、在文件列表中隐藏/显示 ignore 文件等
        * Alibaba Java Coding Guidelines: [阿里巴巴代码规约](https://github.com/alibaba/p3c)
        * Chinese (Simplified) Language Pack: 中文语言包，仅建议纯新手前期安装，后续还是应该使用英文版
        * CodeGlance: 代码 Minimap
        * Free MyBatis Plugin: 在左侧槽中生成 mapper 与 xml 的对应跳转，相比后边介绍的 MyBatisCodeHelperPro 功能比较简单
        * GenerateAllSetter: 快速生成实例的全部 Setter 方法
        * GitToolBox: 在编辑器中实时显示行级 Git 信息，与 VSCode 的 GitLens 插件功能类似
        * GsonFormat: 根据 JSON 生成 Bean
        * IdeaVim: Vim 模拟器，对于 Vimer 无论用哪个编辑器，第一个要装的都是它
        * Lombok: 使用注解完成 Getter/Setter，省略大量代码的同时，也降低了后期维护成本，最新的 IDEA 已经内置了此插件，就不用额外装了
        * Maven Helper: 查看 Maven 依赖树，在排查依赖冲突时很有用
        * MyBatisCodeHelperPro: 更强大的 mybatis 插件，我买了收费版
        * Rainbow Brackets: 彩虹括号，方便肉眼匹配
        * SpotBugs: 可以分析出当前项目或文件中潜在的问题
        * String Manipulation: 各种字符串转换
        * Vue.js: 只在 Ultimate 版才提供，支持 Vue.js 的语法规则
* Alfred
    * General
        * Alfred Hotkey: Command + Space
    * Features
        * Default Results
            * Essentials: 只选 Preferences
            * Fallbacks: 设置兜底搜索 Setup fallback results
        * File Search
            * Navigation
                * Previous Path: 取消快捷键，这个功能不太用的上
        * Universal Actions
            * General
                * Show Actions: 只保留向右箭头
                * Selection Hotkey: 取消快捷键，这个功能不太用的上
        * Web Search
            * 【勾选】Only show enabled searches
            * 根据需要自行配置
        * Web Bookmarks
            * Sources: 勾选需要查询收藏夹的浏览器
        * Clipboard History
            * History
                * Clipboard History: 勾选文本和图片，有效期都是24小时
                * Viewer Hotkey: Control + Command + C
        * Snippets
            * 根据需要自行配置
        * Contacts
            * Contacts
                * 【取消勾选】Open Contacts in Alfred
            * Email
                * 【取消勾选】Email a contact
        * Music
            * General
                * Mini Player: 取消快捷键，取消 Keyword
        * Terminal
            * Application
                * 选择 Custom，将应用名从 `Terminal` 换成 `iTerm2`
    * Apperance
        * 左下角 Options
            * Show Alfred on: active screen 在活动窗口中唤出 alfred，当使用外接屏幕时比较有用
* Nginx
    * 复制 `my-mac-env/usr/local/etc/nginx` 目录
    * 根据实际需要编辑 `nginx.conf` 文件，其中有较详细的注释
    * 如需要支持 https，使用 `gen-ssl-csr.sh` 生成证书
* Node & NPM/xNPM
    * 创建 `~/.nvm` 目录
    * 复制 `my-mac-env/Users/USERNAME/.cnpmrc` 文件
        * 如有其他 xNPM，可根据情况创建各自的配置文件
* Git
    * 复制 `my-mac-env/Users/USERNAME/.gitconfig` 文件，并根据实际情况重新编辑其中的用户信息
* SSH
    * 复制 `my-mac-env/Users/USERNAME/.ssh` 目录
    * 使用 `ssh-keygen` 生成针对每个站点的 SSH key
    * 编辑 `~/.ssh/config` 文件分别指向刚才生成的密钥
    * 在相应站点配置公钥

### 4.5 私人信息

以下目录或软件中可能存在私人信息，未体现在上述列表中，记得备份旧数据。

* Bash & Oh My ZSH
    * `~/.bash_profile` 中一些私人配置
* SSH
    * 如需保留之前的密钥，需要备份 `~/.ssh` 目录下的文件
    * 注意私钥的文件权限应该是 `600`
* Nginx
    * 一些 `nginx.conf` 的路径配置
* hosts
* 其他家目录下的配置文件
