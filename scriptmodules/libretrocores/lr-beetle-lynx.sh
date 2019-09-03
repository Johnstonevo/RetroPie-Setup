#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-beetle-lynx"
rp_module_desc="Atari Lynx emulator - Mednafen Lynx Port for libretro, itself a fork of Handy"
rp_module_help="ROM Extensions: .lnx .zip\n\nCopy your Atari Lynx roms to $romdir/atarilynx\n\nCopy the required BIOS file lynxboot.img to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/beetle-lynx-libretro/master/COPYING"
rp_module_section="opt"

function sources_lr-beetle-lynx() {
    gitPullOrClone "$md_build" https://github.com/libretro/beetle-lynx-libretro.git
}

function build_lr-beetle-lynx() {
    make clean
    make
    md_ret_require="$md_build/mednafen_lynx_libretro.so"
}

function install_lr-beetle-lynx() {
    md_ret_files=(
        'mednafen_lynx_libretro.so'
    )
}

function configure_lr-beetle-lynx() {
    mkRomDir "atarilynx"
    ensureSystemretroconfig "atarilynx"

    addEmulator 0 "$md_id" "atarilynx" "$md_inst/mednafen_lynx_libretro.so"
    addSystem "atarilynx"

    if [ -e $md_instppa/mednafen_lynx_libretro.so ]
        then
        mkRomDir "atarilynx"
        ensureSystemretroconfig "atarilynx"

        addEmulator 0 "$md_id-ppa" "atarilynx" "$md_instppa/handy_libretro.so"
        addSystem "atarilynx"
  fi

    local core_config="atarilynx"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlays/1080p_4-3/Lynx_1080p.cfg" 
    setRetroArchCoreOption "input_overlay_enable" "true" 
    setRetroArchCoreOption "video_smooth" "false" 
    setRetroArchCoreOption "input_overlay_opacity" "1.0" 
    setRetroArchCoreOption "input_overlay_scale" "1.0" 
    setRetroArchCoreOption  "video_shader" "$raconfigdir/shaders/rpi/retropie/shaders/crt-hyllian-sharpness-hack.glsl" 
    setRetroArchCoreOption  "video_shader_enable"  "true" 
    setRetroArchCoreOption  "video_smooth"  "false" 
  
}
