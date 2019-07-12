#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-play"
rp_module_desc="Play emulator - PS2 (arm optimised) port for libretro"
rp_module_help="ROM Extensions: .bin .cue .cbn .img .iso \n\nCopy your ps2 roms to $romdir/ps2\n\nCopy the required BIOS file SCPH1001.BIN to $biosdir"
rp_module_licence="https://raw.githubusercontent.com/libretro/Play-/master/License.txt"
rp_module_section=""

function depends_lr-play() {
    local depends=(cmake libalut-dev)
    
    getDepends "${depends[@]}"
}

function sources_lr-play() {
    gitPullOrClone "$md_build" https://github.com/libretro/Play-.git
}

function build_lr-play() {
    mkdir build
    cd build
    cmake .. -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/opt/qt56/
    cmake --build .
    md_ret_require="$md_build/play!_libretro.so"
}

function install_lr-play() {
    md_ret_files=(
        'AUTHORS'
        'ChangeLog.df'
        'COPYING'
        'play!_libretro.so'
        'NEWS'
        'README.md'
        'readme.txt'
    )
}

function configure_lr-play() {
    local def
        def=1
        mkRomDir "ps2"
        ensureSystemretroconfig "ps2"
        addEmulator 1 "$md_id" "ps2" "$md_inst/libretro.so"
        addSystem "ps2"
        addBezel "ps2"

    

}
