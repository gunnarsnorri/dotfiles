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
/usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2018.01.30_all.deb /tmp/keyring.deb SHA256:baa43dbbd7232ea2b5444cae238d53bebb9d34601cc000e82f11111b1889078a
dpkg -i /tmp/keyring.deb
rm /tmp/keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(lsb_release -c -s) universe" > /etc/apt/sources.list.d/i3.list
apt update
apt dist-upgrade -y
apt install vim-gtk3 build-essential cmake python-dev python3-dev python3-pip curl -y

# git
git config --global push.default simple
git config --global user.email "gunnar.snorri.ragnarsson@gmail.com"
git config --global user.name "Gunnar Snorri Ragnarsson"

# vim
su -c "mkdir -p ~/.vim/{autoload,bundle} && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim" $ME
VIMREPOS="tpope/vim-sensible ntpeters/vim-better-whitespace Valloric/YouCompleteMe sukima/xmledit"
for VIMREPO in $VIMREPOS; do
    su -c "git clone https://github.com/$VIMREPO.git $HOME/.vim/bundle/$(basename $VIMREPO)" $ME
done

# Python-mode
su -c "git clone --recursive https://github.com/python-mode/python-mode $HOME/.vim/bundle/python-mode" $ME

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


echo "Now fix NFS, Davmail, mail, xmpp chat etc..."
