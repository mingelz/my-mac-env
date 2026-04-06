# Python & pip & uv

# 通过修改为国内镜像源提高国内访问速度
# * 阿里云源：https://developer.aliyun.com/mirror/pypi
# * TUNA 源：https://mirrors.tuna.tsinghua.edu.cn/help/pypi/
# * USTC 源：https://mirrors.ustc.edu.cn/help/pypi.html

# uv
export UV_INDEX_URL=https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple/
export UV_EXTRA_INDEX_URL=https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple/

## alias
alias python='uv run python'
alias python3='uv run python'

# 另：如果需要针对 pip 安装提速，请复制 ~/.config/pip/pip.conf 文件
