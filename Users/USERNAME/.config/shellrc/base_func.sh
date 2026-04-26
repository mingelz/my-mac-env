# 一些函数

## grep 时根据窗口宽度自动截断而不换行，在查询大量应用日志时会有帮助
function sgrep {
    tput rmam;
    command grep "$@";
    tput smam;
}
