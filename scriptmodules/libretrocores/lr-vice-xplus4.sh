#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-vice-plus4"
rp_module_desc="plus4 emulator - port of VICE for libretro"
rp_module_help="ROM Extensions: .crt .d64 .g64 .prg .t64 .tap .x64 .zip .vsf\n\nCopy your Commodore 16 & Plus 4 games to $romdir/plus4"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/vice-libretro/master/vice/COPYING"
rp_module_section="exp"
rp_module_flags=""

function sources_lr-vice-plus4() {
    gitPullOrClone "$md_build" https://github.com/libretro/vice-libretro.git
}

function build_lr-vice-plus4() {
    make -f Makefile.libretro clean
    make EMUTYPE=xplus4
    md_ret_require="$md_build/vice_xplus4_libretro.so"
}

function install_lr-vice-plus4() {
    md_ret_files=(
        'vice/data'
        'vice/COPYING'
        'vice_xplus4_libretro.so'
    )
}

function configure_lr-vice-plus4() {
    mkRomDir "plus4"
    ensureSystemretroconfig "plus4"

    cp -R "$md_inst/data" "$biosdir"
    chown -R $user:$user "$biosdir/data"

    addEmulator 0 "$md_id" "plus4" "$md_inst/vice_xplus4_libretro.so"
    addSystem "plus4"

    if [ -e $md_instcore=/vice_xplus4_libretro.so ]
    then
    addEmulator 0 "$md_id-core" "plus4" "$md_instcore/vice_xplus4_libretro.so"

    fi

}
