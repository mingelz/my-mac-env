# Python & pip & uv

## uv
export UV_INDEX_URL="https://mirror.nju.edu.cn/pypi/web/simple"
export UV_EXTRA_INDEX_URL="https://mirror.nju.edu.cn/pypi/web/simple"

## alias
### 注意: 覆盖 python/python3 后，复杂参数（如 -m venv、-- 分隔参数）可能行为不一致
### 建议日常使用 `uv run python`，需要 venv 等高级功能时直接用完整命令
if command -v uv &>/dev/null; then
    alias python='uv run python'
    alias python3='uv run python'
fi
