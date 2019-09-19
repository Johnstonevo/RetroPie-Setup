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
    local system
    local def
    for system in gbc gbch gb gbh  ; do
        def=0
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id" "$system" "$md_inst/tgbdual_libretro.so"
        addSystem "$system"
        
        cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp
        local core_config="$system"
        setRetroArchCoreOptiom  "input_overlay_enable" "true"
        setRetroArchCoreOptiom  "input_overlay_opacity" "1.0"
        setRetroArchCoreOptiom  "input_overlay_scale" "1.0"
        setRetroArchCoreOptiom  "tgbdual_gb_colorization" "disabled"
        setRetroArchCoreOptiom  "tgbdual_gb_internal_palette" "GB - DMG"

    done

    if [ -e $md_instcore/tgbdual_libretro.so ]
        then
            local system
            local def
            for system in gbc gbch gb gbh  ; do
                def=0
                mkRomDir "$system"
                ensureSystemretroconfig "$system"
                addEmulator def "$md_id-core" "$system" "$md_instcore/tgbdual_libretro.so"
                addSystem "$system"
            done
    fi

    for system in gb gbh  ; do

        cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp
        local core_config="$system"
        setRetroArchCoreOptiom  "input_overlay" "$raconfigdir/overlays/1080p_4-3/Gameboy_1080p.cfg"
        setRetroArchCoreOptiom  "video_shader"  "$raconfigdir/shaders/rpi/handheld/gameboy/gb-shader.glslp"
        setRetroArchCoreOptiom  "video_shader_enable"  "true"
        setRetroArchCoreOptiom  "video_smooth" "false"
    done


    for system in gbc gbch  ; do
        cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp
        local core_config="$system"
        setRetroArchCoreOptiom  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyColor_1080p.cfg"
        setRetroArchCoreOptiom  "video_shader"  "$raconfigdir/shaders/rpi/hqx/hq4x.glslp"
        setRetroArchCoreOptiom  "video_shader_enable"  "true"
        setRetroArchCoreOptiom  "video_smooth" "false"
    done


}
