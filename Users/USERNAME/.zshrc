# bash
source "$HOME/.config/shell_profile/bash_base.sh"
source "$HOME/.config/shell_profile/bash_func.sh"

# lang
source "$HOME/.config/shell_profile/lang_java.sh"
source "$HOME/.config/shell_profile/lang_node.sh"
source "$HOME/.config/shell_profile/lang_python.sh"
source "$HOME/.config/shell_profile/lang_ruby.sh"

# util
source "$HOME/.config/shell_profile/util_homebrew.sh"

# private
#source "$HOME/.config/shell_profile/private_homebrew.sh"

# zsh
source "$HOME/.config/shell_profile/zsh_base.sh"
source "$HOME/.config/shell_profile/zsh_plugins.sh"

# ------------------------------------------------------------------------------
# zsh 额外配置
# ...
# ------------------------------------------------------------------------------

# 全部配置完成后，启动 oh-my-zsh
source $ZSH/oh-my-zsh.sh
