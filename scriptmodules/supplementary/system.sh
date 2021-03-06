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
rp_module_desc="install all my usual extra PPA's, programs and extra's THIS IS A TEST FOR FIRST INSTALL"
rp_module_help=""
rp_module_licence=""
rp_module_section="core"
rp_module_flags="!all x86"

function depends_system() {
    getDepends software-properties-common
    add-apt-repository -y ppa:libretro/stable
    add-apt-repository -y ppa:papirus/papirus
    add-apt-repository -y ppa:transmissionbt/ppa
    add-apt-repository -y ppa:musicbrainz-developers/stable
    add-apt-repository -y ppa:lutris-team/lutris
    if [[ "$__os_id" == "Ubuntu" ]] ; then
        wget -q -O - http://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc | sudo apt-key add -
        add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian $__os_codename non-free contrib"
    fi
       if [[ "$__os_codename" == "ulyana" ]] ; then
        wget -q -O - http://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc | sudo apt-key add -
        add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian focal non-free contrib"
    fi
}

function install_bin_system() {
    
    aptInstall obs-studio neofetch  fonts-hack fonts-opendyslexic steam-installer handbrake samba samba-common nfs-kernel-server nfs-common dconf-editor  git-extras p7zip-rar unrar gwenview libretro* retroarch*  papirus-icon-theme picard lutris ppa-purge virtualbox dkms snapd breeze-cursor-theme
    snap install code --classic
    snap install get-iplayer
    snap install chromium
    snap install caprine
    wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
    curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
    chmod a+rx /usr/local/bin/youtube-dl
}

function remove_system() {
    ppa-purge -y ppa:libretro/stable
    ppa-purge -y ppa:papirus/papirus
    ppa-purge -y ppa:transmissionbt/ppa
    ppa-purge -y ppa:musicbrainz-developers/stable
    ppa-purge -y ppa:lutris-team/lutris    
    aptRemove -y obs-studio neofetch ubuntu-restricted-extras ubuntu-restricted-addons fonts-hack fonts-opendyslexic steam-installer gnome-tweak-tool gnome-tweaks handbrake samba samba-common nfs-kernel-server nfs-common dconf-editor git-extras p7zip-rar unrar gwenview libretro* retroarch*  papirus-icon-theme picard lutris ppa-purge calibre virtualbox dkms snapd breeze-cursor-theme youtube-dl
    snap remove code
    snap remove get-iplayer
    snap remove chromium
    snap remove caprine
}

function configure_system() {
    get-iplayer --prefs-add --output="/home/$user/Videos"
    get-iplayer --prefs-add --fileprefix="<nameshort><.senum><.episodeshort>"
    usermod -aG vboxusers $user
}
