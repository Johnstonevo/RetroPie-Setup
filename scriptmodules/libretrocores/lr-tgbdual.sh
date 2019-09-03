#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-tgbdual"
rp_module_desc="Gameboy Color emu - TGB Dual port for libretro"
rp_module_help="ROM Extensions: .gb .gbc .zip\n\nCopy your GameBoy roms to $romdir/gb\n\nCopy your GameBoy Color roms to $romdir/gbc"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/tgbdual-libretro/master/docs/COPYING-2.0.txt"
rp_module_section="opt"

function sources_lr-tgbdual() {
    gitPullOrClone "$md_build" https://github.com/libretro/tgbdual-libretro.git
}

function build_lr-tgbdual() {
    make clean
    make
    md_ret_require="$md_build/tgbdual_libretro.so"
}

function install_lr-tgbdual() {
    md_ret_files=(
        'tgbdual_libretro.so'
    )
}

function configure_lr-tgbdual() {
    mkRomDir "gbc"
    mkRomDir "gbch"
    mkRomDir "gb"
    mkRomDir "gbh"
    ensureSystemretroconfig "gb"
    ensureSystemretroconfig "gbh"
    ensureSystemretroconfig "gbc"
    ensureSystemretroconfig "gbch"



    addEmulator 0 "$md_id" "gb" "$md_inst/tgbdual_libretro.so"
    addEmulator 0 "$md_id" "gbh" "$md_inst/tgbdual_libretro.so"
    addEmulator 0 "$md_id" "gbc" "$md_inst/tgbdual_libretro.so"
    addEmulator 0 "$md_id" "gbch" "$md_inst/tgbdual_libretro.so"
    addSystem "gb"
    addSystem "gbh"
    addSystem "gbc"
    addSystem "gbch"

    if [ -e $md_instppa/tgbdual_libretro.so ]
        then
          ensureSystemretroconfig "gb"
          ensureSystemretroconfig "gbh"
          ensureSystemretroconfig "gbc"
          ensureSystemretroconfig "gbch"
          addEmulator 0 "$md_id-ppa" "gb" "$md_instppa/tgbdual_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbc" "$md_instppa/tgbdual_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbch" "$md_instppa/tgbdual_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbh" "$md_instppa/tgbdual_libretro.so"
          addSystem "gb"
          addSystem "gbh"
          addSystem "gbc"
          addSystem "gbch"
    fi

    cp /home/$user/.config/RetroPie/gb/retroarch.cfg /home/$user/.config/RetroPie/gb/retroarch.cfg.bkp
    local core_config="gbg"
    setRetroArchCoreOptiom  "input_overlay" "$raconfigdir/overlays/1080p_4-3/Gameboy_1080p.cfg"
    setRetroArchCoreOptiom  "input_overlay_enable" "true"
    setRetroArchCoreOptiom  "video_fullscreen_x" "1920"
    setRetroArchCoreOptiom  "video_fullscreen_y" "1080"
    setRetroArchCoreOptiom  "custom_viewport_width"  "640"
    setRetroArchCoreOptiom  "custom_viewport_height" "576"
    setRetroArchCoreOptiom  "custom_viewport_x" "640"
    setRetroArchCoreOptiom  "custom_viewport_y"  "257"
    setRetroArchCoreOptiom  "aspect_ratio_index" "23"
    setRetroArchCoreOptiom  "input_overlay_opacity" "0.8"
    setRetroArchCoreOptiom  "input_overlay_scale" "1.0"
    setRetroArchCoreOptiom  "video_shader"  "$raconfigdir/shaders/rpi/handheld/gameboy/gb-shader.glslp"
    setRetroArchCoreOptiom  "video_shader_enable"  "true"
    setRetroArchCoreOptiom  "video_smooth" "false"
    setRetroArchCoreOptiom  "tgbdual_gb_colorization" "disabled"
    setRetroArchCoreOptiom  "tgbdual_gb_internal_palette" "GB - DMG"

    cp /home/$user/.config/RetroPie/gbh/retroarch.cfg /home/$user/.config/RetroPie/gbh/retroarch.cfg.bkp
    local core_config="gbh"
    setRetroArchCoreOptiom  "input_overlay" "$raconfigdir/overlays/1080p_4-3/Gameboy_1080p.cfg"
    setRetroArchCoreOptiom  "input_overlay_enable" "true"
    setRetroArchCoreOptiom  "video_fullscreen_x" "1920"
    setRetroArchCoreOptiom  "video_fullscreen_y" "1080"
    setRetroArchCoreOptiom  "custom_viewport_width"  "640"
    setRetroArchCoreOptiom  "custom_viewport_height" "576"
    setRetroArchCoreOptiom  "custom_viewport_x" "640"
    setRetroArchCoreOptiom  "custom_viewport_y"  "257"
    setRetroArchCoreOptiom  "aspect_ratio_index" "23"
    setRetroArchCoreOptiom  "input_overlay_opacity" "0.8"
    setRetroArchCoreOptiom  "input_overlay_scale" "1.0"
    setRetroArchCoreOptiom  "video_shader"  "$raconfigdir/shaders/rpi/handheld/gameboy/gb-shader.glslp"
    setRetroArchCoreOptiom  "video_shader_enable"  "true"
    setRetroArchCoreOptiom  "video_smooth" "false"
    setRetroArchCoreOptiom  "tgbdual_gblink_enable" "enabled"
    setRetroArchCoreOptiom  "tgbdual_gb_internal_palette" "GB - DMG"



    cp /home/$user/.config/RetroPie/gbc/retroarch.cfg /home/$user/.config/RetroPie/gbc/retroarch.cfg.bkp
    local core_config="gbc"
    setRetroArchCoreOptiom  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyColor_1080p.cfg"
    setRetroArchCoreOptiom  "input_overlay_enable" "true"
    setRetroArchCoreOptiom  "video_fullscreen_x" "1920"
    setRetroArchCoreOptiom  "video_fullscreen_y" "1080"
    setRetroArchCoreOptiom  "custom_viewport_width"  "640"
    setRetroArchCoreOptiom  "custom_viewport_height" "576"
    setRetroArchCoreOptiom  "custom_viewport_x" "640"
    setRetroArchCoreOptiom  "custom_viewport_y"  "191"
    setRetroArchCoreOptiom  "aspect_ratio_index" "23"
    setRetroArchCoreOptiom  "input_overlay_opacity" "1.0"
    setRetroArchCoreOptiom  "input_overlay_scale" "1.0"
    setRetroArchCoreOptiom  "video_shader"  "$raconfigdir/shaders/rpi/hqx/hq4x.glslp"
    setRetroArchCoreOptiom  "video_shader_enable"  "true"
    setRetroArchCoreOptiom  "video_smooth" "false"

    cp /home/$user/.config/RetroPie/gbch/retroarch.cfg /home/$user/.config/RetroPie/gbh/retroarch.cfg.bkp
    local core_config="gbch"
    setRetroArchCoreOptiom  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyColor_1080p.cfg"
    setRetroArchCoreOptiom  "input_overlay_enable" "true"
    setRetroArchCoreOptiom  "video_fullscreen_x" "1920"
    setRetroArchCoreOptiom  "video_fullscreen_y" "1080"
    setRetroArchCoreOptiom  "custom_viewport_width"  "640"
    setRetroArchCoreOptiom  "custom_viewport_height" "576"
    setRetroArchCoreOptiom  "custom_viewport_x" "640"
    setRetroArchCoreOptiom  "custom_viewport_y"  "191"
    setRetroArchCoreOptiom  "aspect_ratio_index" "23"
    setRetroArchCoreOptiom  "input_overlay_opacity" "1.0"
    setRetroArchCoreOptiom  "input_overlay_scale" "1.0"
    setRetroArchCoreOptiom  "video_shader"  "$raconfigdir/shaders/rpi/hqx/hq4x.glslp"
    setRetroArchCoreOptiom  "video_shader_enable"  "true"
    setRetroArchCoreOptiom  "video_smooth" "false"
}
