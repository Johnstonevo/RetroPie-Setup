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
    local core_config="gb"
    setRetroArchcoreOption  "input_overlay" "$raconfigdir/overlays/1080p_4-3/Gameboy_1080p.cfg"
    setRetroArchcoreOption  "input_overlay_enable" "true"
    setRetroArchcoreOption  "input_overlay_opacity" "0.8"
    setRetroArchcoreOption  "input_overlay_scale" "1.0"
    setRetroArchcoreOption  "video_shader"  "$raconfigdir/shaders/rpi/handheld/gameboy/gb-shader.glslp"
    setRetroArchcoreOption  "video_shader_enable"  "true"
    setRetroArchcoreOption  "video_smooth" "false"
    setRetroArchcoreOption  "mgba_gb_colorization" "disabled"
    setRetroArchcoreOption  "mgba_gb_internal_palette" "GB - DMG"
    setRetroArchcoreOption  "mgba_gb_model" "Game Boy"
    setRetroArchcoreOption  "mgba_use_bios" "ON"
    setRetroArchcoreOption  "mgba_sgb_borders" "ON"


    cp /home/$user/.config/RetroPie/gbh/retroarch.cfg /home/$user/.config/RetroPie/gbh/retroarch.cfg.bkp
    local core_config="gbh"
    setRetroArchcoreOption  "input_overlay" "$raconfigdir/overlays/1080p_4-3/Gameboy_1080p.cfg"
    setRetroArchcoreOption  "input_overlay_enable" "true"
    setRetroArchcoreOption  "input_overlay_opacity" "0.8"
    setRetroArchcoreOption  "input_overlay_scale" "1.0"
    setRetroArchcoreOption  "video_shader"  "$raconfigdir/shaders/rpi/handheld/gameboy/gb-shader.glslp"
    setRetroArchcoreOption  "video_shader_enable"  "true"
    setRetroArchcoreOption  "video_smooth" "false"
    setRetroArchcoreOption  "mgba_gb_colorization" "disabled"
    setRetroArchcoreOption  "mgba_gb_internal_palette" "GB - DMG"
    setRetroArchcoreOption  "mgba_gb_model" "Game Boy"
    setRetroArchcoreOption  "mgba_use_bios" "ON"
    setRetroArchcoreOption  "mgba_sgb_borders" "ON"


###Game Boy Color
################################################

    cp /home/$user/.config/RetroPie/gbc/retroarch.cfg /home/$user/.config/RetroPie/gbc/retroarch.cfg.bkp
    local core_config="gbc"
    setRetroArchcoreOption  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyColor_1080p.cfg"
    setRetroArchcoreOption  "input_overlay_enable" "true"
    setRetroArchcoreOption  "input_overlay_opacity" "1.0"
    setRetroArchcoreOption  "input_overlay_scale" "1.0"
    setRetroArchcoreOption  "video_shader"  "$raconfigdir/shaders/rpi/hqx/hq4x.glslp"
    setRetroArchcoreOption  "video_shader_enable"  "true"
    setRetroArchcoreOption  "video_smooth" "false"
    setRetroArchcoreOption  "mgba_gb_model" "Game Boy Color"
    setRetroArchcoreOption  "mgba_use_bios" "ON"

    cp /home/$user/.config/RetroPie/gbch/retroarch.cfg /home/$user/.config/RetroPie/gbh/retroarch.cfg.bkp
    local core_config="gbch"
    setRetroArchcoreOption  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyColor_1080p.cfg"
    setRetroArchcoreOption  "input_overlay_enable" "true"
    setRetroArchcoreOption  "input_overlay_opacity" "1.0"
    setRetroArchcoreOption  "input_overlay_scale" "1.0"
    setRetroArchcoreOption  "video_shader"  "$raconfigdir/shaders/rpi/hqx/hq4x.glslp"
    setRetroArchcoreOption  "video_shader_enable"  "true"
    setRetroArchcoreOption  "video_smooth" "false"
    setRetroArchcoreOption  "mgba_gb_model" "Game Boy Color"
    setRetroArchcoreOption  "mgba_use_bios" "ON"


##Game Boy Advance
#####################
    cp /home/$user/.config/RetroPie/gba/retroarch.cfg /home/$user/.config/RetroPie/gba/retroarch.cfg.bkp
    local core_config="gba"
    setRetroArchcoreOption  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyAdvance_1080p.cfg"
    setRetroArchcoreOption  "input_overlay_enable" "true"
    setRetroArchcoreOption  "input_overlay_opacity" "1.0"
    setRetroArchcoreOption  "input_overlay_scale" "1.0"
    setRetroArchcoreOption  "video_shader"  "$raconfigdir/shaders/rpi/retropie/shaders/crt-hyllian-sharpness-hack.glsl"
    setRetroArchcoreOption  "video_shader_enable"  "true"
    setRetroArchcoreOption  "video_smooth" "false"
    setRetroArchcoreOption  "mgba_gb_model" "Game Boy Advance"
    setRetroArchcoreOption  "mgba_use_bios" "ON"

    cp /home/$user/.config/RetroPie/gbah/retroarch.cfg /home/$user/.config/RetroPie/gbah/retroarch.cfg.bkp
    local core_config="gbah"
    setRetroArchcoreOption  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyAdvance_1080p.cfg"
    setRetroArchcoreOption  "input_overlay_enable" "true"
    setRetroArchcoreOption  "input_overlay_opacity" "1.0"
    setRetroArchcoreOption  "input_overlay_scale" "1.0"
    setRetroArchcoreOption  "video_shader"  "$raconfigdir/shaders/rpi/retropie/shaders/crt-hyllian-sharpness-hack.glsl"
    setRetroArchcoreOption  "video_shader_enable"  "true"
    setRetroArchcoreOption  "video_smooth" "false"
    setRetroArchcoreOption  "mgba_gb_model" "Game Boy Advance"
    setRetroArchcoreOption  "mgba_use_bios" "ON"
}
