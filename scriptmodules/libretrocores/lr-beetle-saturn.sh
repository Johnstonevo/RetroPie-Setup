#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-beetle-saturn"
rp_module_desc="Saturn emulator - Mednafen Saturn port for libretro"
rp_module_help="ROM Extensions: .chd .cue\n\nCopy your Saturn roms to $romdir/saturn\n\nCopy the required BIOS files sega_101.bin / mpr-17933.bin to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/beetle-saturn-libretro/master/COPYING"
rp_module_section="exp"
rp_module_flags="!arm !aarch64 !32bit"

function sources_lr-beetle-saturn() {
    gitPullOrClone "$md_build" https://github.com/libretro/beetle-saturn-libretro.git
}

function build_lr-beetle-saturn() {
    make clean
    make
    md_ret_require="$md_build/mednafen_saturn_libretro.so"
}

function install_lr-beetle-saturn() {
    md_ret_files=(
        'mednafen_saturn_libretro.so'
    )
}

function configure_lr-beetle-saturn() {


    local system
    local def
    for system in saturn ; do
        def=0
        [[ "$system" == "saturn" || "$system" == "saturn-japan"    ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 1 "$md_id" "$system" "$md_inst/mednafen_saturn_libretro.so"
        addSystem "$system"
     done

    

    if [ -e $md_instcore/mednafen_saturn_libretro.so ]
                    then

                        local system
    local def
    for system in saturn saturn-japan ; do
        def=0
        [[ "$system" == "saturn" || "$system" == "saturn-japan"    ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 0 "$md_id-core" "$system" "$md_instcore/mednafen_saturn_libretro.so"
        addSystem "$system"
     done

    fi
}
