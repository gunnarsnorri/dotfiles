#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# INIT
ME=$(who | awk '{print $1}')

# BASICS
echo "deb http://debian.sur5r.net/i3/ $(lsb_release -c -s) universe" > /etc/apt/sources.list.d/i3.list
apt-get update
apt-get --allow-unauthenticated install sur5r-keyring
apt-get update
apt-get dist-upgrade -y
apt-get install vim build-essential cmake python-dev python3-dev -y

# vim
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
su -c "git clone https://github.com/tpope/vim-sensible.git $HOME/.vim/bundle/vim-sensible" $ME
su -c "git clone https://github.com/klen/python-mode.git $HOME/.vim/bundle/python-mode" $ME
su -c "git clone https://github.com/ntpeters/vim-better-whitespace.git ~/.vim/bundle/vim-better-whitespace" $ME
su -c "git clone https://github.com/Valloric/YouCompleteMe ~/.vim/bundle/YouCompleteMe" $ME

# YCM
pushd ~/.vim/bundle/YouCompleteMe
su -c "git submodule update --init --recursive" $ME
su -c "./install.py --clang-completer" $ME
popd

# symbolic links
su -c "ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc" $ME
su -c "ln -s $HOME/dotfiles/.i3 $HOME/.i3" $ME
su -c "ln -s $HOME/dotfiles/.i3blocks.conf $HOME/.i3blocks.conf" $ME

apt-get install i3 -y
apt-get install fonts-font-awesome
# Oh My Zsh
apt-get install zsh -y
chsh -s /bin/zsh $ME
su -c 'sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"' $ME

rm $HOME/.zshrc
su -c "ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc" $ME

apt-get install i3blocks -y
su -c "git clone https://github.com/Anachron/i3blocks $HOME/i3blocks" $ME
pushd $HOME/i3blocks/blocks
for fullpath in /usr/share/i3blocks/*; do
    su -c "ln -s $fullpath orig-$(basename $fullpath)" $ME
done
popd


# PIP
apt-get install python-pip
pip install --upgrade pip
pip install virtualenv virtualenvwrapper

# VIVALDI
wget -qO - http://repo.vivaldi.com/stable/linux_signing_key.pub | sudo apt-key add -
echo "deb http://repo.vivaldi.com/stable/deb/ stable main" > /etc/apt/sources.list.d/vivaldi.list
apt-get update
apt-get install vivaldi-stable


# WORK SPECIFIC
apt-get install gajim
