if [ `whoami` == "root" ]; then
  echo "\033[31mWARNING: Do NOT run as root!\033[0m"
  exit 1
fi

# clean .DS_Store
sudo find / -name ".DS_Store" -depth -exec rm {} \;

# clean ._ file
sudo dot_clean -m /

# app cache
brew cleanup
#autojump --purge

# HOME - vim
rm -rf ~/.viminfo
rm -rf ~/.vim/viminfo
rm -rf ~/.vim/undo
mkdir ~/.vim/undo

# HOME - shell
rm -rf ~/.bash_sessions
rm -rf ~/.bash_history
rm -rf ~/.zsh_sessions
rm -rf ~/.zsh_history
rm -rf ~/.zcompdump-*

# HOME - node & npm
rm -rf ~/.node-diamond-client-cache
rm -rf ~/.node-gyp
rm -rf ~/.node_repl_history
rm -rf ~/.npm_updater.json
rm -rf ~/.npminstall_tarball
rm -rf ~/.npm
rm -rf ~/.?npm
rm -rf ~/.?npm_tmp
rm -rf ~/.v8flags*

# HOME - misc
rm -rf ~/.oracle_jre_usage
rm -rf ~/.subversion
rm -rf ~/.cache
