#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-snes9x2002"
rp_module_desc="Super Nintendo emu - ARM optimised Snes9x 1.39 port for libretro"
rp_module_help="Previously called lr-pocketsnes\n\nROM Extensions: .bin .smc .sfc .fig .swc .mgd .zip\n\nCopy your SNES roms to $romdir/snes"
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/snes9x2002/master/src/copyright.h"
rp_module_section="main"
rp_module_flags="!x86 !aarch64"

function _update_hook_lr-snes9x2002() {
    # move from old location and update emulators.cfg
    renameModule "lr-pocketsnes" "lr-snes9x2002"
}

function sources_lr-snes9x2002() {
    gitPullOrClone "$md_build" https://github.com/libretro/snes9x2002.git
}

function build_lr-snes9x2002() {
    make clean
    CFLAGS="$CFLAGS -Wa,-mimplicit-it=thumb" make ARM_ASM=1
    md_ret_require="$md_build/snes9x2002_libretro.so"
}

function install_lr-snes9x2002() {
    md_ret_files=(
        'snes9x2002_libretro.so'
        'README.txt'
    )
}

function configure_lr-snes9x2002() {
    mkRomDir "snes"
    mkRomdDir "smwhacks"
    mkRomDir "snesh"
    mkRomDir "sfc"
    mkRomDir "satellaview"
    mkRomDir "sufami"
    ensureSystemretroconfig "snes"
    ensureSystemretroconfig "snesh"
    ensureSystemretroconfig "sfc"
    ensureSystemretroconfig "satellaview"
    ensureSystemretroconfig "sufami"
    ensureSystemretroconfig "smwhacks"


    addEmulator 0 "$md_id" "snes" "$md_inst/snes9x2002_libretro.so"
    addEmulator 0 "$md_id" "snesh" "$md_inst/snes9x2002_libretro.so"
    addEmulator 0 "$md_id" "sfc" "$md_inst/snes9x2002_libretro.so"
    addEmulator 0 "$md_id" "satellaview" "$md_inst/snes9x2002_libretro.so"
    addEmulator 0 "$md_id" "sufami" "$md_inst/snes9x2002_libretro.so"
    addEmulator 0 "$md_id" "smwhacks" "$md_inst/snes9x2002_libretro.so"
    addSystem "snes"
    addSystem "snesh"
    addSystem "sfc"
    addSystem "satellaview"
    addSystem "sufami"
    addSystem "smwhacks"


    addBezel "snes"
    addBezel "sfc"
    ln -s $raconfigdir/config/Snes9x "$raconfigdir/config/Snes9x 2002"
    ln -s $raconfigdir/config/Snes9x "$raconfigdir/config/Snes9x 2002"

    if [ -e $md_instppa/snes9x2002_libretro.so ]
        then
          addEmulator 0 "$md_id-ppa" "snes" "$md_instppa/snes9x2002_libretro.so"
          addEmulator 0 "$md_id-ppa" "snesh" "$md_instppa/snes9x2002_libretro.so"
          addEmulator 0 "$md_id-ppa" "sfc" "$md_instppa/snes9x2002_libretro.so"
          addEmulator 0 "$md_id-ppa" "satellaview" "$md_instppa/snes9x2002_libretro.so"
          addEmulator 0 "$md_id-ppa" "sufami" "$md_instppa/snes9x2002_libretro.so"
          addEmulator 0 "$md_id-ppa" "smwhacks" "$md_instppa/snes9x2002_libretro.so"
    fi


        cp /home/$user/.config/RetroPie/snes/retroarch.cfg /home/$user/.config/RetroPie/snes/retroarch.cfg.bkp
        local core_config="snes"
        setRetroArchcoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
        setRetroArchcoreOption "input_overlay_opacity" "1.0"
        setRetroArchcoreOption "input_overlay_scale" "1.0"
        setRetroArchcoreOption "input_overlay_enable" "true"
        setRetroArchcoreOption "video_smooth" "false"
        setRetroArchcoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp"
        setRetroArchcoreOption "video_shader_enable"  "true" 
        setRetroArchcoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"




        cp /home/$user/.config/RetroPie/snesh/retroarch.cfg /home/$user/.config/RetroPie/snesh/retroarch.cfg.bkp
        local core_config="snesh"
        setRetroArchcoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
        setRetroArchcoreOption "input_overlay_opacity" "1.0"
        setRetroArchcoreOption "input_overlay_scale" "1.0"
        setRetroArchcoreOption "input_overlay_enable" "true"
        setRetroArchcoreOption "video_smooth" "false"
        setRetroArchcoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp"
        setRetroArchcoreOption "video_shader_enable"  "true" 
        setRetroArchcoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"




        cp /home/$user/.config/RetroPie/sfc/retroarch.cfg /home/$user/.config/RetroPie/sfc/retroarch.cfg.bkp
        local core_config="/sfc"
        setRetroArchcoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
        setRetroArchcoreOption "input_overlay_opacity" "1.0"
        setRetroArchcoreOption "input_overlay_scale" "1.0"
        setRetroArchcoreOption "input_overlay_enable" "true"
        setRetroArchcoreOption "video_smooth" "false"
        setRetroArchcoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp"
        setRetroArchcoreOption "video_shader_enable"  "true" 
        setRetroArchcoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"



        cp /home/$user/.config/RetroPie/satellaview/retroarch.cfg /home/$user/.config/RetroPie/satellaview/retroarch.cfg.bkp
        local core_config="satellaview"
        setRetroArchcoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
        setRetroArchcoreOption "input_overlay_opacity" "1.0"
        setRetroArchcoreOption "input_overlay_scale" "1.0"
        setRetroArchcoreOption "input_overlay_enable" "true"
        setRetroArchcoreOption "video_smooth" "false"
        setRetroArchcoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp"
        setRetroArchcoreOption "video_shader_enable"  "true" 
        setRetroArchcoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"



        cp /home/$user/.config/RetroPie/sufami/retroarch.cfg /home/$user/.config/RetroPie/sufami/retroarch.cfg.bkp
        local core_config="sufami"
        setRetroArchcoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
        setRetroArchcoreOption "input_overlay_opacity" "1.0"
        setRetroArchcoreOption "input_overlay_scale" "1.0"
        setRetroArchcoreOption "input_overlay_enable" "true"
        setRetroArchcoreOption "video_smooth" "false"
        setRetroArchcoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp"
        setRetroArchcoreOption "video_shader_enable"  "true" 
        setRetroArchcoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"


        cp /home/$user/.config/RetroPie/smwhacks/retroarch.cfg /home/$user/.config/RetroPie/smwhacks/retroarch.cfg.bkp
        local core_config="smwhacks"
        iniConfig " = " '"' "$md_conf_root/smwhacks/retroarch.cfg"
        setRetroArchcoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
        setRetroArchcoreOption "input_overlay_opacity" "1.0"
        setRetroArchcoreOption "input_overlay_scale" "1.0"
        setRetroArchcoreOption "input_overlay_enable" "true"
        setRetroArchcoreOption "video_smooth" "false"
        setRetroArchcoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp"
        setRetroArchcoreOption "video_shader_enable"  "true" 
        setRetroArchcoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"



}
