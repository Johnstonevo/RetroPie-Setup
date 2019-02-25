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
    mkRomDir "gb"
    mkRomDir "gbh"
    ensureSystemretroconfig "gb"
    ensureSystemretroconfig "gbh"
    ensureSystemretroconfig "gbc"

    # enable dual / link by default
    setRetroArchCoreOption "tgbdual_gblink_enable" "enabled"

    addEmulator 0 "$md_id" "gb" "$md_inst/tgbdual_libretro.so"
    addEmulator 0 "$md_id" "gbh" "$md_inst/tgbdual_libretro.so"
    addEmulator 0 "$md_id" "gbc" "$md_inst/tgbdual_libretro.so"
    addSystem "gb"
    addSystem "gbh"
    addSystem "gbc"

    if [ -e $md_instppa/tgbdual_libretro.so ]
        then
          ensureSystemretroconfig "gb"
          ensureSystemretroconfig "gbh"
          ensureSystemretroconfig "gbc"
          addEmulator 0 "$md_id-ppa" "gb" "$md_instppa/tgbdual_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbc" "$md_instppa/tgbdual_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbh" "$md_instppa/tgbdual_libretro.so"
          addSystem "gb"
          addSystem "gbh"
          addSystem "gbc"
    fi

    cp /home/$user/.config/RetroPie/gb/retroarch.cfg /home/$user/.config/RetroPie/gb/retroarch.cfg.bkp
    local core_config="$configdir/gb/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/gb/retroarch.cfg"
    iniSet  "input_overlay" "/home/$user/.config/retroarch/overlays/gb-clear.cfg" "$core_config"
    iniSet   "tgbdual_gb_colorization" "auto" "$core_config"
    iniSet  "input_overlay_enable" "true" "$core_config"
    iniSet "input_overlay_opacity" "0.8" "$core_config"
    iniSet "input_overlay_scale" "1.0" "$core_config"
    iniSet "video_fullscreen_x" "1920" "$core_config"
    iniSet "video_fullscreen_y" "1080" "$core_config"
    iniSet "video_smooth" "false" "$core_config"
    iniSet  "video_shader" "/home/$user/.config/retroarch/shaders/handheld/gb-shader.cgp" "$core_config"
    iniSet  "video_shader_enable"  "true" "$core_config"
    iniSet  "aspect_ratio_index"  "23" "$core_config"
    iniSet  "custom_viewport_width"  "960" "$core_config"
    iniSet  "custom_viewport_height"  "854" "$core_config"
    iniSet  "video_scale_integer" "true" "$core_config"
    iniSet  "video_aspect_ratio_auto" "true"
    iniSet "tgbdual_gb_colorization" "disabled"
    iniSet  "tgbdual_gb_internal_palette" "GB - DMG"

    cp /home/$user/.config/RetroPie/gbh/retroarch.cfg /home/$user/.config/RetroPie/gbh/retroarch.cfg.bkp
    local core_config="$configdir/gbh/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/gbh/retroarch.cfg"
    iniSet  "input_overlay" "/home/$user/.config/retroarch/overlays/gb-clear.cfg" "$core_config"
    iniSet  "input_overlay_enable" "true" "$core_config"
    iniSet "input_overlay_opacity" "0.8" "$core_config"
    iniSet "input_overlay_scale" "1.0" "$core_config"
    iniSet "video_fullscreen_x" "1920" "$core_config"
    iniSet "video_fullscreen_y" "1080" "$core_config"
    iniSet "video_smooth" "false" "$core_config"
    iniSet  "video_shader" "/home/$user/.config/retroarch/shaders/handheld/gb-shader.cgp" "$core_config"
    iniSet  "video_shader_enable"  "true" "$core_config"
    iniSet  "aspect_ratio_index"  "23" "$core_config"
    iniSet  "custom_viewport_width"  "960" "$core_config"
    iniSet  "custom_viewport_height"  "854" "$core_config"
    iniSet  "video_scale_integer" "true" "$core_config"
    iniSet  "video_aspect_ratio_auto" "true" "$core_config"
    iniSet "tgbdual_gblink_enable" "enabled" "$core_config"

}
