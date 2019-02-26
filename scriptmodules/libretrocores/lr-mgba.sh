#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mgba"
rp_module_desc="(Super) Game Boy Color/GBA emulator - MGBA (optimised) port for libretro"
rp_module_help="ROM Extensions: .gb .gbc .gba .zip\n\nCopy your Game Boy roms to $romdir/gb\nGame Boy Color roms to $romdir/gbc\nGame Boy Advance roms to $romdir/gba\n\nCopy the recommended BIOS files gb_bios.bin, gbc_bios.bin, sgb_bios.bin and gba_bios.bin to $biosdir"
rp_module_licence="MPL2 https://raw.githubusercontent.com/libretro/mgba/master/LICENSE"
rp_module_section="main"
rp_module_flags=""

function sources_lr-mgba() {
    gitPullOrClone "$md_build" https://github.com/libretro/mgba.git
}

function build_lr-mgba() {
    make -f Makefile.libretro clean
    if isPlatform "neon"; then
        make -f Makefile.libretro HAVE_NEON=1
    else
        make -f Makefile.libretro
    fi
    md_ret_require="$md_build/mgba_libretro.so"
}

function install_lr-mgba() {
    md_ret_files=(
        'mgba_libretro.so'
        'CHANGES'
        'LICENSE'
        'README.md'
    )
}

