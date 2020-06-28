#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-beetle-psx"
rp_module_desc="PlayStation emulator - Mednafen PSX Port for libretro"
rp_module_help="ROM Extensions: .bin .cue .cbn .img .iso .m3u .mdf .pbp .toc .z .znx\n\nCopy your PlayStation roms to $romdir/psx\n\nCopy the required BIOS files\n\nscph5500.bin and\nscph5501.bin and\nscph5502.bin to\n\n$biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/beetle-psx-libretro/master/COPYING"
rp_module_section="opt x86=main"
rp_module_flags="!arm"

function depends_lr-beetle-psx() {
    local depends=(libvulkan-dev libgl1-mesa-dev)
    getDepends "${depends[@]}"
}

function sources_lr-beetle-psx() {
    gitPullOrClone "$md_build" https://github.com/libretro/beetle-psx-libretro.git
}

function build_lr-beetle-psx() {
    make clean
    make HAVE_HW=1
    md_ret_require=(
        'mednafen_psx_hw_libretro.so'
    )
}

function install_lr-beetle-psx() {
    md_ret_files=(
        'mednafen_psx_hw_libretro.so'
    )
}

function configure_lr-beetle-psx() {
    local system
    local def
    for system in psx psx-japan; do
        def=0
        [[ "$system" == "psx" || "$system" == "psx-japan" ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 1 "$md_id" "$system" "$md_inst/mednafen_psx_hw_libretro.so"
        addSystem "$system"


        local core_config="$system"
        setRetroArchCoreOption  "core_options_path" "/home/$user/.config/RetroPie/psx/retroarch.cfg"
        setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sony-PlayStation.cfg"
        setRetroArchCoreOption  "input_overlay_opacity" "1.0"
        setRetroArchCoreOption  "input_overlay_scale" "1.0"
        setRetroArchCoreOption  "input_overlay_enable" "true"
        setRetroArchCoreOption  "video_smooth" "true"
        setRetroArchCoreOption  "rewind_enable" "false"
        setRetroArchCoreOption  "game_specific_options" "true"
        setRetroArchCoreOption  "input_player1_analog_dpad_mode" "0"
        setRetroArchCoreOption  "input_player2_analog_dpad_mode" "0"
        setRetroArchCoreOption  "beetle_psx_hw_pgxp_texture" "On"
        setRetroArchCoreOption  "beetle_psx_internal_resolution" "1x(native)"
        setRetroArchCoreOption  "beetle_psx_widescreen_hack" "off"
        setRetroArchCoreOption  "beetle_psx_cd_access_method" "async"
        setRetroArchCoreOption  "beetle_psx_skip_bios"  "on"
        setRetroArchCoreOption  "beetle_psx_skipbios" "enabled"
        setRetroArchCoreOption  "beetle_psx_cd_fastload"  "2x (native)"
        setRetroArchCoreOption  "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"

    done


    addBezel "psx"

    if [ -e $md_instcore/mednafen_psx_hw_libretro.so ] ;
                    then
                        for system in psx psx-japan; do
                            def=0
                            [[ "$system" == "psx" || "$system" == "psx-japan" ]] && def=1
                            addEmulator 0 "$md_id-mednafen_psx_hw-core" "$system" "$md_instcore/mednafen_psx_hw_libretro.so"
                        done
    fi

    if [ -e $md_instcore/mednafen_psx_libretro.so ] ;
                    then
                        for system in psx psx-japan; do
                            def=0
                            [[ "$system" == "psx" || "$system" == "psx-japan" ]] && def=1
                            addEmulator 0 "$md_id-mednafen_psx-core" "$system" "$md_instcore/mednafen_psx_libretro.so"
                        done
    fi


 




}
