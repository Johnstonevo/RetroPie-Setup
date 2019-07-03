#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-stella2014"
rp_module_desc="Atari 2600 emulator - Stella port for libretro"
rp_module_help="ROM Extensions: .a26 .bin .rom .zip .gz\n\nCopy your Atari 2600 roms to $romdir/atari2600"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/stella2014-libretro/master/stella/license.txt"
rp_module_section="main"

function _update_hook_lr-stella2014() {
    # rename lr-stella to lr-stella2014
    renameModule "lr-stella" "lr-stella2014"
}

function sources_lr-stella2014() {
    gitPullOrClone "$md_build" https://github.com/libretro/stella2014-libretro.git
}

function build_lr-stella2014() {
    make clean
    make
    md_ret_require="$md_build/stella2014_libretro.so"
}

function install_lr-stella2014() {
    md_ret_files=(
        'README.md'
        'stella2014_libretro.so'
        'stella/license.txt'
    )
}

function configure_lr-stella2014() {
    mkRomDir "atari2600"
    ensureSystemretroconfig "atari2600"

    addEmulator 1 "$md_id" "atari2600" "$md_inst/stella2014_libretro.so"
    addSystem "atari2600"
    if [ -e $md_instppa/stella_libretro.so ]
        then
          addEmulator 0 "$md_id-ppa" "atari2600" "$md_instppa/stella_libretro.so"
          addSystem "atari2600"
    fi
    if [ ! -d $raconfigdir/overlay/GameBezels/Atari2600 ]
    then
        git clone https://github.com/thebezelproject/bezelproject-Atari2600.git  "/home/$user/RetroPie-Setup/tmp/Atari2600"
        cp -r  /home/$user/RetroPie-Setup/tmp/Atari2600/retroarch/  /home/$user/.config/
        rm -rf /home/$user/RetroPie-Setup/tmp/Atari2600/
        cd /home/$user/.config/retroarch
        chown -R $user:$user overlay config
        find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
    fi
if [  -d $raconfigdir/overlay/GameBezels/Atari2600 ]
  then
      cp /home/$user/.config/RetroPie/atari2600/retroarch.cfg /home/$user/.config/RetroPie/atari2600/retroarch.cfg.bkp
      local core_config="$configdir/atari2600/retroarch.cfg"
      iniConfig " = " '"' "$md_conf_root/atari2600/retroarch.cfg"
      iniSet  "input_overlay" "$raconfigdir/overlay/Atari-2600.cfg" "$core_config"
      iniSet "input_overlay_opacity" "1.0" "$core_config"
      iniSet "input_overlay_scale" "1.0" "$core_config"

      iniSet "input_overlay_enable" "true" "$core_config"
      iniSet "video_smooth" "true" "$core_config"
      chown $user:$user "$core_config"
fi


}
