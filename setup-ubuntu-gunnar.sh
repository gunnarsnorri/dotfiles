#!/bin/bash

set -e
set -x

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# INIT
ME=$(who | awk '{print $1}')

# BASICS
su -c "mkdir -p $HOME/tmp $HOME/bin" $ME
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2021.02.02_all.deb keyring.deb SHA256:cccfb1dd7d6b1b6a137bb96ea5b5eef18a0a4a6df1d6c0c37832025d2edaa710
dpkg -i ./keyring.deb
rm ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" >> /etc/apt/sources.list.d/sur5r-i3.list

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

# # YCM
# pushd ~/.vim/bundle/YouCompleteMe
# su -c "git submodule update --init --recursive" $ME
# su -c "./install.py --clang-completer" $ME
# popd

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
pip install --upgrade pip

# # VIVALDI
# wget -qO - http://repo.vivaldi.com/stable/linux_signing_key.pub | sudo apt-key add -
# echo "deb http://repo.vivaldi.com/stable/deb/ stable main" > /etc/apt/sources.list.d/vivaldi.list
# apt update
# apt install vivaldi-stable -y

# SSH
apt install openssh-server -y

# UFW
ufw enable
ufw allow ssh

# OTHER
apt install gimp scrot -y
apt install blueman


echo "Now fix NFS, Davmail, mail, xmpp chat etc..."
