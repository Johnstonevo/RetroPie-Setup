#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mesen"
rp_module_desc="NES emu - Mesen port for libretro"
rp_module_help="ROM Extensions: .nes .fds .nsf .nsf  .unf\n\nCopy your NES roms t1es\n\nFor the Famicom Disk System copy your roms to $romdir/fds\n\nFor the Famicom Disk System copy the required BIOS file disksys.rom to $biosdir"
rp_module_licence="GPL3 https://raw.githubusercontent.com/SourMesen/Mesen/master/LICENSE"
rp_module_section="exp"
rp_module_flags="!arm x86 "

function depends_lr-mesen() {

    # Additional libraries required for running
    local depends=(libsdl2-dev mono-devel )
    getDepends "${depends[@]}"
}

function sources_lr-mesen() {
    gitPullOrClone "$md_build" https://github.com/SourMesen/Mesen.git
}

function build_lr-mesen() {
    cd Mesen
    make libretro
    md_ret_require="$md_build/mesen_libretro.x64.so"
}

function install_lr-mesen() {
    md_ret_files=(
        'mesen_libretro.x64.so'
    )
}

function configure_lr-mesen() {
  mkRomDir "nes"
  mkRomDir "nesh"
mkRomDir "fds"
mkRomDir "famicom"
ensureSystemretroconfig "nes"
ensureSystemretroconfig "nesh"
ensureSystemretroconfig "fds"
ensureSystemretroconfig "famicom"

addBezel "fds"
addBezel "nes"
addBezel "famicom"

cp -r  $raconfigdir/config/Nestopia $raconfigdir/config/Mesen
chown -R $user:$user $raconfigdir/config/Mesen


addEmulator 0 "$md_id" "nes" "$md_inst/mesen_libretro.x64.so"
addEmulator 0 "$md_id" "nesh" "$md_inst/mesen_libretro.x64.so"
addEmulator 0 "$md_id" "fds" "$md_inst/mesen_libretro.x64.so"
addEmulator 0 "$md_id" "famicom" "$md_inst/mesen_libretro.x64.so"
addSystem "nes"
addSystem "nesh"
addSystem "fds"
addSystem "famicom"




    
}
