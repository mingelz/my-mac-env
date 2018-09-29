# Mac 环境安装配置一条龙

2018-09-06

## 制作安装盘

* 在 App Store 中搜索最新版的 macOS，并点击「下载」
* 下载完成后，会弹出安装提示，不要理会
* 找一个大于 8G 的U盘
* 清空磁盘
    * 通过 Spotlight 或 Launchpad 启动「磁盘工具」，并点击「继续」
    * 从左侧的列表中选择插入的U盘，然后选择「抹掉」标签
    * 格式【Mac OS 扩展（日志式）】
    * 磁盘名称【MyVolume】（此名称可随便起，后边会用到）
    * 点击「抹掉」
* 创建安装盘
    * 通过 Spotlight 或 Launchpad 启动「终端」
    * 刚才下载的 macOS 会放在 `/Applications` 目录下，假设文件名为 `Install macOS Mojave.app`
    * 执行：`sudo /Applications/Install\ macOS\ Mojave.app/Contents/Resources/createinstallmedia --volume /Volumes/MyVolume --applicationpath /Applications/Install\ macOS\ Mojave.app`
        * 如果 macOS 大于 10.14，则不再需要 `--applicationpath` 参数
    * 之后会给出提示并需要确认，然后开始制作安装盘
        * 在 `Copying installer files to disk...` 这一步要多等一会儿（和电脑及U盘性能有关，耗时约 30 ~ 70 分钟）
        * 最后会提示 `Copy complete. Done` 表示制作完成

## 系统安装

* 重启电脑并按住 option 键，在启动菜单中选择刚刚制作的U盘
* 建议整个安装过程联网，否则可能会提示「安装器有效负载签名检查失败」
* 如果需要全新安装，在安装进程进行到「macOS 实用工具」时选择「磁盘工具」，抹掉硬盘上的内容（格式优先选择「APFS」）
* 同样在「macOS 实用工具」选择「全新安装 macOS」开始安装系统
* 一定不要应用 FileVault 特性（文件保险箱）
* 安装中会有几次重启，无需干预，整个过程大概 10 分钟

## 系统设置

以下流程，都基于在安装时已联网并登录 iCloud 账号，所以会缺少一些关于 iCloud 的配置细节

### 系统偏好设置

* 通用
    * 最近使用的项目 => 「0」
* Dock（程序坞）
    * 调整 Dock 大小
    * 置于屏幕【左边】
* Mission Control（调度中心）
    * 【取消勾选】根据最近的使用情况自动重新排列 Space
    * Dashboard（仪表盘） 【作为叠层】
* 语言和地区
    * 【24小时制】
* 显示器
    * 显示器
        * 【取消勾选】在菜单栏中显示镜像选项（可用时）
    * Night Shift（夜览）
        * 设定时间 => 日落到日出
* 键盘
    * 文本
        * 【取消勾选】自动纠正拼写
        * 【取消勾选】自动大写字词的首字母
        * 【取消勾选】连按两下空格键插入句号
    * 快捷键
        * 输入法 => 选择上一个输入法【Command + 空格键】
        * 输入法 => 【取消勾选】选择「输入法」菜单中的下一个输入法
        * Spotlight => 显示 Spotlight 搜索【Control + 空格键】
        * Spotlight => 【取消勾选】显示 Finder 搜索窗口
* 触控板
    * 全部勾选
    * 更多手势 => 【取消勾选】在页面之间轻扫
* 声音
    * 【勾选】在菜单栏中显示音量
* iCloud
    * 【勾选】除「照片」与「回到我的 Mac」外的其他项
* App Store（10.13及以下）
    * 【取消勾选】在后台下载新的可用更新
    * 免费下载【存储密码】
* 软件更新（10.14及以上）
    * 高级
        * 【取消勾选】下载可用更新
* 网络
    * 除「Wi-Fi」外，【停用】其他的连接方式（默认还有「蓝牙 PAN」和「Thunderbolt 网桥」）
* 蓝牙
    * 【勾选】在菜单栏中显示蓝牙
* 扩展
    * 【取消勾选】无用的项，特别是「共享菜单」中的项
* 共享
    * 修改【电脑名称】
* 用户与群组
    * 【停用】客人用户
    * 登录项 =>【删除】无用的登录项目
