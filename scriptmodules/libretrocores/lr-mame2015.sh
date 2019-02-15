#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mame2015"
rp_module_desc="Arcade emu - MAME 0.160 port for libretro"
rp_module_help="ROM Extension: .zip\n\nCopy your MAME roms to either $romdir/mame-libretro or\n$romdir/arcade"
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/mame2015-libretro/master/docs/license.txt"
rp_module_section="main"


function _update_hook_lr-mame2015() {
    # move from old location and update emulators.cfg
    renameModule "lr-mame2015" "lr-mame2015"
}

function sources_lr-mame2015() {
    gitPullOrClone "$md_build" https://github.com/libretro/mame2015-libretro.git
}

function build_lr-mame2015() {
    rpSwap on 1200
    make clean
    make
    rpSwap off
    md_ret_require="$md_build/mame2015_libretro.so"
}

function install_lr-mame2015() {
    md_ret_files=(
        'mame2015_libretro.so'
        'docs/README-original.md'
        'docs/license.txt'
    )
}

function configure_lr-mame2015() {
    local system
    for system in arcade mame-2015; do
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 0 "$md_id" "$system" "$md_inst/mame2015_libretro.so"
        addSystem "$system"
    done
    if [ -e /usr/lib/libretro/mame2015_libretro.so ]
    then
        addEmulator 0 "$md_id-ppa" "arcade" "$md_instppa/mame2015_libretro.so"
        addEmulator 0 "$md_id-ppa" "mame-2015" "$md_instppa/mame2015_libretro.so"
    fi
    if [ !  -d $raconfigdir/overlay/ArcadeBezels ]
    then
      git clone https://github.com/thebezelproject/bezelproject-MAME.git  "/home/$user/RetroPie-Setup/tmp/MAME"
      cp -r  /home/$user/RetroPie-Setup/tmp/MAME/retroarch/  /home/$user/.config/
      rm -rf /home/$user/RetroPie-Setup/tmp/MAME/
      cd /home/$user/.config/retroarch/
      chown -R $user:$user ../retroarch
      find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
      ln -s "$raconfigdir/config/MAME 2010" "$raconfigdir/config/MAME 2015"

    fi
    if [  -d $raconfigdir/overlay/ArcadeBezels ]
     then
        cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp
        local core_config="$configdir/$system/retroarch.cfg"
         iniConfig " = " '"' "$md_conf_root/$system/retroarch.cfg"

        iniSet "input_overlay"  "/home/$user/.config/retroarch/overlay/MAME-Horizontal.cfg"
        iniSet "input_overlay_opacity" "1.0"
        iniSet "input_overlay_enable" "true"
        iniSet "mame2015-skip_disclaimer" "enabled"
        iniSet "mame2015-dcs-speedhack" "enabled"
        iniSet "mame2015-samples" "enabled"
    fi

}
