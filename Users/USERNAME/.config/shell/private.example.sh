# 私人配置模板
#
# 所有 private* 文件均被 .gitignore 忽略。命名规则、各文件的加载时机与各层约束
# 统一见同目录 README.md（「文件命名规则」「私人配置」「各层注意事项」），此处不再重复。
#


# ------------------------------------------------------------------------------
# private*.env.sh 示例
# ------------------------------------------------------------------------------

## Homebrew 如果使用官方源，建议填入 github token，确保 brew 能够正常更新，参考 https://docs.brew.sh/Manpage
#export HOMEBREW_GITHUB_API_TOKEN=""


# ------------------------------------------------------------------------------
# private*.path.sh 示例
# ------------------------------------------------------------------------------

## Maven Check https://github.com/AlexisJehan/MvnCheck/
#case ":$PATH:" in
#  *":/path/to/mvn-check/bin:"*) ;;
#  *) export PATH="/path/to/mvn-check/bin:$PATH" ;;
#esac
