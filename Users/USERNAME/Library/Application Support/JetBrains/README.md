# Intellij IDEA 配置

Intellij IDEA Ultimate 版本可以通过插件很好的支持前端业务的开发，当开发语言主要是 Java + JavaScript 时，可以只依赖一个编辑器即可。

以下配置即同时考虑了 Java 和 JavaScript 的开发。如果你的配置页面没有对应项目，大概率是没有启用对应插件导致的。

## 全局配置

### 说明

全局配置应用于所有项目，相关配置备份在 `GlobalSettings` 中，可将其中的文件复制到对应的配置路径：

+ Ultimate 版路径为 `$USER_HOME$/Library/Application Support/JetBrains/IntellijIdea{版本号}`
+ Community 版路径为 `$USER_HOME$/Library/Application Support/JetBrains/IdeaIC{版本号}`

其中：

+ 快捷键以 Idea 默认的 macOS 为基础，被命名为 `keymaps/macOS-mz.xml`
+ 对于 IdeaVim 插件，除了 `options/vim_settings.xml` 外，注意还有家目录下的 `.ideavimrc`

### 配置细则

* Appearance & Behavior
  * Appearance
    * Tool Windows
      * [ ] Show tool window bars _是否显示工具栏_
  * System Settings
    * Project
      * Open project in: `New window`
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
* Keymap
  * Main Menu
    * Window
      * Editor Tabs
        * Split and Move Right: `option+l`(`alt+l`) _在右侧新建窗口组并将标签移动过去_
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
      * Java
        * [x] Add unambiguous imports on the fly _自动 import 无歧义的类_
      * TypeScript / JavaScript
        * [x] Unambiguous imports on the fly _自动 import 无歧义的类_
    * Appearance
      * [x] Show method separators _展示方法分隔线_
      * [x] Show whitespaces _展示空白字符_
    * Editor Tabs
      * Appearance
        * [x] Mark modified (*) _被修改的文件 Tab 上用星号 * 标记_
      * Opening Policy
        * [x] Enable preview tab _启用预览窗口（单击文件时复用同一个预览 Tab，多次单击不同文件不会打开多个 Tab，双击文件独占一个 Tab）_
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
      * Spaces
        * Within
          * [x] Object literal braces _对象大括号内加空格_
          * [x] ES6 import/export braces _ES6 在 import/export 的大括号内加空格_
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
  * Inspections
    * Profile: `Default` _将 Inspections 配置保存到 IDE，就不需要每个项目都设置一遍了_
  * File and Code Templates
    * Includes
      * File Header _文件头信息_
  * TODO
    * Patterns _TODO关键字高亮正则_
      * `\b(todo|fixme)\b.*`
      * `\b(xxx|note|warning|bug|mock|debug)\b`
* Build, Execution, Deployment
  * Trusted Locations _信任的路径_
    * `$USER_HOME$/workspace/repos`
  * Debugger
    * Remove breakpoint:
      * [x] Drag to the editor or click with middle mouse button _通过拖拽或鼠标右键点击删除断点_
      * [x] Confirm removal of conditional or logging breakpoints _删除带表达式或日志配置的断点时需要确认_
* Tools
  * Shared Indexes
    * Public Shared Indexes _下载共享索引，减少项目打开时间_
      * JDKs: `Download automatically`
      * Maven Libraries: `Download automatically`

## 项目配置

### 说明

项目配置仅会应用在具体项目中，在 Idea 配置面板中会提示 **For new projects** 或 **For current project**， 相关配置备份在 `ProjectSettings` 中，可将其中的文件复制到项目根目录的 `.idea` 路径下。

NOTE 1: 从 2022.3 开始，Idea 可以通过全局配置的 `project.default.xml` 文件自动生成项目配置，所以只要提前把文件复制好，下边的配置就无需再每个项目配置一遍了。

NOTE 2: `dictionaries` 目录下是项目级字典，文件名默认是登录用户的名字，复制后需要修改，同时也要修改文件中的 `name` 值。另外这个目录貌似在 2022.3 中已经失效了。

### 配置细则

* Editor
  * Inspections
    * JVM languages
      * [x] Serializable class without 'serialVersionUID' _检查 serialVersionUID_
  * File Encodings
    * Properties Files (*.properties)
      * Default encoding for properties files: `UTF-8` _*.properties 文件编码_
      * [ ] Transparent native-to-ascii conversion _转换 UTF-8 字符为转义形式_
* Version Control
  * Commit
    * [x] Clear initial commit message _清空上一次的提交信息_
  * Confirmation
    * When files are created: `Do not add` _新增文件时不自动提交_
* Build, Execution, Deployment
  * Build Tools
    * Maven
      * [x] Always update snapshots _始终更新 SNAPSHOT 包_
  * Compiler
    * Annotation Processors
      * [x] Enable annotation processing _开启注解处理_
* Languages & Frameworks
  * Spring
    * Common
      * [x] Allow to auto-configure application contexts _自动配置 Spring_
* Breakpoints _Breakpoints配置_
  * Java Line Breakpoints
    * Suspend: `Thread`
  * Java Exception Breakpoints
    * Suspend: `Thread`
* Project Window _项目窗口配置，点击右上角齿轮图标进行配置_
  * Tree Appearance
    * [x] Sort by Type _文件列表按类型排序（先按类型再按名称）_

## 插件

编辑器自带插件非常全，根据实际情况选择禁用部分插件，可以适当提高编辑器的性能。
