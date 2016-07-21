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
