#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-snes9x"
rp_module_desc="Super Nintendo emu - Snes9x (current) port for libretro"
rp_module_help="ROM Extensions: .bin .smc .sfc .fig .swc .mgd .zip\n\nCopy your SNES roms to $romdir/snes"
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/snes9x/master/docs/snes9x-license.txt"
rp_module_section="main"

function sources_lr-snes9x() {
    gitPullOrClone "$md_build" https://github.com/libretro/snes9x.git
}

function build_lr-snes9x() {
    cd libretro
    make clean
    local platform=""
    isPlatform "arm" && platform+="armv"
    isPlatform "neon" && platform+="neon"
    if [[ -n "$platform" ]]; then
        CXXFLAGS+=" -DARM" make platform="$platform"
    else
        make
    fi
    md_ret_require="$md_build/libretro/snes9x_libretro.so"
}

function install_lr-snes9x() {
    md_ret_files=(
        'libretro/snes9x_libretro.so'
        'docs'
    )
}

function configure_lr-snes9x() {
    mkRomDir "snes"
    mkRomDir "snesh"
    mkRomDir "sfc"
    mkRomDir "snesmsu1"
    mkRomDir "satellaview"
    mkRomDir "sufami"
    ensureSystemretroconfig "snes"
    ensureSystemretroconfig "snesh"
    ensureSystemretroconfig "sfc"
    ensureSystemretroconfig "snesmsu1"
    ensureSystemretroconfig "satellaview"
    ensureSystemretroconfig "sufami"

    addEmulator 0 "$md_id" "snes" "$md_inst/snes9x_libretro.so"
    addEmulator 1 "$md_id" "snesh" "$md_inst/snes9x_libretro.so"
    addEmulator 0 "$md_id" "sfc" "$md_inst/snes9x_libretro.so"
    addEmulator 1 "$md_id" "snesmsu1" "$md_inst/snes9x_libretro.so"
    addEmulator 0 "$md_id" "satellaview" "$md_inst/snes9x_libretro.so"
    addEmulator 0 "$md_id" "sufami" "$md_inst/snes9x_libretro.so"
    addSystem "snes"
    addSystem "snesh"
    addSystem "sfc"
    addSystem "snesmsu1"
    addSystem "satellaview"
    addSystem "sufami"

    addBezel "snes"
    addBezel "sfc"

    if [ -e $md_instppa/snes9x_libretro.so ]
        then
          addEmulator 0 "$md_id-ppa" "snes" "$md_instppa/snes9x_libretro.so"
          addEmulator 0 "$md_id-ppa" "snesh" "$md_instppa/snes9x_libretro.so"
          addEmulator 0 "$md_id-ppa" "sfc" "$md_instppa/snes9x_libretro.so"
          addEmulator 0 "$md_id-ppa" "snesmsu1" "$md_instppa/snes9x_libretro.so"
          addEmulator 0 "$md_id-ppa" "satellaview" "$md_instppa/snes9x_libretro.so"
          addEmulator 0 "$md_id-ppa" "sufami" "$md_instppa/snes9x_libretro.so"
    fi


             cp /home/$user/.config/RetroPie/snes/retroarch.cfg /home/$user/.config/RetroPie/snes/retroarch.cfg.bkp
            local core_config="$configdir/snes/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/snes/retroarch.cfg"
            iniSet  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            iniSet "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp" "$core_config"
            iniSet "video_shader_enable"  "true" "$core_config" 
            iniSet "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie" "$core_config"
            chown $user:$user "$core_config"
           
           
             cp /home/$user/.config/RetroPie/snesh/retroarch.cfg /home/$user/.config/RetroPie/snesh/retroarch.cfg.bkp
            local core_config="$configdir/snesh/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/snesh/retroarch.cfg"
            iniSet  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            iniSet "video_smooth" "false" "$core_config"
            iniSet "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp" "$core_config"
            iniSet "video_shader_enable"  "true" "$core_config" 
            iniSet "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie" "$core_config"

            chown $user:$user "$core_config"
             cp /home/$user/.config/RetroPie/snesmsu1/retroarch.cfg /home/$user/.config/RetroPie/snesmsu1/retroarch.cfg.bkp
            local core_config="$configdir/snesmsu1/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/snesmsu1/retroarch.cfg"
            iniSet  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
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
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            iniSet "video_smooth" "false" "$core_config"
            iniSet "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp" "$core_config"
            iniSet "video_shader_enable"  "true" "$core_config" 
            iniSet "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie" "$core_config"

            chown $user:$user "$core_config"
             cp /home/$user/.config/RetroPie/satellaview/retroarch.cfg /home/$user/.config/RetroPie/satellaview/retroarch.cfg.bkp
            local core_config="$configdir/satellaview/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/satellaview/retroarch.cfg"
            iniSet  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
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
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            iniSet "video_smooth" "false" "$core_config"
            iniSet "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp" "$core_config"
            iniSet "video_shader_enable"  "true" "$core_config" 
            iniSet "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie" "$core_config"

            chown $user:$user "$core_config"

}
