#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-desmume"
rp_module_desc="NDS emu - DESMUME"
rp_module_help="ROM Extensions: .nds .zip\n\nCopy your Nintendo DS roms to $romdir/nds"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/desmume/master/desmume/COPYING"
rp_module_section="exp"

function sources_lr-desmume() {
    gitPullOrClone "$md_build" https://github.com/libretro/desmume.git
}

function build_lr-desmume() {
    cd desmume/src/frontend/libretro
    local params=()
    isPlatform "arm" && params+=("platform=armvhardfloat")
    make clean
    make "${params[@]}"
    md_ret_require="$md_build/desmume/src/frontend/libretro/desmume_libretro.so"
}

function install_lr-desmume() {
    md_ret_files=(
        'desmume/src/frontend/libretro/desmume_libretro.so'
    )
}

function configure_lr-desmume() {
    mkRomDir "nds"
    ensureSystemretroconfig "nds"

    addEmulator 1 "$md_id" "nds" "$md_inst/desmume_libretro.so"
    addSystem "nds"
    local core_config="$configdir/nds/retroarch.cfg"
        iniConfig " = " '"' "$md_conf_root/nds/retroarch.cfg"
        iniSet  "core_options_path" "/home/$user/.config/RetroPie/nds/retroarch.cfg" "$core_config"
        iniSet  "input_overlay_enable" "true" "$core_config"
        iniSet  "input_overlay" "/home/$user/.config/retroarch/overlays/handhelds/ds.cfg" "$core_config"
        iniSet  "input_overlay_opacity" "1.0" "$core_config"
        iniSet  "input_overlay_scale" "1.0" "$core_config"
        iniSet  "video_shader_enable"  "true" "$core_config"
        iniSet  "video_shader" "/home/$user/.config/retroarch/shaders/handheld/nds.cgp" "$core_config"
        iniSet  "desmume_screens_gap" "90" "$core_config"
        iniSet  "desmume_pointer_device_r" "emulated" "$core_config"
        iniSet  "aspect_ratio_index"  "20" "$core_config"
        iniSet  "video_scale"  "5.000000" "$core_config"
        iniSet  "video_scale_integer"  "true" "$core_config"
        iniSet  "custom_viewport_height"  "768" "$core_config"
        iniSet  "custom_viewport_width"  "512" "$core_config"

    if [ -e $md_instppa/desmume_libretro.so ]
        then
    mkRomDir "nds"
    ensureSystemretroconfig "nds"

    addEmulator 0 "$md_id-ppa" "nds" "$md_instppa/desmume_libretro.so"
    addSystem "nds"
    fi
}