function configure_lr-mgba() {
    local system
    local def
    for system in gb gbh gbc gbch gba gbah; do
        def=0
        [[ "$system" == "gba" ]] && ! isPlatform "armv6" && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 1 "$md_id" "$system" "$md_inst/mgba_libretro.so"
        addSystem "$system"
    done

    if [ -e $md_instppa/mgba_libretro.so ]
        then
          ensureSystemretroconfig "gb"
          ensureSystemretroconfig "gbh"
          ensureSystemretroconfig "gbc"
          ensureSystemretroconfig "gbch"
          ensureSystemretroconfig "gba"
          ensureSystemretroconfig "gbah"
          addEmulator 0 "$md_id-ppa" "gb" "$md_instppa/mgba_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbc" "$md_instppa/mgba_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbah" "$md_instppa/mgba_libretro.so"
          addEmulator 0 "$md_id-ppa" "gba" "$md_instppa/mgba_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbch" "$md_instppa/mgba_libretro.so"
          addSystem "gb"
          addSystem "gbh"
          addSystem "gbah"
          addSystem "gbah"
          addSystem "gbc"
          addSystem "gbch"
    fi

    cp /home/$user/.config/RetroPie/gb/retroarch.cfg /home/$user/.config/RetroPie/gb/retroarch.cfg.bkp
    local core_config="$configdir/gb/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/gb/retroarch.cfg"
    iniSet  "input_overlay" "$raconfigdir/overlays/1080p_4-3/Gameboy_1080p.cfg" "$core_config"
    iniSet  "input_overlay_enable" "true" "$core_config"
    iniSet  "video_fullscreen_x" "1920" "$core_config"
    iniSet  "video_fullscreen_y" "1080" "$core_config"
    iniSet  "custom_viewport_width"  "640" "$core_config"
    iniSet  "custom_viewport_height" "576" "$core_config"
    iniSet  "custom_viewport_x" "640" "$core_config"
    iniSet  "custom_viewport_y"  "257" "$core_config"
    iniSet  "aspect_ratio_index" "23" "$core_config"
    iniSet  "input_overlay_opacity" "0.8" "$core_config"
    iniSet  "input_overlay_scale" "1.0" "$core_config"
    iniSet  "video_shader"  "$raconfigdir/shaders/rpi/handheld/gameboy/gb-shader.glslp" "$core_config"
    iniSet  "video_shader_enable"  "true" "$core_config"
    iniSet  "video_smooth" "false" "$core_config"
    iniSet  "mgba_gb_colorization" "disabled" "$core_config"
    iniSet  "mgba_gb_internal_palette" "GB - DMG" "$core_config"
    iniSet  "mgba_gb_model" "Game Boy" $core_config
    iniSet  "mgba_use_bios" "ON" "$core_config"
    iniSet  "mgba_sgb_borders" "ON" "$core_config"
chown $user:$user "$core_config"


    cp /home/$user/.config/RetroPie/gbh/retroarch.cfg /home/$user/.config/RetroPie/gbh/retroarch.cfg.bkp
    local core_config="$configdir/gbh/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/gbh/retroarch.cfg"
    iniSet  "input_overlay" "$raconfigdir/overlays/1080p_4-3/Gameboy_1080p.cfg" "$core_config"
    iniSet  "input_overlay_enable" "true" "$core_config"
    iniSet  "video_fullscreen_x" "1920" "$core_config"
    iniSet  "video_fullscreen_y" "1080" "$core_config"
    iniSet  "custom_viewport_width"  "640" "$core_config"
    iniSet  "custom_viewport_height" "576" "$core_config"
    iniSet  "custom_viewport_x" "640" "$core_config"
    iniSet  "custom_viewport_y"  "257" "$core_config"
    iniSet  "aspect_ratio_index" "23" "$core_config"
    iniSet  "input_overlay_opacity" "0.8" "$core_config"
    iniSet  "input_overlay_scale" "1.0" "$core_config"
    iniSet  "video_shader"  "$raconfigdir/shaders/rpi/handheld/gameboy/gb-shader.glslp" "$core_config"
    iniSet  "video_shader_enable"  "true" "$core_config"
    iniSet  "video_smooth" "false" "$core_config"
    iniSet  "mgba_gb_colorization" "disabled"
    iniSet  "mgba_gb_internal_palette" "GB - DMG"
    iniSet  "mgba_gb_model" "Game Boy" $core_config
    iniSet  "mgba_use_bios" "ON" "$core_config"
    iniSet  "mgba_sgb_borders" "ON" "$core_config"
chown $user:$user "$core_config"
###Game Boy Color
################################################

    cp /home/$user/.config/RetroPie/gbc/retroarch.cfg /home/$user/.config/RetroPie/gbc/retroarch.cfg.bkp
    local core_config="$configdir/gbc/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/gbc/retroarch.cfg"
    iniSet  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyColor_1080p.cfg" "$core_config"
    iniSet  "input_overlay_enable" "true" "$core_config"
    iniSet  "video_fullscreen_x" "1920" "$core_config"
    iniSet  "video_fullscreen_y" "1080" "$core_config"
    iniSet  "custom_viewport_width"  "640" "$core_config"
    iniSet  "custom_viewport_height" "576" "$core_config"
    iniSet  "custom_viewport_x" "640" "$core_config"
    iniSet  "custom_viewport_y"  "191" "$core_config"
    iniSet  "aspect_ratio_index" "23" "$core_config"
    iniSet  "input_overlay_opacity" "1.0" "$core_config"
    iniSet  "input_overlay_scale" "1.0" "$core_config"
    iniSet  "video_shader"  "$raconfigdir/shaders/rpi/hqx/hq4x.glslp" "$core_config"
    iniSet  "video_shader_enable"  "true" "$core_config"
    iniSet  "video_smooth" "false" "$core_config"
    iniSet  "mgba_gb_model" "Game Boy Color" $core_config
    iniSet  "mgba_use_bios" "ON" "$core_config"
chown $user:$user "$core_config"

    cp /home/$user/.config/RetroPie/gbch/retroarch.cfg /home/$user/.config/RetroPie/gbh/retroarch.cfg.bkp
    local core_config="$configdir/gbch/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/gbch/retroarch.cfg"
    iniSet  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyColor_1080p.cfg" "$core_config"
    iniSet  "input_overlay_enable" "true" "$core_config"
    iniSet  "video_fullscreen_x" "1920" "$core_config"
    iniSet  "video_fullscreen_y" "1080" "$core_config"
    iniSet  "custom_viewport_width"  "640" "$core_config"
    iniSet  "custom_viewport_height" "576" "$core_config"
    iniSet  "custom_viewport_x" "640" "$core_config"
    iniSet  "custom_viewport_y"  "191" "$core_config"
    iniSet  "aspect_ratio_index" "23" "$core_config"
    iniSet  "input_overlay_opacity" "1.0" "$core_config"
    iniSet  "input_overlay_scale" "1.0" "$core_config"
    iniSet  "video_shader"  "$raconfigdir/shaders/rpi/hqx/hq4x.glslp" "$core_config"
    iniSet  "video_shader_enable"  "true" "$core_config"
    iniSet  "video_smooth" "false" "$core_config"
    iniSet  "mgba_gb_model" "Game Boy Color" $core_config
    iniSet  "mgba_use_bios" "ON" "$core_config"
chown $user:$user "$core_config"
##Game Boy Advance
#####################
    cp /home/$user/.config/RetroPie/gba/retroarch.cfg /home/$user/.config/RetroPie/gba/retroarch.cfg.bkp
    local core_config="$configdir/gba/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/gba/retroarch.cfg"
    iniSet  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyAdvance_1080p.cfg" "$core_config"
    iniSet  "input_overlay_enable" "true" "$core_config"
    iniSet  "video_fullscreen_x" "1920" "$core_config"
    iniSet  "video_fullscreen_y" "1080" "$core_config"
    iniSet  "input_overlay_opacity" "1.0" "$core_config"
    iniSet  "input_overlay_scale" "1.0" "$core_config"
    iniSet  "custom_viewport_width"  "960" "$core_config"
    iniSet  "custom_viewport_height" "640" "$core_config"
    iniSet  "custom_viewport_x" "480" "$core_config"
    iniSet  "custom_viewport_y" "220" "$core_config"
    iniSet  "aspect_ratio_index" "23" "$core_config"
    iniSet  "video_shader"  "$raconfigdir/shaders/rpi/retropie/shaders/crt-hyllian-sharpness-hack.glsl" "$core_config"
    iniSet  "video_shader_enable"  "true" "$core_config"
    iniSet  "video_smooth" "false" "$core_config"
    iniSet  "mgba_gb_model" "Game Boy Advance" $core_config
    iniSet  "mgba_use_bios" "ON" "$core_config"
chown $user:$user "$core_config"

    cp /home/$user/.config/RetroPie/gbah/retroarch.cfg /home/$user/.config/RetroPie/gbah/retroarch.cfg.bkp
    local core_config="$configdir/gbah/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/gbah/retroarch.cfg"
    iniSet  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyAdvance_1080p.cfg" "$core_config"
    iniSet  "input_overlay_enable" "true" "$core_config"
    iniSet  "video_fullscreen_x" "1920" "$core_config"
    iniSet  "video_fullscreen_y" "1080" "$core_config"
    iniSet  "input_overlay_opacity" "1.0" "$core_config"
    iniSet  "input_overlay_scale" "1.0" "$core_config"
    iniSet  "custom_viewport_width"  "960" "$core_config"
    iniSet  "custom_viewport_height" "640" "$core_config"
    iniSet  "custom_viewport_x" "480" "$core_config"
    iniSet  "custom_viewport_y" "220" "$core_config"
    iniSet  "aspect_ratio_index" "23" "$core_config"
    iniSet  "video_shader"  "$raconfigdir/shaders/rpi/retropie/shaders/crt-hyllian-sharpness-hack.glsl" "$core_config"
    iniSet  "video_shader_enable"  "true" "$core_config"
    iniSet  "video_smooth" "false" "$core_config"
    iniSet  "mgba_gb_model" "Game Boy Advance" $core_config
    iniSet  "mgba_use_bios" "ON" "$core_config"
chown $user:$user "$core_config"
}
