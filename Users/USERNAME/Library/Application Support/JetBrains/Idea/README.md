# Intellij IDEA 配置

## 配置路径

* Ultimate 版在 `JetBrains/IntellijIdea{版本号}` 下
* Community 版在 `JetBrains/IdeaIC{版本号}` 下

## 配置细则

### 通用配置

通用配置即不区分项目的配置，这些均已经在当前目录中各个文件中设置好了，直接将此目录中的文件复制到对应配置路径即可。

另外，文件头部信息配置位置在 `Editor/File and Code Templates/Includes/File Header`。

### 项目配置

在 Idea 配置中显示 **For new projects** 或 **For current project** 的项目，均没有在当前目录列出，统一罗列如下：

* Editor
  * Inspections
    * Java
      * Serialization issues
        * [x] Non-serializable class with 'serialVersionUID'
    * JVM languages
      * [x] Serializable class without 'serialVersionUID'
  * File Encodings
    * Properties Files (*.properties)
      * Default encoding for properties files: `UTF-8`
      * [x] Transparent native-to-ascii conversion
* Version Control
  * Commit
    * [x] Clear initial commit message
    * [x] Force non-empty commit comments
  * Confirmation
    * When files are created: `Do not add`
* Build, Execution, Deployment
  * Build Tools
    * Maven
      * [x] Always update snapshots
* Languages & Frameworks
  * Spring
    * Common
      * [x] Allow to auto-configure application contexts

### 快捷键

快捷键以 Idea 默认的 macOS 为基础，被命名为 `keymaps/macOS-mz.xml`

### 插件

+ `disabled_plugins.txt` 是被禁用的插件项，可通过复制此文件达到直接禁用的效果。
+ 对于 IdeaVim 插件，除了 `options/vim_settings.xml` 外，注意还有家目录下的 `.ideavimrc`
