#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="system"
rp_module_desc="install all my usual extra programs and extra THIS IS A TEST FOR FIRST INSTALL"
rp_module_help=""
rp_module_licence=""
rp_module_section="extras"
rp_module_flags="!all x86"

function depends_system() {
    getDepends software-properties-common
    add-apt-repository -y ppa:libretro/stable
    add-apt-repository -y ppa:papirus/papirus
    add-apt-repository -y ppa:transmissionbt/ppa
    add-apt-repository -y ppa:musicbrainz-developers/stable
    add-apt-repository -y ppa:lutris-team/lutris

}

function install_bin_system() {
    
    aptInstall obs-studio neofetch ubuntu-restricted-extras ubuntu-restricted-addons fonts-hack fonts-opendyslexic steam-installer gnome-tweak-tool gnome-tweaks handbrake samba samba-common nfs-kernel-server nfs-common dconf-editor  git-extras p7zip-rar unrar gwenview libretro* retroarch*  papirus-icon-theme picard lutris ppa-purge
    snap install code --classic
    snap install get-iplayer
    wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
}

function remove_system() {
    ppa-purge -y ppa:libretro/stable
    ppa-purge -y ppa:papirus/papirus
    ppa-purge -y ppa:transmissionbt/ppa
    ppa-purge -y ppa:musicbrainz-developers/stable
    ppa-purge -y ppa:lutris-team/lutris    
    aptRemove -y obs-studio neofetch ubuntu-restricted-extras ubuntu-restricted-addons virtualbox fonts-hack fonts-opendyslexic steam-installer gnome-tweak-tool gnome-tweaks handbrake samba samba-common nfs-kernel-server nfs-common dconf-editor git-extras p7zip-rar unrar gwenview libretro* retroarch*  papirus-icon-theme picard lutris ppa-purge calibre
    snap remove code
    snap remove get-iplayer
}

function configure_system() {
    get-iplayer --prefs-add --output="/home/$user/Videos"
    get-iplayer --prefs-add --fileprefix="<nameshort><.senum><.episodeshort>"

}
