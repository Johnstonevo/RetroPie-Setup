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
rp_module_section="main"
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
    for system in snes sfc snesh satellaview sufami; do
        def=0
        [[ "$system" == "snes" || "$system" == "sfc"  || "$system" == "snesh"  || "$system" == "satellaview" || "$system" == "sufami" ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 0 "$md_id" "$system" "$md_inst/bsnes_accuracy_libretro.so"
        addSystem "$system"
 done


    addBezel "snes"
    addBezel "sfc"

if [ -e $md_instppa/bsnes_balanced_libretro.so ]
    then
    local system
    local def
    for system in snes sfc  snesh satellaview sufami; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc"  || "$system" == "snesh"  || "$system" == "satellaview" || "$system" == "sufami" ]] && def=1
            addEmulator 0 "$md_id-balanced-ppa" "$system" "$md_instppa/bsnes_balanced_libretro.so"
            addSystem "$system"
 done
fi
if [ -e $md_instppa/bsnes_accuracy_libretro.so ]
    then
    local system
    local def
    for system in snes sfc  snesh satellaview sufami; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc"  || "$system" == "snesh"  || "$system" == "satellaview" || "$system" == "sufami" ]] && def=1
            addEmulator 0 "$md_id-ppa" "$system" "$md_instppa/bsnes_accuracy_libretro.so"
            addSystem "$system"
 done
fi
if [ -e $md_instppa/bsnes_mercury_accuracy_libretro.so ]
    then
    local system
    local def
    for system in snes sfc  snesh satellaview sufami; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc" || "$system" == "snesh"  || "$system" == "satellaview" || "$system" == "sufami" ]] && def=1
            addEmulator 0 "$md_id-mercury_accuracy-ppa" "$system" "$md_instppa/bsnes_mercury_accuracy_libretro.so"
            addSystem "$system"
 done
fi
if [ -e $md_instppa/bsnes_mercury_balanced_libretro.so ]
    then
    local system
    local def
    for system in snes sfc  snesh satellaview sufami; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc" || "$system" == "snesh"  || "$system" == "satellaview" || "$system" == "sufami" ]] && def=1
            addEmulator 0 "$md_id-mercury_balanced-ppa" "$system" "$md_instppa/bsnes_mercury_balanced_libretro.so"
            addSystem "$system"
 done
fi
if [ -e $md_instppa/bsnes_mercury_performance_libretro.so ]
    then
    local system
    local def
    for system in snes sfc  snesh satellaview sufami; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc" || "$system" == "snesh"  || "$system" == "satellaview" || "$system" == "sufami" ]] && def=1
            addEmulator 0 "$md_id-mercury_performance-ppa" "$system" "$md_instppa/bsnes_mercury_performance_libretro.so"
            addSystem "$system"
 done
fi

    ln -s $raconfigdir/config/Snes9x $raconfigdir/config/bsnes
    cp /home/$user/.config/RetroPie/snes/retroarch.cfg /home/$user/.config/RetroPie/snes/retroarch.cfg.bkp
    local core_config="$configdir/snes/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/snes/retroarch.cfg"
    iniSet  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
    iniSet "input_overlay_opacity" "1.0" "$core_config"
    iniSet "input_overlay_scale" "1.0" "$core_config"
    iniSet "input_overlay_enable" "true" "$core_config"
    iniSet "video_smooth" "false" "$core_config"
    iniSet "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp" "$core_config"
    iniSet "video_shader_enable"  "true" "$core_config" 
    iniSet "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie" "$core_config"
    chown $user:$user "$core_config"

    cp /home/$user/.config/RetroPie//retroarch.cfg /home/$user/.config/RetroPie//retroarch.cfg.bkp
    local core_config="$configdir//retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root//retroarch.cfg"
    iniSet  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
    iniSet "input_overlay_opacity" "1.0" "$core_config"
    iniSet "input_overlay_scale" "1.0" "$core_config"
    iniSet "input_overlay_enable" "true" "$core_config"
    iniSet "video_smooth" "false" "$core_config"
    iniSet "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp" "$core_config"
    iniSet "video_shader_enable"  "true" "$core_config" 
    iniSet "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie" "$core_config"
    chown $user:$user "$core_config"

    cp /home/$user/.config/RetroPie/sfc/retroarch.cfg /home/$user/.config/RetroPie/sfc/retroarch.cfg.bkp
    local core_config="$configdir/sfc/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/sfc/retroarch.cfg"
    iniSet  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
    iniSet "input_overlay_opacity" "1.0" "$core_config"
    iniSet "input_overlay_scale" "1.0" "$core_config"
    iniSet "input_overlay_enable" "true" "$core_config"
    iniSet "video_smooth" "false" "$core_config"
    iniSet "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp" "$core_config"
    iniSet "video_shader_enable"  "true" "$core_config" 
    iniSet "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie" "$core_config"

    cp /home/$user/.config/RetroPie/satellaview/retroarch.cfg /home/$user/.config/RetroPie/satellaview/retroarch.cfg.bkp
    local core_config="$configdir/satellaview/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/satellaview/retroarch.cfg"
    iniSet  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
    iniSet "input_overlay_opacity" "1.0" "$core_config"
    iniSet "input_overlay_scale" "1.0" "$core_config"
    iniSet "input_overlay_enable" "true" "$core_config"
    iniSet "video_smooth" "false" "$core_config"
    iniSet "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp" "$core_config"
    iniSet "video_shader_enable"  "true" "$core_config" 
    iniSet "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie" "$core_config"
    chown $user:$user "$core_config"

    cp /home/$user/.config/RetroPie/sufami/retroarch.cfg /home/$user/.config/RetroPie/sufami/retroarch.cfg.bkp
    local core_config="$configdir/sufami/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/sufami/retroarch.cfg"
    iniSet  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
    iniSet "input_overlay_opacity" "1.0" "$core_config"
    iniSet "input_overlay_scale" "1.0" "$core_config"
    iniSet "input_overlay_enable" "true" "$core_config"
    iniSet "video_smooth" "false" "$core_config"
    iniSet "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp" "$core_config"
    iniSet "video_shader_enable"  "true" "$core_config" 
    iniSet "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie" "$core_config"
    chown $user:$user "$core_config"

}
