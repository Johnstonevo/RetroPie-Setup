#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="love"
rp_module_desc="Love - 2d Game Engine"
rp_module_help="Copy your Love games to $romdir/love"
rp_module_licence="ZLIB https://raw.githubusercontent.com/love2d/love/master/license.txt"
rp_module_section="opt"
rp_module_flags="!aarch64"

function depends_love() {
    local depends=(autotools-dev automake libtool pkg-config libfreetype6-dev libluajit-5.1-dev libphysfs-dev libsdl2-dev libopenal-dev libogg-dev libtheora-dev libvorbis-dev libflac-dev libflac++-dev libmodplug-dev libmpg123-dev libmng-dev libjpeg-dev)

    getDepends "${depends[@]}"
}

function sources_love() {
    gitPullOrClone "$md_build" https://github.com/love2d/love
}

function build_love() {
    ./platform/unix/automagic
    local params=(--prefix="$md_inst")

    # workaround for https://gcc.gnu.org/bugzilla/show_bug.cgi?id=65612 on gcc 5.x+
    if isPlatform "x86"; then
        CXXFLAGS+=" -lgcc_s -lgcc" ./configure "${params[@]}"
    else
        ./configure "${params[@]}"
    fi

    make clean
    make
    md_ret_require="$md_build/src/love"
}

function install_love() {
    make install
}

function game_data_love() {
    # get Mari0 1.6.2 (freeware game data)
    if [[ ! -f "$romdir/love/mari0.love" ]]; then
        downloadAndExtract "https://github.com/Stabyourself/mari0/archive/1.6.2.tar.gz" "$__tmpdir/mari0" --strip-components 1
        pushd "$__tmpdir/mari0"
        zip -qr "$romdir/love/mari0.love" .
        popd
        rm -fr "$__tmpdir/mari0"
        chown $user:$user "$romdir/love/mari0.love"
    fi
    # get mrrescue-1.02e.love (freeware game data)
    if [[ ! -f "$romdir/love/mrrescue-1.02e.love" ]]; then
        wget "https://github.com/SimonLarsen/mrrescue/releases/download/1.02e/mrrescue1.02e.love" -O "$romdir/love/mrrescue-1.02e.love"
        chown $user:$user "$romdir/love/mrrescue-1.02e.love"
    fi
    # get sienna-1.0c.love (freeware game data)
    if [[ ! -f "$romdir/love/sienna-1.0c.love" ]]; then
        wget "https://github.com/SimonLarsen/sienna/releases/download/v1.0c/sienna-1.0c.love" -O "$romdir/love/sienna-1.0c.love"
        chown $user:$user "$romdir/love/sienna-1.0c.love"
    fi
     # get 90secondportraits-1.01b.love (freeware game data)
    if [[ ! -f "$romdir/love/90secondportraits-1.01b.love" ]]; then
        wget "https://github.com/SimonLarsen/90-Second-Portraits/releases/download/1.01b/90secondportraits-1.01b.love" -O "$romdir/love/90secondportraits-1.01b.love"
        chown $user:$user "$romdir/love/90secondportraits-1.01b.love"
     fi
}

function configure_love() {
    setConfigRoot ""

    mkRomDir "love"

    addEmulator 1 "$md_id" "love" "$md_inst/bin/love %ROM%"
    addSystem "love"

    [[ "$md_mode" == "install" ]] && game_data_love
}