* Siri
    * 【取消勾选】在菜单栏中显示 Siri
* 日期与时间
    * 时钟
        * 【勾选】显示星期几
        * 【勾选】显示日期
* 辅助功能
    * 鼠标与触控板
        * 触控板选项
            * 【勾选】启用拖移【三指拖移】

### Finder 偏好设置

* 通用
    * 【勾选】以下项目
        * 外置磁盘
        * CD、DVD 和 iPod
    * 开启新 Finder 窗口时打开【<家目录>】
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
    * 【勾选】将以下位置的文件夹保持在顶部：按名称排序时的窗口中

### 系统右侧通知栏

* 保留：今天、提醒事项、日历、计算器、明天

### 系统状态栏

* 电池
    * 显示百分比

### Terminal 偏好设置

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

### Safari 偏好设置

* 工具栏
    * 显示
        * 【勾选】显示状态栏
* 高级
    * 智能搜索栏
        * 【勾选】显示完整网站地址
    * 【勾选】在菜单栏中显示「开发」菜单
* 扩展（MAS 里上架的很少，可在[官网](https://safari-extensions.apple.com/)搜索更多）
    * [QRify](https://safari-extensions.apple.com/details/?id=de.retiolum.safari.qrify-RSADU6MKX9)

## 安装应用

安装应用后，对应的要针对每个应用做配置。

### App Store

* [Agenda](https://agenda.com/)
* [Bear](https://bear.app/)
* [Dingtalk](https://www.dingtalk.com)
* [Dr.Cleaner Pro](https://www.drcleaner.com/)
* [Dr.Unarchiver](https://www.drcleaner.com/dr-unarchiver/)
* [Evernote](https://www.evernote.com)
* [iWorks](https://www.apple.com/cn/iwork/)
    * Pages
    * Numbers
    * Keynote
* [Manico](https://manico.im/)
* [Microsoft OneNote](https://www.onenote.com)
* [MWeb](https://zh.mweb.im/)
* [Pocket](https://getpocket.com/)
* [QQ](http://im.qq.com/macqq/)
* [Reeder](http://reederapp.com/)
* [WeChat](https://weixin.qq.com/)
* [Xcode](http://developer.apple.com/xcode)
* [XMind Zen](http://www.xmind.net/)

### 下载

可以将下载的应用安装在自己的家目录下，此时需要在家目录下创建 `Applications` 文件夹（注意是复数形式），如果要让它显示中文名，在文件夹中创建一个名为 `.localized` 的文件即可（无需内容）。

* 输入法
    * [Baidu Input](http://srf.baidu.com/input/mac.html)
    * [Sogou Input](https://pinyin.sogou.com/mac/)
* 网络 & 娱乐
    * [Google Chrome](https://www.google.com/chrome/)
    * [Wangwang](http://wangwang.taobao.com)
    * [Thunder](http://xunlei.com)
    * [Netease Music](http://music.163.com)，App Store 版无法使用键盘控制播放，官网下载安装的版本可以
    * [MplayerX](https://github.com/niltsh/MPlayerX-Deploy/releases)，超强大的播放器，比 App Store 上的版本新
    * [Baidu Netdisk](http://pan.baidu.com)
    * [Steam](https://www.steampowered.com/)
* 生产力
    * [Mubu](https://mubu.com)
    * [Sketch](https://www.sketchapp.com/)
    * Adobe Photoshop
    * Axure
    * Microsoft Office
* 开发
    * [iTerm](http://www.iterm2.com)
    * [MacVim](https://github.com/macvim-dev/macvim/)
    * [Atom](https://atom.io/)
    * [Visual Studio Code](https://code.visualstudio.com/)
    * [IntelliJ IDEA](http://www.jetbrains.com/idea/)
    * [JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
    * [SourceTree](https://www.sourcetreeapp.com/)
    * [Charles Proxy](http://www.charlesproxy.com/)
    * iHosts
* 小工具
    * [LICEcap](http://www.cockos.com/licecap/)，录屏
    * [flux](https://justgetflux.com/)，自动调整屏幕亮度及冷暖色
    * [XnViewMP](http://www.xnview.com/en/xnviewmp/)，看图软件
    * [ImageAlpha](http://pngmini.com/)，压缩图片
    * [BetterTouchTool](http://bettertouchtool.net/)，触控板增强
    * [Shadowsock](https://shadowsocks.org/)

### 命令行安装

建议不使用 cask 安装应用，会导致安装目录比较乱，可以通过 cask 查找要安装应用的下载地址后自主下载安装。

**建议安装 brew 前先执行 `xcode-select --install` 安装 Command Line Tools**

* [brew](http://brew.sh/) & [cask](http://caskroom.io/)(已经与 brew 集成，无需额外安装)
    * autojump
    * nvm & node & npm/cnpm
    * ~~git~~ (installed with Xcode)
    * nginx
    * tree
    * ~~wget~~ (use curl)
    * [Android File Transfer](https://www.android.com/filetransfer/)
* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

### 软件配置

依赖的配置文件已经在此 Repo 中提供

* Google Chrome
    * 【勾选】退出前提示
* Bash & Oh My ZSH
    * 复制 `my-mac-env/Users/USERNAME/.bash_profile` 及 `my-mac-env/Users/USERNAME/.zshrc` 文件
* iTerm2
    * General
        * Closing
            * 【勾选】Quit when all windows are closed
    * Appearance
        * Tabs
            * 【勾选】Show tab bar even when there is only one tab
            * 【取消勾选】Show tab close buttons
    * Profiles
        * General
            * Working Directory
                * 【选中】Reuse previous session's directory
        * Text
            * Font
                * 18pt Monaco
                * 【勾选】Use a different font for non-ASCII text
            * Non-ASCII Font
                * 18pt 苹方-简 常规体
* 百度输入法
    * 同步
        * 登录账号，以下配置可在登录账号后通过「下载配置」直接应用
    * 常用
        * 状态指示：只勾选「浮动提示」和「QuickTip」
    * 按键
        * 翻页按键：只勾选「减号等号」
    * 五笔
        * 五笔基本设置：只取消勾选「开启五笔调频」
    * 词库
        * 删除所有分类词库
        * 关闭个性短语
    * QuickTip
        * 仅保留「表情/符号」
* Atom
    * 配置 Atom 可在命令行中启动：打开应用点击 【Install Shell Commands】
    * 复制 `my-mac-env/Users/USERNAME/.atom/config.cson` 文件
    * 使用 `apm` 命令安装插件，常用插件：
        * active-power-mode
        * atom-language-xtpl
        * autoclose-html
        * docblockr
        * editorconfig
        * ex-mode
        * file-icons
        * language-babel
        * language-vue
        * minimap
        * platformio-ide-terminal
        * split-diff
        * sync-settings
        * vim-mode-plus
        * vim-mode-plus-keymaps-for-surround
* Visual Studio Code
    * 配置 VSCode 可在命令行启动：[Launching from the Command Line](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line)
    * 复制 `my-mac-env/Users/USERNAME/Library/Application\ Support/Code/User/settings.json` 文件
    * 常用插件：
        * Auto Close Tag
        * Auto Rename Tag
        * Bracket Pair Colorize
        * Chinese (Simplified) Language Pack
        * Debugger for Chrome
        * EditorConfig for VS Code
        * GitLens — Git supercharged
        * Prettier - Code formatter
        * Settings Sync
        * Vetur
        * Vim
        * xtemplate
* MacVim
    * 配置 MacVim 可在命令行启动：`ln -s ~/Applications/MacVim.app/Contents/bin/mvim /usr/local/bin/mvim`
        * 注意 `/usr/local/bin` 需要安装了 brew 后才会有
    * 安装 [Vundle](https://github.com/VundleVim/Vundle.vim)
    * 复制 `my-mac-env/Users/USERNAME/.vimrc` 文件
    * 通过 Vundle 安装插件：`:PluginsInstall`，插件已经在 `.vimrc` 中定义
    * 偏好设置
        * General
            * After last window closes => Quit MacVim
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

### 私人信息

以下目录或软件中可能存在私人信息，未体现在上述列表中，记得备份旧数据。

* Bash & Oh My ZSH
    * `~/.bash_profile` 中一些私人配置
* SSH
    * 如需保留之前的密钥，需要备份 `~/.ssh` 目录下的文件
* Nginx
    * 一些 `nginx.conf` 的路径配置
* 其他家目录下的配置文件
* iHosts
