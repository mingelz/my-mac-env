# Intellij IDEA 配置

从 2025.3 开始，Intellij IDEA 不再区分 Ultimate 和 Community 版本，只有一个安装包，通过订阅付费来提供高级功能。且部分原属于 Ultimate 版本的功能（如 Spring Boot 等）也无需付费即可使用。

Intellij IDEA 可以通过插件（大部分支持前端的插件需要付费）很好的支持前端业务的开发，当开发语言主要是 Java + JavaScript(JS/ES/TS) 时，可以只依赖一个编辑器即可。以下配置同时考虑了 Java 和 JavaScript 的开发场景。如果你的配置页面没有对应项目，大概率是没有启用对应插件导致的。

配置文件存储路径： `$USER_HOME$/Library/Application Support/JetBrains/IntellijIdea{版本号}`


## 配置细则

说明：️🛄 表示对应配置为项目级，仅会应用于具体项目中。从 2022.3 开始，Idea 可以通过全局配置的 `project.default.xml` 文件自动生成项目配置，所以只要提前配置好就无需为每个项目配置一遍了。

* Appearance & Behavior
  * Appearance
    * UI Options
      * [x] Compact mode _紧凑模式_
    * Tool Windows
      * [ ] Show tool window bars _是否显示工具栏_
  * System Settings
    * Project
      * [ ] Reopen projects on startup _启动时打开关闭前的项目_
      * Open project in: `New window` _在新窗口打开项目_
    * Autosave
      * [ ] Save files when switching to a different application or a built-in terminal _是否自动保存文件_
      * [ ] Back up files before saving _修改前是否备份文件_
  * Notifications
    * Plugin suggestings available _推荐插件_
      * `No Pupup`
      * [ ] Show in tool window
    * Recommended language plugin available _本地化语言插件推荐_
      * `No Pupup`
      * [ ] Show in tool window
  * Trusted Locations _信任的路径_
    * `$USER_HOME$/workspace/repos`
* Keymap
  * Main Menu
    * Window
      * Editor Tabs
        * Split and Move Right: `option+l`(`alt+l`) _在右侧新建窗口组并将标签移动过去_
  * Tool Window
    * Terminal: `option+1`(`alt+1`) _切换 Terminal 窗口的显示隐藏_
  * Other
    * Tabs
      * Move To Opposite Group: `option+m`(`alt+m`) _将标签移动到另一窗口组_
      * Open In Opposite Group: `option+o`(`alt+o`) _将标签在另一窗口组打开（原窗口组中的保留）_
