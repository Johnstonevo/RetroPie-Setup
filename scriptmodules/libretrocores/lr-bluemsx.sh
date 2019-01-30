#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-bluemsx"
rp_module_desc="MSX/MSX2/Colecovision emu - blueMSX port for libretro"
rp_module_help="ROM Extensions: .rom .mx1 .mx2 .col .dsk .zip\n\nCopy your MSX/MSX2 games to $romdir/msx\nCopy your Colecovision games to $romdir/coleco\n\nlr-bluemsx requires the BIOS files from the full standalone package of BlueMSX to be copied to '$biosdir/Machines' folder.\nColecovision BIOS needs to be copied to '$biosdir/Machines/COL - ColecoVision\coleco.rom'"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/blueMSX-libretro/master/license.txt"
rp_module_section="opt"

function sources_lr-bluemsx() {
    gitPullOrClone "$md_build" https://github.com/libretro/blueMSX-libretro.git
}

function build_lr-bluemsx() {
    make -f Makefile.libretro clean
    make -f Makefile.libretro
    md_ret_require="$md_build/bluemsx_libretro.so"
}

function install_lr-bluemsx() {
    md_ret_files=(
        'bluemsx_libretro.so'
        'README.md'
        'system/bluemsx/Databases'
        'system/bluemsx/Machines'
    )
}

function configure_lr-bluemsx() {
    mkRomDir "msx"
    ensureSystemretroconfig "msx"

    mkRomDir "msx2"
    ensureSystemretroconfig "msx2"
    mkRomDir "msx2+"
    ensureSystemretroconfig "msx2+"

    mkRomDir "coleco"
    ensureSystemretroconfig "coleco"

    # force colecovision system
    local cv_core_config="$configdir/coleco/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/coleco/retroarch.cfg"
    iniSet "bluemsx_msxtype" "ColecoVision" "$core_config"
    chown $user:$user "$cv_core_config"

# force msx system
    local msx_core_config="$configdir/msx/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/msx/retroarch.cfg"
    iniSet "bluemsx_msxtype" "MSX" "$msx_core_config"
    iniSet "msx_video_mode" "PAL" "$msx_core_config"
    iniSet "bluemsx_nospritelimits" "ON" "$msx_core_config"

    chown $user:$user "$msx_core_config"

# force msx2 system
    local msx2_core_config="$configdir/msx2/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/msx2/retroarch.cfg"
    iniSet "bluemsx_msxtype" "MSX2+" "$msx2_core_config"
    iniSet "msx_video_mode" "PAL" "$msx_core_config"
    iniSet "bluemsx_nospritelimits" "ON" "$msx_core_config"
    chown $user:$user "$msx2_core_config"

    cp -rv "$md_inst/"{Databases,Machines} "$biosdir/"
    chown -R $user:$user "$biosdir/"{Databases,Machines}


    addEmulator 0 "$md_id" "msx2" "$md_inst/bluemsx_libretro.so"
    addSystem "msx2"
    addEmulator 0 "$md_id" "msx2+" "$md_inst/bluemsx_libretro.so"
    addSystem "msx2+"


    addEmulator 1 "$md_id" "coleco" "$md_inst/bluemsx_libretro.so"
    addSystem "coleco"
     if [ -e /usr/lib/libretro/bluemsx_libretro.so ]
                then
   addEmulator 0 "$md_id-ppa" "msx" "$md_instppa/bluemsx_libretro.so"
    addSystem "msx"

    addEmulator 0 "$md_id-ppa" "msx2" "$md_inst/bluemsx_libretro.so"
    addSystem "msx2"
    addEmulator 0 "$md_id-ppa" "msx2+" "$md_inst/bluemsx_libretro.so"
    addSystem "msx2+"


    addEmulator 0 "$md_id-ppa" "coleco" "$md_instppa/bluemsx_libretro.so"
    addSystem "coleco"
    fi

    if [ ! -d $raconfigdir/overlay/GameBezels/ColecoVision ]
        then
            git clone  --depth 1 https://github.com/thebezelproject/bezelproject-ColecoVision.git  "/home/$user/RetroPie-Setup/tmp/ColecoVision"
            cp -r  /home/$user/RetroPie-Setup/tmp/ColecoVision/retroarch/  /home/$user/.config/
            rm -rf /home/$user/RetroPie-Setup/tmp/ColecoVision/
            ln -s /home/$user/.config/retroarch/config/BlueMSX /home/$user/.config/retroarch/config/blueMSX
            cd /home/$user/.config/retroarch
            chown -R $user:$user ../retroarch
            find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
    fi
    if [  -d $raconfigdir/overlay/GameBezels/ColecoVision ]
    then
          cp /home/$user/.config/RetroPie/coleco/retroarch.cfg /home/$user/.config/RetroPie/coleco/retroarch.cfg.bkp
          local core_config="$configdir/coleco/retroarch.cfg"
          iniConfig " = " '"' "$md_conf_root/coleco/retroarch.cfg"
          iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Colecovision.cfg" "$core_config"
          iniSet "input_overlay_opacity" "1.0" "$core_config"
          iniSet "input_overlay_scale" "1.0" "$core_config"
          iniSet "video_fullscreen_x" "1920" "$core_config"
          iniSet "video_fullscreen_y" "1080" "$core_config"
          iniSet "custom_viewport_width" "1194" "$core_config"
          iniSet "custom_viewport_height" "896" "$core_config"
          iniSet "input_overlay_enable" "true" "$core_config"
          iniSet "video_smooth" "true" "$core_config"
          iniSet "bluemsx_msxtype" "ColecoVision" "$core_config"

    fi


}
