# Java & Maven

## Java
## 当安装了多个 Java 版本时，可以通过修改最后的版本号实现切换版本
export JAVA_HOME=$(/usr/libexec/java_home -v 25)
export PATH="$JAVA_HOME/bin:$PATH"
