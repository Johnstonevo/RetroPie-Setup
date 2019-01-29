#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-bsnes"
rp_module_desc="Super Nintendo emu - bsnes port for libretro"
rp_module_help="ROM Extensions: .bin .smc .sfc .fig .swc .mgd .zip\n\nCopy your SNES roms to $romdir/snes"
rp_module_licence="GPL3 https://raw.githubusercontent.com/libretro/bsnes-libretro/libretro/COPYING"
rp_module_section="opt"
rp_module_flags="!arm"

function sources_lr-bsnes() {
    gitPullOrClone "$md_build" https://github.com/libretro/bsnes-libretro.git
}

function build_lr-bsnes() {
    make clean
    make
    md_ret_require="$md_build/out/bsnes_accuracy_libretro.so"
}

function install_lr-bsnes() {
    md_ret_files=(
        'out/bsnes_accuracy_libretro.so'
        'COPYING'
    )
}

function configure_lr-bsnes() {
    local system
    local def
    for system in snes sfc snescd snesh nintendobsx sufami; do
        def=0
        [[ "$system" == "snes" || "$system" == "sfc" || "$system" == "snescd"  || "$system" == "snesh"  || "$system" == "nintendobsx" || "$system" == "sufami" ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 0 "$md_id" "$system" "$md_inst/bsnes_accuracy_libretro.so"
        addSystem "$system"
 done
 if [ ! -d $raconfigdir/overlay/GameBezels/SNES ]
then
    git clone  https://github.com/thebezelproject/bezelproject-SNES.git  "/home/$user/RetroPie-Setup/tmp/SNES"
    cp -r  /home/$user/RetroPie-Setup/tmp/SNES/retroarch/  /home/$user/.config/
   rm -rf /home/$user/RetroPie-Setup/tmp/SNES/
    cd /home/$user/.config/retroarch
    chown -R $user:$user ../retroarch
    find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
fi

if [ ! -d $raconfigdir/overlay/GameBezels/SFC ]
then
    git clone  https://github.com/thebezelproject/bezelproject-SFC.git  "/home/$user/RetroPie-Setup/tmp/SFC"
    cp -r  /home/$user/RetroPie-Setup/tmp/SFC/retroarch/  /home/$user/.config/
    rm -rf /home/$user/RetroPie-Setup/tmp/SFC/
    cd /home/$user/.config/retroarch/
    chown -R $user:$user ../retroarch
    find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
fi

if [ -e /usr/lib/libretro/bsnes_balanced_libretro.so ]
    then
    local system
    local def
    for system in snes sfc snescd snesh nintendobsx sufami; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc" || "$system" == "snescd"  || "$system" == "snesh"  || "$system" == "nintendobsx" || "$system" == "sufami" ]] && def=1
            addEmulator 0 "$md_id-balanced-ppa" "$system" "$md_instppa/bsnes_balanced_libretro.so"
            addSystem "$system"
 done
fi
if [ -e /usr/lib/libretro/bsnes_accuracy_libretro.so ]
    then
    local system
    local def
    for system in snes sfc snescd snesh nintendobsx sufami; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc" || "$system" == "snescd"  || "$system" == "snesh"  || "$system" == "nintendobsx" || "$system" == "sufami" ]] && def=1
            addEmulator 0 "$md_id-ppa" "$system" "$md_instppa/bsnes_accuracy_libretro.so"
            addSystem "$system"
 done
fi
if [ -e /usr/lib/libretro/bsnes_mercury_accuracy_libretro.so ]
    then
    local system
    local def
    for system in snes sfc snescd snesh nintendobsx sufami; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc" || "$system" == "snescd"  || "$system" == "snesh"  || "$system" == "nintendobsx" || "$system" == "sufami" ]] && def=1
            addEmulator 0 "$md_id-mercury_accuracy-ppa" "$system" "$md_instppa/bsnes_mercury_accuracy_libretro.so"
            addSystem "$system"
 done
fi
if [ -e /usr/lib/libretro/bsnes_mercury_balanced_libretro.so ]
    then
    local system
    local def
    for system in snes sfc snescd snesh nintendobsx sufami; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc" || "$system" == "snescd"  || "$system" == "snesh"  || "$system" == "nintendobsx" || "$system" == "sufami" ]] && def=1
            addEmulator 0 "$md_id-mercury_balanced-ppa" "$system" "$md_instppa/bsnes_mercury_balanced_libretro.so"
            addSystem "$system"
 done
fi
if [ -e /usr/lib/libretro/bsnes_mercury_performance_libretro.so ]
    then
    local system
    local def
    for system in snes sfc snescd snesh nintendobsx sufami; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc" || "$system" == "snescd"  || "$system" == "snesh"  || "$system" == "nintendobsx" || "$system" == "sufami" ]] && def=1
            addEmulator 0 "$md_id-mercury_performance-ppa" "$system" "$md_instppa/bsnes_mercury_performance_libretro.so"
            addSystem "$system"
 done
fi

if [  -d $raconfigdir/overlay/GameBezels/SNES ]
 then
    ln -s $raconfigdir/config/Snes9x $raconfigdir/config/bsnes
    cp /home/$user/.config/RetroPie/snes/retroarch.cfg /home/$user/.config/RetroPie/snes/retroarch.cfg.bkp
    local core_config="$configdir/snes/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/snes/retroarch.cfg"
    iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
    iniSet "input_overlay_opacity" "1.0" "$core_config"
    iniSet "input_overlay_scale" "1.0" "$core_config"
    iniSet "video_fullscreen_x" "1920" "$core_config"
    iniSet "video_fullscreen_y" "1080" "$core_config"
    iniSet "custom_viewport_width" "1194" "$core_config"
    iniSet "custom_viewport_height" "896" "$core_config"
    iniSet "custom_viewport_x" "363" "$core_config"
    iniSet "custom_viewport_y" "90" "$core_config"
    iniSet "aspect_ratio_index" "22" "$core_config"
    iniSet "input_overlay_enable" "true" "$core_config"
    iniSet "video_smooth" "true" "$core_config"
    chown $user:$user "$core_config"

fi
if [  -d $raconfigdir/overlay/snescd ]
 then
             cp /home/$user/.config/RetroPie/snescd/retroarch.cfg /home/$user/.config/RetroPie/snescd/retroarch.cfg.bkp
            local core_config="$configdir/snescd/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/snescd/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "custom_viewport_width" "1194" "$core_config"
            iniSet "custom_viewport_height" "896" "$core_config"
            iniSet "custom_viewport_x" "363" "$core_config"
            iniSet "custom_viewport_y" "90" "$core_config"
            iniSet "aspect_ratio_index" "22" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            iniSet "video_smooth" "true" "$core_config"
            chown $user:$user "$core_config"

fi
if [  -d $raconfigdir/overlay/sfc ]
 then
             cp /home/$user/.config/RetroPie/sfc/retroarch.cfg /home/$user/.config/RetroPie/sfc/retroarch.cfg.bkp
            local core_config="$configdir/sfc/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/sfc/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "custom_viewport_width" "1194" "$core_config"
            iniSet "custom_viewport_height" "896" "$core_config"
            iniSet "custom_viewport_x" "363" "$core_config"
            iniSet "custom_viewport_y" "90" "$core_config"
            iniSet "aspect_ratio_index" "22" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            iniSet "video_smooth" "true" "$core_config"
            chown $user:$user "$core_config"
fi
if [  -d $raconfigdir/overlay/nintendobsx ]
 then
             cp /home/$user/.config/RetroPie/nintendobsx/retroarch.cfg /home/$user/.config/RetroPie/nintendobsx/retroarch.cfg.bkp
            local core_config="$configdir/nintendobsx/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/nintendobsx/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "custom_viewport_width" "1194" "$core_config"
            iniSet "custom_viewport_height" "896" "$core_config"
            iniSet "custom_viewport_x" "363" "$core_config"
            iniSet "custom_viewport_y" "90" "$core_config"
            iniSet "aspect_ratio_index" "22" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            iniSet "video_smooth" "true" "$core_config"
            chown $user:$user "$core_config"
fi
if [  -d $raconfigdir/overlay/sufami ]
 then
             cp /home/$user/.config/RetroPie/sufami/retroarch.cfg /home/$user/.config/RetroPie/sufami/retroarch.cfg.bkp
            local core_config="$configdir/sufami/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/sufami/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "custom_viewport_width" "1194" "$core_config"
            iniSet "custom_viewport_height" "896" "$core_config"
            iniSet "custom_viewport_x" "363" "$core_config"
            iniSet "custom_viewport_y" "90" "$core_config"
            iniSet "aspect_ratio_index" "22" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            iniSet "video_smooth" "true" "$core_config"
            chown $user:$user "$core_config"
fi
}
