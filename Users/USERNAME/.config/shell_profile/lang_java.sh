# Java & Maven

## Java
export JAVA_HOME=$(/usr/libexec/java_home -v 21) # 当安装了多个 Java 版本时，可以通过修改最后的版本号实现切换版本
export PATH="$JAVA_HOME/bin:$PATH"

## Maven
export MAVEN_HOME="$HOME/.local/share/apache-maven"
export PATH="$MAVEN_HOME/bin:$PATH"

## Maven Check, ref: https://github.com/AlexisJehan/MvnCheck/
export PATH="$HOME/.local/share/mvn-check/bin:$PATH"
