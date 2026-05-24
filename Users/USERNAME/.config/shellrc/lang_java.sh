# Java & Maven

## 设置 JAVA_HOME
### 1. 按优先级依次尝试，确认默认版本
for _jdk_ver in 25 21 17 11 8; do
    if /usr/libexec/java_home -v "$_jdk_ver" &>/dev/null; then
        export JAVA_HOME=$(/usr/libexec/java_home -v "$_jdk_ver")
        break
    fi
done
unset _jdk_ver
### 2. 使用第一个命中的版本
if [[ -n "$JAVA_HOME" && ":$PATH:" != *":$JAVA_HOME/bin:"* ]]; then
    export PATH="$JAVA_HOME/bin:$PATH"
fi

## 切换 JDK 版本函数，如 `jdk 8` 即切换到 JDK 8（不带参数显示当前版本）
jdk() {
    if [[ -z "$1" ]]; then
        java -version 2>&1 | head -1
        echo "JAVA_HOME=$JAVA_HOME"
        echo "\nInstalled versions:"
        /usr/libexec/java_home -V 2>&1 | tail -n +2
        return
    fi
    if /usr/libexec/java_home -v "$1" &>/dev/null; then
        export JAVA_HOME=$(/usr/libexec/java_home -v "$1")
        export PATH="$JAVA_HOME/bin:$PATH"
        echo "Switched to JDK $1: $JAVA_HOME"
    else
        echo "JDK $1 not found. Installed versions:"
        /usr/libexec/java_home -V 2>&1 | tail -n +2
    fi
}
