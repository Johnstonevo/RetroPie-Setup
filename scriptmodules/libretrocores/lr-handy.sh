#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-handy"
rp_module_desc="Atari Lynx emulator - Handy port for libretro"
rp_module_help="ROM Extensions: .lnx .zip\n\nCopy your Atari Lynx roms to $romdir/atarilynx"
rp_module_licence="ZLIB https://raw.githubusercontent.com/libretro/libretro-handy/master/lynx/license.txt"
rp_module_section="main"

function sources_lr-handy() {
    gitPullOrClone "$md_build" https://github.com/libretro/libretro-handy.git
}

function build_lr-handy() {
    make clean
    make
    md_ret_require="$md_build/handy_libretro.so"
}

function install_lr-handy() {
    md_ret_files=(
        'handy_libretro.so'
        'README.md'
    )
}

function configure_lr-handy() {
    mkRomDir "atarilynx"
    ensureSystemretroconfig "atarilynx"

    addEmulator 1 "$md_id" "atarilynx" "$md_inst/handy_libretro.so"
    addSystem "atarilynx"

    if [ -e $md_instppa/handy_libretro.so ]
        then
        mkRomDir "atarilynx"
        ensureSystemretroconfig "atarilynx"

        addEmulator 1 "$md_id-ppa" "atarilynx" "$md_instppa/handy_libretro.so"
        addSystem "atarilynx"
  fi

    cp /home/$user/.config/RetroPie/atarilynx/retroarch.cfg /home/$user/.config/RetroPie/atarilynx/retroarch.cfg.bkp
    local core_config="$configdir/atarilynx/retroarch.cfg"
    iniConfig " = " '"' "$md_conf_root/atarilynx/retroarch.cfg"
    iniSet  "input_overlay" "$raconfigdir/overlays/1080p_4-3/Lynx_1080p.cfg" "$core_config"
    iniSet "input_overlay_enable" "true" "$core_config"
    iniSet "video_smooth" "false" "$core_config"
    iniSet "input_overlay_opacity" "1.0" "$core_config"
    iniSet "input_overlay_scale" "1.0" "$core_config"
    iniSet  "video_shader" "$raconfigdir/shaders/rpi/retropie/shaders/crt-hyllian-sharpness-hack.glsl" "$core_config"
    iniSet  "video_shader_enable"  "true" "$core_config"
    iniSet  "video_smooth"  "false" "$core_config"
    chown $user:$user "$core_config"
}
