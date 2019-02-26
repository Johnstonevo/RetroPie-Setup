#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-atari800"
rp_module_desc="Atari 8-bit/800/5200 emulator - Atari800 port for libretro"
rp_module_help="ROM Extensions: .a52 .bas .bin .car .xex .atr .xfd .dcm .atr.gz .xfd.gz\n\nCopy your Atari800 games to $romdir/atari800\n\nCopy your Atari 5200 roms to $romdir/atari5200 You need to copy the Atari 800/5200 BIOS files (5200.ROM, ATARIBAS.ROM, ATARIOSB.ROM and ATARIXL.ROM) to the folder $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/libretro-atari800/master/atari800/COPYING"
rp_module_section="main"

function sources_lr-atari800() {
    gitPullOrClone "$md_build" https://github.com/libretro/libretro-atari800.git
}

function build_lr-atari800() {
    make clean
    make
    md_ret_require="$md_build/atari800_libretro.so"
}

function install_lr-atari800() {
    md_ret_files=(
        'atari800_libretro.so'
        'atari800/COPYING'
    )
}

function configure_lr-atari800() {
    mkRomDir "atari800"
    mkRomDir "atari5200"

    ensureSystemretroconfig "atari800"
    ensureSystemretroconfig "atari5200"

    mkUserDir "$md_conf_root/atari800"
    moveConfigFile "$home/.atari800.cfg" "$md_conf_root/atari800/atari800.cfg"

    addEmulator 0 "lr-atari800" "atari800" "$md_inst/atari800_libretro.so"
    addEmulator 0 "lr-atari800" "atari5200" "$md_inst/atari800_libretro.so"
    addSystem "atari800"
    addSystem "atari5200"

 # force 800 system
    local a800_core_config="$configdir/atari800/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/atari800/retroarch.cfg"
    iniSet  "atari800_system" "800" "$atari800_core_config"
    iniSet "atari800_ntscpal" "PAL" "$atari800_core_config"
    chown $user:$user "$a800_core_config"

# force 5200 system
    local a5200_core_config="$configdir/atari5200/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/atari5200/retroarch.cfg"
    iniSet  "atari800_system" "5200" "$a5200_core_config"
    iniSet "atari800_ntscpal" "PAL" "$a5200_core_config"
    chown $user:$user "$a5200_core_config"




     if [ -e $md_instppa/atari800_libretro.so ]
     then
        addEmulator 2 "lr-atari800-ppa" "atari800" "$md_instppa/atari800_libretro.so"
        addEmulator 2 "lr-atari800-ppa" "atari5200" "$md_instppa/atari800_libretro.so"
        addSystem "atari800"
        addSystem "atari5200"
    fi


if [ ! -d $raconfigdir/overlay/GameBezels/Atari5200 ]
then
    git clone https://github.com/thebezelproject/bezelproject-Atari5200.git  "/home/$user/RetroPie-Setup/tmp/Atari5200"
    cp -r  /home/$user/RetroPie-Setup/tmp/Atari5200/retroarch/  /home/$user/.config/
   rm -rf /home/$user/RetroPie-Setup/tmp/Atari5200/
    cd /home/$user/.config/retroarch/
    chown -R $user:$user ../retroarch
    find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
fi


if [  -d $raconfigdir/overlay/GameBezels/Atari5200 ]
 then
             cp /home/$user/.config/RetroPie/atari5200/retroarch.cfg /home/$user/.config/RetroPie/atari5200/retroarch.cfg.bkp
            local a5200_core_config="$configdir/atari5200/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/atari5200/retroarch.cfg"
            iniSet  "input_overlay" "$raconfigdir/overlay/Atari-5200.cfg" "$a5200_core_config"
            iniSet "input_overlay_opacity" "1.0" "$a5200_core_config"
            chown $user:$user "$a5200_core_config"

            cp /home/$user/.config/RetroPie/atari800/retroarch.cfg /home/$user/.config/RetroPie/atari800/retroarch.cfg.bkp
            local a800_core_config="$configdir/atari800/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/atari800/retroarch.cfg"
            iniSet  "input_overlay" "$raconfigdir/overlay/Atari-5200.cfg" "$a800_core_config"
            iniSet "input_overlay_opacity" "1.0" "$a800_core_config"
            chown $user:$user "$a800_core_config"
fi
}
