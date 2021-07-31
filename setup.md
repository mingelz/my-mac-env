# Mac 环境安装配置一条龙

2021-02-18

## 一、制作安装盘

* 在 App Store 中搜索最新版的 macOS，并点击「下载」
    * [macOS Big Sur 11.2](https://apps.apple.com/cn/app/macos-big-sur/id1526878132)
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
    * 刚才下载的 macOS 会放在 `/Applications` 目录下，假设文件名为 `Install macOS Catalina.app`
    * 执行：`sudo /Applications/Install\ macOS\ Catalina.app/Contents/Resources/createinstallmedia --volume /Volumes/MyVolume`
        * 如果 macOS 小于 10.14，还需要追加 `--applicationpath /Applications/Install\ macOS\ Catalina.app` 参数
    * 之后会给出提示并需要确认，然后开始制作安装盘
        * 在 `Copying installer files to disk...` 这一步要多等一会儿（和电脑及U盘性能有关，耗时约 30 ~ 70 分钟）
        * 最后会提示 `Copy complete. Done` 表示制作完成

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

* 重启电脑并按住 option 键，在启动菜单中选择刚刚制作的U盘
* 建议整个安装过程联网，否则可能会提示「安装器有效负载签名检查失败」
* 如果需要全新安装，在安装进程进行到「macOS 实用工具」时选择「磁盘工具」，抹掉硬盘上的内容（格式优先选择「APFS」）
* 同样在「macOS 实用工具」选择「全新安装 macOS」开始安装系统
* 安装中会有几次重启，无需干预，整个过程大概 10 分钟

## 三、系统设置

以下流程，基于 Big Sur 的设置界面排序，且在安装时已联网并登录 iCloud 账号，所以可能会缺少一些关于 iCloud 的配置细节。

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
        * 【取消勾选】在程序坞中显示最近使用的应用程序
    * 电池
        * 【勾选】显示百分比
    * 时钟
        * 【勾选】使用24小时格式时钟
* Mission Control（调度中心）
    * 【取消勾选】根据最近的使用情况自动重新排列 Space
* Siri
    * 【取消勾选】启用“询问Siri”
    * 【取消勾选】在菜单栏中显示 Siri
* Spotlight（聚焦）
* 语言和地区
    * 时间格式 => 【24小时制】
* 通知
* 互联网账户
    * iCloud
        * 【勾选】除「照片」与「股市」外的其他项
        * iCloud云盘：选项
            * 仅勾选需要的 App
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
    * 【勾选】在菜单栏中显示蓝牙
* 声音
    * 【勾选】在菜单栏中显示音量
* 键盘
    * 键盘
        * 【勾选】将 F1、F2等键用作标准功能键
        * 修饰键
            * 中/英键（大写锁定键） => 【Control】 （个人喜好，请慎重选择）
    * 文本
        * 【取消勾选】自动纠正拼写
        * 【取消勾选】自动大写字词的首字母
        * 【取消勾选】连按两下空格键插入句号
    * 快捷键
        * 根据自己的喜好做修改
        * 可以将 反转颜色 设置为 【⌘Q】。这样当在某些 App 中不小心按了 ⌘Q 时就不至于直接退出应用
    * 听写
        * 快捷键 => 关闭
* 触控板
    * 全部勾选
    * 光标与点按
        * 查询与数据检测器 => 【三指轻点】
    * 更多手势
        * 【取消勾选】在页面之间轻扫
* 鼠标
* 显示器
    * Night Shift（夜览）
        * 设定时间 => 日落到日出
* Sidecar（随航）
* 电池
* 日期与时间
* 共享
    * 修改【电脑名称】（点【编辑】进行修改）
* Apple ID
    * 媒体与购买项目
        * 免费下载 => 【始终不需要】

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
            * 外置磁盘
* 高级
    * 【勾选】显示所有文件的扩展名
    * 将以下位置的文件夹保持在顶部：
        * 【勾选】按名称排序时的窗口中
        * 【勾选】桌面上

### 3.3 系统右侧通知栏

* 根据喜好配置

### 3.4 Safari 偏好设置

* 工具栏
    * 显示
        * 【勾选】显示状态栏
* 高级
    * 智能搜索栏
        * 【勾选】显示完整网站地址
    * 【勾选】在菜单栏中显示「开发」菜单
* 扩展（MAS 里上架的很少，可在[官网](https://safari-extensions.apple.com/)搜索更多）
    * [QRify](https://safari-extensions.apple.com/details/?id=de.retiolum.safari.qrify-RSADU6MKX9)

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
* [MWeb](https://zh.mweb.im/)
* [Pocket](https://getpocket.com/)
* [QQ](http://im.qq.com/macqq/)
* QR Creator Mini
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
    * [Alfred](https://www.alfredapp.com/)
    * [Mubu](https://mubu.com)
    * [Sketch](https://www.sketchapp.com/)
    * Adobe Photoshop
    * Axure
    * Microsoft Office
* 开发
    * [iTerm](http://www.iterm2.com)
    * [MacVim](https://github.com/macvim-dev/macvim/)
    * [Visual Studio Code](https://code.visualstudio.com/)
    * [Atom](https://atom.io/)
    * [IntelliJ IDEA](http://www.jetbrains.com/idea/)
    * [Android Studio](https://developer.android.com/studio/)
    * [JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
    * [SourceTree](https://www.sourcetreeapp.com/)
    * [Charles Proxy](http://www.charlesproxy.com/)
    * [SwitchHosts](https://github.com/oldj/SwitchHosts)
    * [Postman](https://www.getpostman.com)
* 小工具
    * [LICEcap](http://www.cockos.com/licecap/)，录屏
    * [flux](https://justgetflux.com/)，自动调整屏幕亮度及冷暖色
    * [XnViewMP](http://www.xnview.com/en/xnviewmp/)，看图软件
    * [ImageAlpha](http://pngmini.com/)，压缩图片
    * [Rectangle](https://rectangleapp.com/)，移动+缩放窗口到屏幕指定位置
    * [Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements)，从系统层面绑定快捷键
    * [BetterTouchTool](http://bettertouchtool.net/)，触控板增强
    * [Shadowsock](https://shadowsocks.org/)
    * [OnyX](https://www.titanium-software.fr/en/onyx.html)，Mac 优化工具
    * [https://www.irradiatedsoftware.com](https://www.irradiatedsoftware.com)，一个生产各种 Mac 小工具的开发商

### 4.3 命令行安装

个人建议不使用 cask 安装应用，会导致安装目录比较乱，可以通过 cask 查找要安装应用的下载地址后自主下载安装。

**brew 依赖 Xcode，且安装 brew 前要先执行 `xcode-select --install` 安装 Command Line Tools**

* [brew](http://brew.sh/) & [cask](https://formulae.brew.sh/cask/)(已经与 brew 集成，无需额外安装)
    * ~~git~~ (installed with Xcode)
    * lame
    * nginx
    * nvm & node & npm/cnpm
    * tree
    * ~~wget~~ (use curl)
    * [Android File Transfer](https://www.android.com/filetransfer/)
* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* [autojump](https://github.com/wting/autojump)，软件本身是支持 Python@ 和 @3 的，但 brew 上的 autojump 被配置为强制依赖 Python@3.9，而 macOS 最新版自带的是 Python@2.7.16 和 Python@3.8.2，为了不至于再安装第3个 Python，我没有使用 brew 装，而是按照 autojump 官网文档安装的。
    * 建议将 autojump 装在 `~/.autojump/autojump` 中

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
        * Color
            * Cursor Colors
                * 【选中】Cursor guide
        * Text
            * Font
                * Monaco, Regular, 18pt
                * 【勾选】Use a different font for non-ASCII text
            * Non-ASCII Font
                * PingFang SC (苹方-简), Regular, 18pt
        * Terminal
            * Scrollback Buffer
                * 【勾选】Unlimited scrollback
    * 菜单栏
        * iTerm2
            * Make iTerm2 Default Term
* 百度输入法
    * 同步
        * 登录账号，以下配置可在登录账号后通过「下载配置」直接应用
    * 常用
        * 状态指示：只勾选「浮动提示」和「QuickTip」
        * 【勾选】中文时使用成对符号（需要添加辅助功能授权）
    * 按键
        * 翻页按键：只勾选「减号等号」
        * 切换按键：取消所有勾选
    * 词库
        * 删除所有分类词库
        * 关闭个性短语
    * QuickTip
        * 仅保留「表情/符号」
    * 高级
        * 不启用「自动切换英文」
        * 不启用「翻译选中文本」
* MacVim
    * 配置 MacVim 可在命令行启动：`ln -s ~/Applications/MacVim.app/Contents/bin/mvim /usr/local/bin/mvim`
        * 注意 `/usr/local/bin` 需要安装了 brew 后才会有
    * 复制 `my-mac-env/Users/USERNAME/.vim` 目录
    * 安装 [Vundle](https://github.com/VundleVim/Vundle.vim)
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
        * Vim: Vim 模拟器
            * 安装后参考 [官网安装文档](https://github.com/VSCodeVim/Vim#mac) 开启 key-repeating 能力
        * Visual Studio IntelliCode: 微软官方提供的代码提示工具
        * xtemplate (bakso): `.xtpl` 文件语法支持
* Atom
    * 配置 Atom 可在命令行中启动：打开应用点击 【Install Shell Commands】
    * 复制 `my-mac-env/Users/USERNAME/.atom/config.cson` 文件
    * 使用 `apm` 命令安装插件，常用插件：
        * active-power-mode: 装X工具
        * atom-language-xtpl: `.xtpl` 文件语法支持
        * autoclose-html: 自动闭合 HTML 标签
        * docblockr: 自动生成注释文档
        * editorconfig: 自动应用 .editorconfig 配置
        * ex-mode: Vim 的 ex-mode 模式
        * file-icons: 给文件前添加图标
        * language-babel: 使用 Babel 针对 ES6 文件做更专业的语法高亮
        * language-vue: vue 文件语法高亮
        * minimap: 显示代码地图
        * platformio-ide-terminal: 在编辑器中集成 Terminal 终端
        * split-diff: 针对指定文件做 Diff
        * sync-settings: 将配置项同步到个人的 gist 上
        * vim-mode-plus: Vim 模拟器
        * vim-mode-plus-keymaps-for-surround: 支持 Vim 中的 Surround 能力
* IntelliJ IDEA
    * 配置 IDEA 可在命令行中启动：打开应用点击 【Tools - Create Command-line Launcher...】
    * 先启动一次 IDEA，再复制 `my-mac-env/Users/USERNAME/Library/Preferences/Idea` 目录下的文件到对应路径下的 `<PRODUCT><VERSION>` 目录中
    * 编辑器自带插件推荐（除了以下列出的，我都禁用了）：
        * Maven
        * Maven Extension (Ultimate only)
        * Database Tools and SQL (Ultimate only)
        * Java SQL Libraries (Ultimate only)
        * Spring (Ultimate only)
        * Spring Boot (Ultimate only)
        * Markdown
        * Properties
        * Shell Script
        * Lombok (built-in at v2020.3)
        * Git
        * EditorConfig
        * IntelliLang
        * Java Bytecode Decompiler
        * Java Internationalization
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
        * Lombok: 使用注解完成 Getter/Setter，省略大量代码的同时，也降低了后期维护成本
        * Maven Helper: 查看 Maven 依赖树，在排查依赖冲突时很有用
        * MyBatisCodeHelperPro: 更强大的 mybatis 插件，如果上收费版，那就更强了
        * Rainbow Brackets: 彩虹括号，方便肉眼匹配
        * SpotBugs: 可以分析出当前项目或文件中潜在的问题
        * String Manipulation: 各种字符串转换
        * Vue.js: 只在 Ultimate 版才提供，支持 Vue.js 的语法规则
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
