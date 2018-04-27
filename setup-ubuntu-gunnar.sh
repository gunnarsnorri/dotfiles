#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# INIT
ME=$(who | awk '{print $1}')

# BASICS
su -c "mkdir -p $HOME/tmp $HOME/bin" $ME
echo "deb http://debian.sur5r.net/i3/ $(lsb_release -c -s) universe" > /etc/apt/sources.list.d/i3.list
apt update
apt --allow-unauthenticated install sur5r-keyring
apt update
apt dist-upgrade -y
apt install vim build-essential cmake python-dev python3-dev -y

# git
git config --global push.default simple
git config --global user.email "gunnar.snorri.ragnarsson@gmail.com"
git config --global user.name "Gunnar Snorri Ragnarsson"

# vim
su -c "mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim" $ME
VIMREPOS=" tpope/vim-sensible klen/python-mode ntpeters/vim-better-whitespace Valloric/YouCompleteMe sukima/xmledit"
for VIMREPO in VIMREPOS; do
    su -c "git clone https://github.com/$VIMREPO.git $HOME/.vim/bundle/$(basename $VIMREPO)" $ME
done

# YCM
pushd ~/.vim/bundle/YouCompleteMe
su -c "git submodule update --init --recursive" $ME
su -c "./install.py --clang-completer" $ME
popd

# symbolic links
su -c "ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc" $ME
su -c "ln -s $HOME/dotfiles/.i3 $HOME/.i3" $ME
su -c "ln -s $HOME/dotfiles/.i3blocks.conf $HOME/.i3blocks.conf" $ME

apt install i3 -y
apt install xautolock -y
# Oh My Zsh
apt install zsh -y
chsh -s /bin/zsh $ME
su -c 'sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"' $ME

rm $HOME/.zshrc
su -c "ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc" $ME

apt install i3blocks -y
su -c "git clone https://github.com/Anachron/i3blocks $HOME/i3blocks" $ME
pushd $HOME/i3blocks/blocks
for fullpath in /usr/share/i3blocks/*; do
    su -c "ln -s $fullpath orig-$(basename $fullpath)" $ME
done
su -c "wget https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/volume-pulseaudio/volume-pulseaudio" $ME
chmod a+x volume-pulseaudio
popd


# PIP
apt install python-pip -y
pip install --upgrade pip
pip install virtualenv virtualenvwrapper

# VIVALDI
wget -qO - http://repo.vivaldi.com/stable/linux_signing_key.pub | sudo apt-key add -
echo "deb http://repo.vivaldi.com/stable/deb/ stable main" > /etc/apt/sources.list.d/vivaldi.list
apt update
apt install vivaldi-stable -y

# SSH
apt install openssh-server -y

# UFW
ufw enable
ufw allow ssh

# OTHER
apt install gimp scrot -y



# WORK SPECIFIC
apt install pidgin -y

echo "Now fix NFS, Davmail, mail, xmpp chat etc..."