* Editor
  * General
    * Rich-Text Copy
      * [ ] Copy as rich text _复制代码时是否包含富文本信息_
    * On Save
      * [ ] Keep trailing spaces on caret line _保存文件时是否保留光标所在行的末尾空白字符_
      * [x] Remove trailing blank lines at the end of saved files _保存文件时是否移除文件末尾多余的空行-
      * [x] Ensure every saved file ends with a line break _保存文件时是否文件末尾要有一个换行_
    * Auto Import
      * XML
        * [ ] Show auto-import tooltip _编辑pom文件时因依赖较多容易卡住_
      * Java
        * [x] Add unambiguous imports on the fly _自动 import 无歧义的类_
      * TypeScript / JavaScript
        * [x] Unambiguous imports on the fly _自动 import 无歧义的类_
    * Appearance
      * [x] Show method separators _展示方法分隔线_
      * [x] Show whitespaces _展示空白字符_
    * Code Folding
      * Java
        * [ ] One-line methods _不自动折叠只有一行的方法体_
    * Editor Tabs
      * Appearance
        * [x] Show pinned tabs in a separate row _将所有PIN住的Tab单独放在一行_
        * [x] Mark modified _被修改的文件 Tab 上用星号 * 标记_
      * Opening Policy
        * [x] Enable preview tab _启用预览窗口（单击文件时复用同一个预览 Tab，多次单击不同文件不会打开多个 Tab，双击文件独占一个 Tab）_
    * Smart Keys
      * Markdown
        * Lists
          * [x] Renumber list when typing _自动更新列表序号_
  * Code Editing
    * Highlight on Caret Movement
      * [x] Current scope _高亮当前层级的缩进线_
  * Font
    * Size: `18` _编辑器字体大小_
  * Color Schema
    * Schema: `Darcula` _颜色主题方案_
  * Code Style
    * General
      * Visual guides: `80,120` _列号辅助线位置_
    * Java
      * Wrapping and Braces
        * Method declaration parameters: `Chop down if long` _方法定义参数过多时换行，且每个参数一行_
        * Chained method calls: `Chop down if long` _链式调用过多时换行，且每个链一行_
        * 'if()' statement
          * [x] 'else' on new line _else 前换行_
        * 'do ... while()' statement
          * [x] 'while' on new line _while 前换行_
        * 'try' statement
          * [x] 'catch' on new line _catch 前换行_
          * [x] 'finally' on new line _finally 前换行_
      * Code Generation
        * Comment Code
          * [ ] Line comment at first column _行注释从行首开始，如果反选则从第一个非空位置开始_
          * [x] Add a space at line comment start _行注释后跟一个空格_
            * [x] Enforce on reformat _格式化代码时调整注释格式_
          * [ ] Block comment at first column _块注释从行首开始，如果反选则从第一个非空位置开始_
    * HTML
      * Other
        * Spaces
          * [x] In empty tag _在空标签结束斜线前加空格，如 `<br_/>`_
    * JavaScript
      * Spaces
        * Within
          * [x] Object literal braces _对象大括号内加空格_
          * [x] ES6 import/export braces _ES6 在 import/export 的大括号内加空格_
      * Wrapping and Braces
        * Function declaration parameters: `Chop down if long` _方法定义参数过多时换行，且每个参数一行_
        * Chained method calls: `Chop down if long` _链式调用过多时换行，且每个链一行_
        * 'if()' statement
          * [x] 'else' on new line _else 前换行_
        * 'do ... while()' statement
          * [x] 'while' on new line _while 前换行_
        * 'try' statement
          * [x] 'catch' on new line _catch 前换行_
          * [x] 'finally' on new line _finally 前换行_
      * Punctuation
        * `Don't use` semicolon to terminate statement `always`.
          Use `single` quotes `always`.
          Trailling comma: `Add when multiline`
    * TypeScript
      * 与 JavaScript 配置保持一致
  * 🛄 Inspections
    * Profile: `Default` _将 Inspections 配置保存到 IDE，就不需要每个项目都设置一遍了_
    * JVM languages
      * [x] Serializable class without 'serialVersionUID' _检查 serialVersionUID_
  * File and Code Templates
    * Includes
      * File Header _文件头信息，参考 [File Header.java](./File%20Header.java) 文件_
  * 🛄 File Encodings
    * Default encoding for properties files: `UTF-8` _*.properties 文件编码_
      * [ ] Transparent native-to-ascii conversion _将 UTF-8 字符转义保存_
  * Life Templates
    * 我在 [mz_life_templates](./mz_live_templates.xml) 中提供了一些常用模板，可以导入或直接放在 `~/Library/Application Support/JetBrains/IntellijIdea{版本号}/templates` 目录下
  * TODO
    * Patterns _TODO关键字高亮正则_
      * `\b(todo|fixme)\b.*`
      * `\b(xxx|note|warning|bug|mock|debug)\b`
* 🛄 Version Control
  * Commit
    * [x] Clear initial commit message _清空上一次的提交信息_
  * Confirmation
    * When files are created: `Do not add` _新增文件时不自动提交_
* Build, Execution, Deployment
  * 🛄 Build Tools
    * Maven
      * [x] Always update snapshots _始终更新 SNAPSHOT 包_
  * 🛄 Compiler
    * Annotation Processors
      * [x] Enable annotation processing _开启注解处理_
  * Debugger
    * Remove breakpoint:
      * [x] Confirm removal of conditional or logging breakpoints _删除带表达式或日志配置的断点时需要确认_
    * Data Views
      * [x] Sort values alphabetically _数据排序展示_
* Languages & Frameworks
  * JavaScript
    * Code Quality Tools
      * ESLint
        * [x] Automatic ESLint configuration _自动启用ESLint配置_
  * Markdown
    * Default layout: `Editor` _.md文件默认只显示编辑页_
* Advanced Settings
  * Startup
    * [ ] Open README.md file if there are no open files on project startup _项目启动时如无其他需打开的文件则默认打开 README.md_
* Project Structure for New Projects （未打开项目时按 Command+; 唤出）
  * Project Settings
    * Project
      * SDK: `选择新项目默认JDK`
* 🛄 Project Window _项目窗口配置，点击右上角齿轮图标进行配置。（无法在设置界面直接访问，可直接复制 [project.default.xml](./project.default.xml) 文件中的对应内容）_
  * Tree Appearance
    * [x] Sort by Type _文件列表按类型排序（先按类型再按名称）_
* 🛄 Breakpoints _断点配置（无法在设置界面直接访问，可直接复制 [project.default.xml](./project.default.xml) 文件中的对应内容）_
  * Java Line Breakpoints
    * Suspend: `Thread`
  * Java Exception Breakpoints
    * Suspend: `Thread`

## 插件

### 自带插件

