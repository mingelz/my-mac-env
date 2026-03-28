# Ruby & Gem

## 设置 gem 安装目录
### 在 .gemrc 中通过设置 --user-install 将安装目录调整到用户目录，需要在此设置 PATH 保证 bin 文件可以被覆盖到
if which ruby >/dev/null && which gem >/dev/null; then
   PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi
