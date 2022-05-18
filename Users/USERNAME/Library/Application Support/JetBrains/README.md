# Intellij IDEA 配置

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
    * Autosave
      * [ ] Save files when switching to a different application or a built-in terminal _是否自动保存文件_
      * [ ] Back up files before saving _修改前是否备份文件_
  * Notifications
    * Recommended language plugin available _本地化语言插件推荐_
    * Plugin suggestings available _插件插件_
* Keymap
  * Split and Move Right: `alt+l` _在右侧新建窗口组并将标签移动过去_
  * Move To Opposite Group: `alt+m` _将标签移动到另一窗口组_
  * Open In Opposite Group: `alt+o` _将标签在另一窗口组打开（原窗口组中的保留）_
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
    * Appearance
      * [x] Show whitespaces _展示空白字符_
    * Editor Tabs
      * Appearance
        * [x] Hide tabs if there is no space _此项无需修改，记下来是因为表述与实际不太相符。勾选后所有 Tabs 都会保留；不勾选则只显示最近 10 条 Tabs_
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
* Tools
  * Shared Indexes
    * Public Shared Indexes _下载共享索引，减少项目打开时间_
      * JDKs: `Download automatically`
      * Maven Libraries: `Download automatically`

## 项目配置

### 说明

项目配置仅会应用在具体项目中，在 Idea 配置面板中会提示 **For new projects** 或 **For current project**， 相关配置备份在 `ProjectSettings` 中，可将其中的文件复制到项目根目录的 `.idea` 路径下。

注意 `dictionaries` 目录下是项目级字典，文件名默认是登录用户的名字，复制后需要修改，同时也要修改文件中的 `name` 值。

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
    * [x] Force non-empty commit comments _不允许提交空信息_
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
  * SQL Dialects _SQL方言配置，打开项目才会看到这个入口_
    * Global SQL Dialect: `MySQL`
    * Project SQL Dialect: `MySQL`
* Breakpoints _Breakpoints配置_
  * Java Line Breakpoints
    * Suspend: `Thread`
  * Java Exception Breakpoints
    * Suspend: `Thread`
* Project Window _项目窗口配置，点击右上角齿轮图标进行配置_
  * Tree Appearance
    * [x] Compact Middle Packages
    * [ ] Show Excluded Files
    * [x] Sort by Type