编辑器默认启用了所有自带插件，禁用掉不需要的插件可以适当提升性能。
以下是我开启的自带插件（基于 2025.3）：

* AI-Powered
* Build Tools
  * Artifacts Repository Search _(被 Maven 依赖)_
  * Maven
* Database
  * Database Tools and SQL
* Deployment
  * Docker _提供 `Dockerfile` 文件语法高亮支持_
* HTML and XML
  * HTML Tools
* IDE Localization
* IDE Settings
  * EditorConfig
  * Java IDE Customization
  * JetBrains OS Integration
* JavaScript Frameworks and Tools
  * JavaScript and TypeScript
  * React
  * Vue.js
* JVM Frameworks
  * AOP Pointcut Language _支持方法/类与对应切面的相互跳转_
  * Jakarta EE Platform _(被 Spring Web 依赖)_
  * Jakarta EE: Web/Servlets _(被 Spring Web 依赖)_
  * JVM Microservices Frameworks
  * Lombok
  * Spring _(Spring Web 依赖)_
  * Spring Boot _支持通过 `@Resource`/`@Autowired` 图标跳转对应依赖_
  * Spring Web _与 Endpoints, HTTP Client 组合，可以支持通过 Web 路径搜索对应方法_
* JVM Tools
  * Java Bytecode Decompiler
  * Java Internationalization
  * Java Stream Debugger
* Keymap
* Kotlin Frameworks
* Languages
  * Java
  * JSON
  * JSONPath _(被 Http Client 依赖)_
  * Markdown
  * Properties
  * Shell Script
* Local AI/ML Tools (一些第三方 AI 插件可能会与下列插件冲突，此时可以关闭下列插件)
  * Full Line Code Completion
  * Machine Learning Code Completion
* Microservices
  * Endpoints _(见 Spring Web 说明)_
  * HTTP Client _(见 Spring Web 说明)_
* Platform Development
* Remote Development
* Style Sheets
  * CSS
  * Less
* Template Languages
  * Thymeleaf
* Test Tools
  * JUnit
* Version Controls
  * Git
* Other Tools
  * Images
  * Groovy Live Templates _(被 Spring Web 依赖)_
  * Terminal

### 独立插件

* AceJump: 快速跳转，按 Control+; 启动，连续输入看到的字符，插件会显示对应快捷键
* ~~Alibaba Java Coding Guidelines: [阿里巴巴代码规约](https://github.com/alibaba/p3c)~~，负责人离职，许久未更新
* Chinese (Simplified) Language Pack/中文语言包: 仅建议新手安装，快速熟悉编辑器
* Easy Code Screenshots: 根据选中的代码生成截图
* GenerateAllSetter: 快速生成实例的全部 Setter 方法
* GitToolBox: 在每行代码后追加 Git Blame 信息
* IdeaVim: Vim 模拟器，对于 Vimer 无论用哪个编辑器，第一个要装的都是它
* Maven Helper: 查看 Maven 依赖树，在排查依赖冲突时很有用
* MultiHighlight: 多个关键字同时高亮
* MyBatisCodeHelperPro: 更强大的 mybatis 插件，我买了收费版（最近用 mybatis-plus，不怎么手搓 sql，到期后就没再续），单纯的 xml/mapper 跳转可以用其他免费插件，比如 MyBatisX
* Rainbow Brackets: 每级括号使用不同颜色，此插件也支持变量颜色（或使用 Rainbow Variable 专门处理变量）
* SpotBugs: 可以分析出当前项目或文件中潜在的问题

### IdeaVim 配置

安装 IdeaVim 插件后，记得复制 `my-mac-env/Users/USERNAME/.ideavimrc` 文件

### GitToolBox 配置

* Version Control
  * GitToolBox
    * General
      * [ ] Show 'Git Stat' in status bar
      * [ ] Show 'Changed' in status bar
      * [ ] Show Project View decoration _在项目名称后追加Git信息_
      * [ ] Show promotional information
      * Behind tracker
        * [ ] Behind tracker
    * Auto Fetch _自动fetch_
      * [ ] Auto fetch () minutes
      * [ ] Auto fetch on branch switch
    * Commit
      * Commit Message Validation
        * [x] Check pattern match _提交信息时校验格式_
        * Validate Pattern
          * [x] Dot all _.也匹配换行_
        * Pattern: `(?:fix|chore|docs|feat|refactor|style|test|wip)(?:\(.*\))?: .*`
        * Test Input:
        ```
        fix: 修复问题
        换行信息
        ```
    * Blame
      * [ ] Show 'Blame' in status bar _在状态栏添加当前行Blame信息_
    * Branch
      * Outdated Branches Cleanup _自动清理分支_
        * [ ] Auto cleanup () hours
