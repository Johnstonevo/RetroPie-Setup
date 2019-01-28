#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mame2016"
rp_module_desc="MAME emulator - MAME 0.174 port for libretro"
rp_module_help="ROM Extension: .zip\n\nCopy your MAME roms to either $romdir/mame-libretro or\n$romdir/arcade"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame2016-libretro/master/LICENSE.md"
rp_module_section="main"

function sources_lr-mame2016() {
    gitPullOrClone "$md_build" https://github.com/libretro/mame2016-libretro.git
}

function build_lr-mame2016() {
    rpSwap on 1200
    local params=($(_get_params_lr-mame) SUBTARGET=arcade)
    make -f Makefile.libretro clean
    make -f Makefile.libretro "${params[@]}"
    rpSwap off
    md_ret_require="$md_build/mamearcade2016_libretro.so"
}

function install_lr-mame2016() {
    md_ret_files=(
        'mamearcade2016_libretro.so'
    )
}

function configure_lr-mame2016() {
    local system
    for system in arcade mame-2016; do
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 1 "$md_id" "$system" "$md_inst/mame2016_libretro.so"
        addSystem "$system"
    done
    if [ -e /usr/lib/libretro/mame2016_libretro.so ]
    then
        addEmulator 0 "$md_id-ppa" "arcade" "$md_instppa/mame2016_libretro.so"
        addEmulator 0 "$md_id-ppa" "mame-2016" "$md_instppa/mame2016_libretro.so"
    fi
    if [ !  -d $raconfigdir/overlay/ArcadeBezels ]
    then
      git clone  https://github.com/thebezelproject/bezelproject-MAME.git  "/home/$user/RetroPie-Setup/tmp/MAME"
      cp -r  /home/$user/RetroPie-Setup/tmp/MAME/retroarch/  /home/$user/.config/
      rm -rf /home/$user/RetroPie-Setup/tmp/MAME/
      cd /home/$user/.config/retroarch/
      chown -R $user:$user ../retroarch
      find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
      ln -s "$raconfigdir/config/MAME 2010" "$raconfigdir/config/MAME 2016"

    fi
    if [  -d $raconfigdir/overlay/ArcadeBezels ]
     then
        cp /home/$user/.config/RetroPie/mame-2016/retroarch.cfg /home/$user/.config/RetroPie/mame-libretro/retroarch.cfg.bkp
        local core_config="$configdir/mame-2016/retroarch.cfg"
         iniConfig " = " '"' "$md_conf_root/mame-2016/retroarch.cfg"

        iniSet "input_overlay"  "/home/$user/.config/retroarch/overlay/MAME-Horizontal.cfg"
        iniSet "input_overlay_opacity" "1.0"
        iniSet "input_overlay_enable" "true"
        iniSet "mame2016-skip_disclaimer" "enabled"
        iniSet "mame2016-dcs-speedhack" "enabled"
        iniSet "mame2016-samples" "enabled"
    fi


}
