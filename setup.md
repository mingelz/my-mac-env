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

### 3.3 Safari 偏好设置

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

### 3.4 Terminal 偏好设置

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

### 3.5 系统顶部菜单栏

* 按住 Command 可拖动
* 右向左顺序：时间、控制中心、聚焦搜索、电池、Wifi、输入法

### 3.6 系统 Docker 栏

* 保留：Finder、日历、iPhone镜像、浏览器、iTerm、Editor

### 3.7 系统右侧通知栏

* 根据喜好配置
* 个人配置：
    * 提醒事项
    * 日历
    * 天气 + 时钟

### 3.8 启动台

* 保留：Safari、App Store
* 其他都放在两个文件夹中：工具、其他

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
* iShot/iOCR，[宁波上官](https://www.better365.cn/) 有很多优秀的产品

### 4.2 下载

可以将下载的应用安装在自己的家目录下，此时需要在家目录下创建 `Applications` 文件夹（注意是复数形式），如果要让它显示中文名，在文件夹中创建一个名为 `.localized` 的文件即可（无需内容）。

* 必备
    * [Baidu Input](https://srf.baidu.com/input/mac.html)，之前的梅花点迅输入法。我现在改用系统自带的五笔输入法了，完全够用
    * [Microsoft Edge](https://www.microsoft.com/edge)、[Google Chrome](https://www.google.com/chrome/)、[Arc](https://arc.net/)
* 效率
    * [Raycast](https://www.raycast.com/)、[Alfred](https://www.alfredapp.com/)、[uTools](http://www.u.tools/)，效率工具，个人已倒戈至 Raycast
    * [Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements)，从系统层面绑定快捷键
    * [Rectangle](https://rectangleapp.com/)，移动+缩放窗口到屏幕指定位置
    * [Snipaste](https://zh.snipaste.com/)，截图+贴图，目前我已转投 Longshot
    * [Topit](https://github.com/lihaoyun6/Topit)，将任意窗口置顶
* 生产力
    * [draw.io](https://www.drawio.com/)
    * [Visual Studio Code](https://code.visualstudio.com/)，如果下载慢可将下载地址域名 `https://az764295.vo.msecnd.net` 换为 `https://vscode.cdn.azure.cn` （[参考](https://zhuanlan.zhihu.com/p/536236143)）
    * [IntelliJ IDEA](https://www.jetbrains.com/idea/)
    * [iTerm](https://www.iterm2.com)
    * [Fork](https://fork.dev/)
    * [SwitchHosts](https://github.com/oldj/SwitchHosts)
    * [DB Browser for SQLite](https://sqlitebrowser.org/)、[SQLiteStudio](https://github.com/pawelsalawa/sqlitestudio)，SQLite 管理器
    * [Charles Proxy](https://www.charlesproxy.com/)，商业软件，如果想用免费软件可以尝试 [whistle](https://github.com/avwo/whistle)
    * [JDK](https://www.oracle.com/java/technologies/downloads/)
* 娱乐
    * [Netease Music](https://music.163.com)，因沙箱限制 App Store 版无法使用键盘控制播放，官网下载安装的版本可以
    * [Steam](https://www.steampowered.com/)
* 未归类
    * [OnyX](https://www.titanium-software.fr/en/onyx.html)，Mac 优化工具，同时此开发者还有其他一些 Mac 小工具
    * [BackgroundMusic](https://github.com/kyleneideck/BackgroundMusic)，为每个App设置不同的音量
    * [xbar(bitbar)](https://github.com/matryer/xbar)、[SwiftBar](https://github.com/swiftbar/SwiftBar)，在菜单栏展示自定义脚本内容
    * [ImageOptim](https://imageoptim.com/mac)，图片压缩，[pngquant](https://pngquant.org/) 的 Mac UI 版

### 4.3 命令行安装

#### Brew

> **注意**
> 1. brew 依赖 Xcode Command Line Tools，建议安装 brew 前先安装 Xcode，并在命令行执行 `xcode-select --install` 安装 Xcode Command Line Tools。虽然直接安装 brew 也会安装此依赖，但我个人还是习惯先手动把依赖处理好
> 2. ARM 版本安装路径在 `/opt/`，X86 版本安装路径为 `/usr/bin/`
> 3. 个人不喜欢使用 cask 安装应用，会导致安装目录比较乱，可以通过 cask 查找要安装应用的下载地址后自主下载安装
> 4. 鉴于国内网络环境，可以使用 [Homebrew TUNA 镜像](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/)

* [brew](http://brew.sh/) & [cask](https://formulae.brew.sh/cask/)(已经与 brew 集成，无需额外安装)
    * lame，mp3 编解码、压缩
    * nvm & node
        * 虽然 NVM 官方不推荐使用 brew 安装，但个人仍觉得这是最方便的方式，只需安装后参考给出的提示进行配置（我已在 `~/.bash_profile` 添加）
    * tree

#### Oh My Zsh

> **注意**
> 1. omz 自带的插件，以及手动安装在 omz 插件目录（一般为 `~/.oh-my-zsh/custom/plugins`）的插件，直接在 `~/.zshrc` 的 `plugins=()` 中设置名称即可
> 2. 通过 brew 安装的插件，需要手动 `source` 插件路径，插件会安装在 `/opt/homebrew/share/` 下。个人建议使用 brew 安装，方便维护与升级
> 3. 鉴于国内网络环境，可以使用 [OhMyZsh TUNA 镜像](https://mirrors.tuna.tsinghua.edu.cn/help/ohmyzsh.git/)

* [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
    * [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting.git)，语法高亮插件
    * [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)，命令补全插件

## 五 应用配置

下文中依赖的配置文件已经在此 Repo 中提供

### Shell

* Bash: 复制 `my-mac-env/Users/USERNAME/.bash_profile` 及 `my-mac-env/Users/USERNAME/.bash_profile_private` 文件
* Oh My ZSH：复制 `my-mac-env/Users/USERNAME/.zshrc` 文件
* Git: 复制 `my-mac-env/Users/USERNAME/.gitconfig` 文件，并根据实际情况重新编辑用户信息
* Node & NPM: 复制 `my-mac-env/Users/USERNAME/.cnpmrc` 文件
* Python & PyPI: 复制 `my-mac-env/Users/USERNAME/.config/pip` 目录
* Ruby & Gem: 复制 `my-mac-env/Users/USERNAME/.gemrc` 目录
* 其他: 复制 `my-mac-env/usr/local/bin` 目录，或酌情复制需要的命令

#### SSH

* 复制 `my-mac-env/Users/USERNAME/.ssh` 目录
* 使用 `ssh-keygen` 生成针对每个站点的 SSH key
* 编辑 `~/.ssh/config` 文件分别指向刚才生成的密钥
* 在相应站点配置公钥

#### Nginx

* 复制 `my-mac-env/usr/local/etc/nginx` 目录
* 根据实际需要编辑 `nginx.conf` 文件，其中有较详细的注释
* 如需要支持 https，使用 `gen-ssl-csr.sh` 生成证书

### Vim & MacVim

* 复制 `my-mac-env/Users/USERNAME/.vim` 目录

#### Vundle
* 安装 [Vundle](https://github.com/VundleVim/Vundle.vim)
* 编辑刚复制的 `$HOME/.vim/vimrc` 文件，选择需要的插件（我已不再使用 Vim 开发，目前只安装了 editorconfig 一个插件）
* 通过 Vundle 安装插件：`:PluginsInstall`

#### MacVim
* 从 macOS 12 开始系统自带的 vim 已经 `+clipboard`，如果不使用图形界面就不需要额外安装 MacVim 了
* 配置 MacVim 可在命令行启动：`ln -s ~/Applications/MacVim.app/Contents/bin/mvim /usr/local/bin/mvim`
    * 注意 `/usr/local/bin` 需要安装了 brew 后才会有
* 偏好设置
    * General
        * After last window closes => Quit MacVim

### Karabiner-Elements

复制 `my-mac-env/Users/USERNAME/.config/karabiner` 下的文件。

> 以下快捷键在配置中存在（留做参考），但我实际已不再使用：
>
> * *LEFT_SHIFT enhance*: 留给 IntellijIDEA 的 Search Everywhere 功能使用
> * *CAPS_LOCK to COMMAND + CONTROL + OPTION + SHIFT*: 替换为 CONTROL + OPTION + SHIFT 三键，原因是 `Command+Option+Shift+Control+,` 和 `Command+Option+Shift+Control+.` 两个系统快捷键无法取消，可能会被误按
> * *Map Command-Shift-Option-Control-Period to f17 (avoid System Diagnostics)*: 绑定不成功，参考[这里](https://discussions.apple.com/thread/254787050)
> * *Map Command-Shift-Option-Control-Comma to f18 (avoid System Diagnostics View)*: 绑定不成功，原因同上
> * *Map Command-Shift-Option-Control-w to f17 (avoid Wifi Diagnostics)*: 绑定不成功，原因同上

### iTerm2

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
        * Initial Directory
            * 【选中】Reuse previous session's directory
    * Colors
        * Color Presets
            * 【选中】Solarized Dark。这个配色下目录颜色有些浅，可以通过修改 Cyan 的 Bright 颜色来解决（比如 `#99ffff`）
        * Cursor Guide
            * 【选中】Use cursor guide
    * Text
        * Font
            * Monaco, Regular, 18pt
            * 【勾选】Use a different font for non-ASCII text
        * Non-ASCII Font
            * PingFang SC (苹方-简), Regular, 18pt
    * Window
        * Settings for New Windows。新开窗口的大小，默认的略小
            * Columns: 100
            * Rows: 28
    * Terminal
        * Scrollback Buffer
            * 【勾选】Unlimited scrollback
    * Keys
        * Key Mappings
            * `Sent ^[[1;5D`: `^b` ，使用 Control+b 向后（左）移动一个单词
            * `Sent ^[[1;5C`: `^f` ，使用 Control+f 向前（右）移动一个单词
            * 额外的，默认配置中一些有用的快捷键：
                * `^a`: 移动到行首
                * `^e`/`^k`: 移动到行尾
                * `^d`: 删除光标下的字符
                * `^w`: 向后（左）删除一个单词
                * `^q`/`^u`: 清空当前行
                * `^t`: 交换最后两个字母
* Keys
    * Hotkey
        * 【勾选】Show/hide all windows with a system-wide hotkey: Control+Option+Shift+Command+I
* 菜单栏
    * iTerm2
        * Make iTerm2 Default Term

### Microsoft Edge

* 登录 MSN 账号，配置已同步

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
    * Quicklinks，可直接导入 `my-mac-env/Users/USERNAME/backup/raycast-quicklinks.json` 文件
        * Search Google: `https://www.google.com/search?q={query}`, Alias: `gg`
        * Search Bing Global: `https://global.bing.com/search?q={query}`, Alias: `bg`
        * Search Bing CN: `https://cn.bing.com/search?q={query}`, Alias: `bc`
        * Search Baidu: `https://www.baidu.com/s?wd={Query}`, Alias: `bd`
        * 百度翻译（英译中）: `https://fanyi.baidu.com/#en/zh/{query}`, Alias: `bdtc`
        * 百度翻译（中译英）: `https://fanyi.baidu.com/#zh/en/{query}`, Alias: `bdte`
        * DeepL（英译中）: `https://www.deepl.com/translator#en/zh/{query}`, Alias: `dltc`
        * DeepL（中译英）: `https://www.deepl.com/translator#zh/en/{query}`, Alias: `dlte`
        * MVN Repository: `https://mvnrepository.com/search?q={query}`, Alias: `mvn`
        * NPM Package: `https://www.npmjs.com/package/{query}`, Alias: `npm`
        * NPM Mirror Package: `https://npmmirror.com/package/{query}`, Alias: `cnpm`
        * RunKit: `https://npm.runkit.com/{query}`, Alias: `rk`
    * Snippets，可直接导入 `my-mac-env/Users/USERNAME/backup/raycast-snippets.json` 文件
        * Search Snippets: Hotkey: `Command + Control + S`
        * date: `{date "yyyy-MM-dd"}`
        * datetime: `{datetime "yyyy-MM-dd HH:mm:ss"}`
    * Window Management
        * Maximize: HotKey: `Control + Option + Shift + Enter`
        * Next Display: HotKey: `Control + Option + Shift + M`
        * Restore: HotKey: `Control + Option + Shift + \`
* Raycast AI: 先关闭吧
* Account: 登录一下
* Advanced
    * Show Raycast on: Screen with active window
    * Navigation Bindings: Vim Style
* 常用插件
    * [Battery Health](https://www.raycast.com/o1y/battery-health)，查看电池状态
    * [Easy Dictionary](https://www.raycast.com/isfeng/easydict)，翻译
    * [iHosts](https://www.raycast.com/JinShi/ihosts)，hosts 管理

### Visual Studio Code

* 配置 VSCode 可在命令行启动：[Launching from the Command Line](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line)
* 复制 `my-mac-env/Users/USERNAME/Library/Application\ Support/Code/User/` 下的文件
* 常用插件：
    * EditorConfig for VS Code: 自动应用 .editorconfig 配置
    * GitLens — Git supercharged: 非常强大的 Git 工具
    * TODO Hightlight: 高亮指定关键字
    * Vim: Vim 模拟器
        * 安装后开启 key-repeating 能力: `defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false` （参考 [官网文档](https://github.com/VSCodeVim/Vim#mac)）

### IntelliJ IDEA

* 配置 IDEA 可在命令行中启动：打开应用点击 【Tools - Create Command-line Launcher...】
* 配置项在 `my-mac-env/Users/USERNAME/Library/Application Support/JetBrains/README.md` 中有明细
* 有几个项目配置是保存在具体项目的 `.idea` 目录下的，对应的配置可以通过复制 `my-mac-env/Users/USERNAME/Library/Application Support/JetBrains/project.default.xml` 文件快速设置
* IdeaVim 配置在 `my-mac-env/Users/USERNAME/.ideavimrc`，复制到家目录下即可
* 常用插件：
    * Alibaba Java Coding Guidelines: [阿里巴巴代码规约](https://github.com/alibaba/p3c)
    * Chinese (Simplified) Language Pack/中文语言包: 建议新手安装，快速熟悉编辑器
    * Easy Code Screenshots: 根据选中的代码生成截图
    * GenerateAllSetter: 快速生成实例的全部 Setter 方法
    * GitToolBox: 在每行代码后追加 Git Blame 信息
    * IdeaVim: Vim 模拟器，对于 Vimer 无论用哪个编辑器，第一个要装的都是它
    * Maven Helper: 查看 Maven 依赖树，在排查依赖冲突时很有用
    * MyBatisCodeHelperPro: 更强大的 mybatis 插件，我买了收费版（最近用 mybatis-plus，不怎么手搓 sql，到期后就没再续），单纯的 xml/mapper 跳转可以用其他免费插件，比如 MyBatisX
    * Rainbow Brackets: 每级括号使用不同颜色，此插件也支持变量颜色（或使用 Rainbow Variable 专门处理变量）
    * SpotBugs: 可以分析出当前项目或文件中潜在的问题
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

导入 `my-mac-env/Users/USERNAME/backup/rectangle-config.json` 文件

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
    * 删除默认个性短语，重新导入 `my-mac-env/Users/USERNAME/backup/baidu-ime-phrase.txt`
* QuickTip
    * 仅保留「表情/符号」
* 高级
    * 不启用「自动切换英文」
    * 不启用「翻译选中文本」

## 六 私人信息

以下目录或软件中可能存在私人信息，可能未体现在上述列表中，记得备份旧数据。

* etc/hosts
* Bash
    * `~/.bash_profile_private` 中的配置
* SSH
    * 如需保留之前的密钥，需要备份 `~/.ssh` 目录下的文件
    * 注意私钥的文件权限应该是 `600`
* Nginx
    * 一些 `nginx.conf` 的路径配置
* Raycast
    * quicklinks
    * snippets
