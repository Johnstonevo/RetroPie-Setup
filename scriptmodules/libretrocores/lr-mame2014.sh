#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mame2014"
rp_module_desc="Arcade emu - MAME 0.159 port for libretro"
rp_module_help="ROM Extension: .zip\n\nCopy your MAME roms to either $romdir/mame-libretro or\n$romdir/arcade"
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/mame2014-libretro/master/docs/license.txt"
rp_module_section="main"

function sources_lr-mame2014() {
    gitPullOrClone "$md_build" https://github.com/libretro/mame2014-libretro.git
}

function build_lr-mame2014() {
    rpSwap on 1200
    make clean
    make
    rpSwap off
    md_ret_require="$md_build/mame2014_libretro.so"
}

function install_lr-mame2014() {
    md_ret_files=(
        'mame2014_libretro.so'
        'docs/README-original.md'
    )
}

function configure_lr-mame2014() {
    local system
    for system in arcade mame-2014; do
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 1 "$md_id" "$system" "$md_inst/mame2014_libretro.so"
        addSystem "$system"
    done
    if [ -e /usr/lib/libretro/mame2014_libretro.so ]
    then
        addEmulator 0 "$md_id-ppa" "arcade" "$md_instppa/mame2014_libretro.so"
        addEmulator 0 "$md_id-ppa" "mame-2014" "$md_instppa/mame2014_libretro.so"
    fi
    if [ !  -d $raconfigdir/overlay/ArcadeBezels ]
    then
      git clone  https://github.com/thebezelproject/bezelproject-MAME.git  "/home/$user/RetroPie-Setup/tmp/MAME"
      cp -r  /home/$user/RetroPie-Setup/tmp/MAME/retroarch/  /home/$user/.config/
      rm -rf /home/$user/RetroPie-Setup/tmp/MAME/
      cd /home/$user/.config/retroarch/
      chown -R $user:$user ../retroarch
      find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
      ln -s "$raconfigdir/config/MAME 2010" "$raconfigdir/config/MAME 2014"

    fi
    if [  -d $raconfigdir/overlay/ArcadeBezels ]
     then
        cp /home/$user/.config/RetroPie/mame-2014/retroarch.cfg /home/$user/.config/RetroPie/mame-libretro/retroarch.cfg.bkp
        local core_config="$configdir/mame-2014/retroarch.cfg"
         iniConfig " = " '"' "$md_conf_root/mame-2014/retroarch.cfg"

        iniSet "input_overlay"  "/home/$user/.config/retroarch/overlay/MAME-Horizontal.cfg"
        iniSet "input_overlay_opacity" "1.0"
        iniSet "input_overlay_enable" "true"
        iniSet "mame2014-skip_disclaimer" "enabled"
        iniSet "mame2014-dcs-speedhack" "enabled"
        iniSet "mame2014-samples" "enabled"
    fi

}
