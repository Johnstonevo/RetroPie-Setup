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
    for system in gb gbh gbc gbch gba; do
        def=0
        [[ "$system" == "gba" ]] && ! isPlatform "armv6" && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 0 "$md_id" "$system" "$md_inst/mgba_libretro.so"
        addSystem "$system"
    done

    if [ -e $md_instppa/mgba_libretro.so ]
        then
          ensureSystemretroconfig "gb"
          ensureSystemretroconfig "gbh"
          ensureSystemretroconfig "gbc"
          ensureSystemretroconfig "gbch"
          addEmulator 0 "$md_id-ppa" "gb" "$md_instppa/mgba_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbc" "$md_instppa/mgba_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbh" "$md_instppa/mgba_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbch" "$md_instppa/mgba_libretro.so"
          addSystem "gb"
          addSystem "gbh"
          addSystem "gbc"
          addSystem "gbch"
    fi

    cp /home/$user/.config/RetroPie/gb/retroarch.cfg /home/$user/.config/RetroPie/gb/retroarch.cfg.bkp
    local core_config="$configdir/gb/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/gb/retroarch.cfg"
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
    iniSet  "video_aspect_ratio_auto" "true"
    iniSet "mgba_gb_colorization" "disabled"
    iniSet  "mgba_gb_internal_palette" "GB - DMG"

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
    iniSet  "video_aspect_ratio_auto" "true"
    iniSet "mgba_gb_colorization" "disabled"
    iniSet  "mgba_gb_internal_palette" "GB - DMG"

}
