#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-snes9x2005"
rp_module_desc="Super Nintendo emu - Snes9x 1.43 based port for libretro"
rp_module_help="Previously called lr-catsfc\n\nROM Extensions: .bin .smc .sfc .fig .swc .mgd .zip\n\nCopy your SNES roms to $romdir/snes"
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/snes9x2005/master/copyright"
rp_module_section="main"

function _update_hook_lr-snes9x2005() {
    # move from old location and update emulators.cfg
    renameModule "lr-catsfc" "lr-snes9x2005"
}

function sources_lr-snes9x2005() {
    gitPullOrClone "$md_build" https://github.com/libretro/snes9x2005.git
}

function build_lr-snes9x2005() {
    make clean
    make
    md_ret_require="$md_build/snes9x2005_libretro.so"
}

function install_lr-snes9x2005() {
    md_ret_files=(
        'snes9x2005_libretro.so'
    )
}

function configure_lr-snes9x2005() {
    mkRomDir "snes"
    mkRomDir "snesh"
    mkRomDir "sfc"
    mkRomDir "satellaview"
    mkRomDir "sufami"
    mkRomDir "smwhacks"
    ensureSystemretroconfig "snes"
    ensureSystemretroconfig "snesh"
    ensureSystemretroconfig "sfc"
    ensureSystemretroconfig "satellaview"
    ensureSystemretroconfig "sufami"
    ensureSystemretroconfig "smwhacks"


    addEmulator 0 "$md_id" "snes" "$md_inst/snes9x2005_libretro.so"
    addEmulator 0 "$md_id" "snesh" "$md_inst/snes9x2005_libretro.so"
    addEmulator 0 "$md_id" "sfc" "$md_inst/snes9x2005_libretro.so"
    addEmulator 1 "$md_id" "satellaview" "$md_inst/snes9x2005_libretro.so"
    addEmulator 0 "$md_id" "sufami" "$md_inst/snes9x2005_libretro.so"
    addEmulator 0 "$md_id" "smwhacks" "$md_inst/snes9x2005_libretro.so"
    addSystem "snes"
    addSystem "snesh"
    addSystem "sfc"
    addSystem "satellaview"
    addSystem "sufami"
    addSystem "smwhacks"

    addBezel "snes"
    addBezel "sfc"
    ln -s $raconfigdir/config/Snes9x "$raconfigdir/config/Snes9x 2005"
    
    if [ -e $md_instppa/snes9x2005_libretro.so ]
        then
          addEmulator 0 "$md_id-ppa" "snes" "$md_instppa/snes9x2005_libretro.so"
          addEmulator 0 "$md_id-ppa" "snesh" "$md_instppa/snes9x2005_libretro.so"
          addEmulator 0 "$md_id-ppa" "sfc" "$md_instppa/snes9x2005_libretro.so"
          addEmulator 0 "$md_id-ppa" "satellaview" "$md_instppa/snes9x2005_libretro.so"
          addEmulator 0 "$md_id-ppa" "sufami" "$md_instppa/snes9x2005_libretro.so"
          addEmulator 0 "$md_id-ppa" "smwhacks" "$md_instppa/snes9x2005_libretro.so"
    fi


    cp /home/$user/.config/RetroPie/snes/retroarch.cfg /home/$user/.config/RetroPie/snes/retroarch.cfg.bkp
    local core_config="snes"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
    setRetroArchCoreOption "input_overlay_opacity" "1.0"
    setRetroArchCoreOption "input_overlay_scale" "1.0"
    setRetroArchCoreOption "input_overlay_enable" "true"
    setRetroArchCoreOption "video_smooth" "false"
    setRetroArchCoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp"
    setRetroArchCoreOption "video_shader_enable"  "true" 
    setRetroArchCoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"

  

    cp /home/$user/.config/RetroPie/snesh/retroarch.cfg /home/$user/.config/RetroPie/snesh/retroarch.cfg.bkp
    local core_config="snesh"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
    setRetroArchCoreOption "input_overlay_opacity" "1.0"
    setRetroArchCoreOption "input_overlay_scale" "1.0"
    setRetroArchCoreOption "input_overlay_enable" "true"
    setRetroArchCoreOption "video_smooth" "false"
    setRetroArchCoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp"
    setRetroArchCoreOption "video_shader_enable"  "true" 
    setRetroArchCoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"

  


     cp /home/$user/.config/RetroPie/sfc/retroarch.cfg /home/$user/.config/RetroPie/sfc/retroarch.cfg.bkp
    local core_config="sfc"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
    setRetroArchCoreOption "input_overlay_opacity" "1.0"
    setRetroArchCoreOption "input_overlay_scale" "1.0"
    setRetroArchCoreOption "video_smooth" "false"
    setRetroArchCoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp"
    setRetroArchCoreOption "video_shader_enable"  "true" 
    setRetroArchCoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"

    cp /home/$user/.config/RetroPie/satellaview/retroarch.cfg /home/$user/.config/RetroPie/satellaview/retroarch.cfg.bkp
    local core_config="satellaview"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
    setRetroArchCoreOption "input_overlay_opacity" "1.0"
    setRetroArchCoreOption "input_overlay_scale" "1.0"
    setRetroArchCoreOption "input_overlay_enable" "true"
    setRetroArchCoreOption "video_smooth" "false"
    setRetroArchCoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp"
    setRetroArchCoreOption "video_shader_enable"  "true" 
    setRetroArchCoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"

    cp /home/$user/.config/RetroPie/sufami/retroarch.cfg /home/$user/.config/RetroPie/sufami/retroarch.cfg.bkp
    local core_config="sufami"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
    setRetroArchCoreOption "input_overlay_opacity" "1.0"
    setRetroArchCoreOption "input_overlay_scale" "1.0"
    setRetroArchCoreOption "input_overlay_enable" "true"
    setRetroArchCoreOption "video_smooth" "false"
    setRetroArchCoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp"
    setRetroArchCoreOption "video_shader_enable"  "true" 
    setRetroArchCoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"


    cp /home/$user/.config/RetroPie/smwhacks/retroarch.cfg /home/$user/.config/RetroPie/smwhacks/retroarch.cfg.bkp
    local core_config="smwhacks"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
    setRetroArchCoreOption "input_overlay_opacity" "1.0"
    setRetroArchCoreOption "input_overlay_scale" "1.0"
    setRetroArchCoreOption "input_overlay_enable" "true"
    setRetroArchCoreOption "video_smooth" "false"
    setRetroArchCoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp"
    setRetroArchCoreOption "video_shader_enable"  "true" 
    setRetroArchCoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"



}
