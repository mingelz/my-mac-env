if [ `whoami` == "root" ]; then
  echo "\033[31mWARNING: Do NOT run as root!\033[0m"
  exit 1
fi

# clean .DS_Store
sudo find / -name ".DS_Store" -depth -exec rm {} \;

# clean ._ file
sudo dot_clean -m /

# vim
rm -rf ~/.vim/viminfo
rm -rf ~/.vim/undo
mkdir ~/.vim/undo

# shell history
rm -rf ~/.bash_history
rm -rf ~/.zsh_history

# user home
rm -rf ~/.npm_updater.json
rm -rf ~/.npminstall_tarball
rm -rf ~/.oracle_jre_usage
rm -rf ~/.subversion
rm -rf ~/.tnpm_tmp
rm -rf ~/.v8flags*
rm -rf ~/.zcompdump-*

# brew
brew cleanup -n
brew prune -n
