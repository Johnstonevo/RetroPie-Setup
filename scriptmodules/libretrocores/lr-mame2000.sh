#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mame2000"
rp_module_desc="Arcade emu - MAME 0.37b5 port for libretro"
rp_module_help="ROM Extension: .zip\n\nCopy your MAME 0.37b5 roms to either $romdir/mame-mame4all or\n$romdir/arcade"
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/mame2000-libretro/master/readme.txt"
rp_module_section="main"

function _update_hook_lr-mame2000() {
    # move from old location and update emulators.cfg
    renameModule "lr-imame4all" "lr-mame2000"
}

function sources_lr-mame2000() {
    gitPullOrClone "$md_build" https://github.com/libretro/mame2000-libretro.git
}

function build_lr-mame2000() {
    make clean
    local params=()
    isPlatform "arm" && params+=("ARM=1" "USE_CYCLONE=1")
    make "${params[@]}"
    md_ret_require="$md_build/mame2000_libretro.so"
}

function install_lr-mame2000() {
    md_ret_files=(
        'mame2000_libretro.so'
        'readme.md'
        'readme.txt'
        'whatsnew.txt'
    )
}

function configure_lr-mame2000() {
    local system
    for system in arcade mame-mame4all ; do
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 0 "$md_id" "$system" "$md_inst/mame2000_libretro.so"
        addSystem "$system"

        addBezel "mame-mame4all"
    done
    if [ -e $md_instppa/mame2000_libretro.so ]
    then
        addEmulator 0 "$md_id-ppa" "arcade" "$md_instppa/${so_name}_libretro.so"
    addEmulator 0 "$md_id-ppa" "mame-mame4all" "$md_instppa/${so_name}_libretro.so"
    fi

        cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp
        local core_config="$configdir/$system/retroarch.cfg"
         iniConfig " = " '"' "$md_conf_root/$system/retroarch.cfg"

        iniSet "input_overlay"  "$raconfigdir/overlay/MAME-Horizontal.cfg"
        iniSet "input_overlay_opacity" "1.0"
        iniSet "input_overlay_enable" "true"
    


}
