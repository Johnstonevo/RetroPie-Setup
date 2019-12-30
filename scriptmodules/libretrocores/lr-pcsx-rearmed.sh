#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-pcsx-rearmed"
rp_module_desc="Playstation emulator - PCSX (arm optimised) port for libretro"
rp_module_help="ROM Extensions: .bin .cue .cbn .img .iso .m3u .mdf .pbp .toc .z .znx\n\nCopy your PSX roms to $romdir/psx\n\nCopy the required BIOS file SCPH1001.BIN to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/pcsx_rearmed/master/COPYING"
rp_module_section="opt arm=main"

function depends_lr-pcsx-rearmed() {
    local depends=(libpng-dev)
    isPlatform "x11" && depends+=(libx11-dev)
    getDepends "${depends[@]}"
}

function sources_lr-pcsx-rearmed() {
    gitPullOrClone "$md_build" https://github.com/libretro/pcsx_rearmed.git
}

function build_lr-pcsx-rearmed() {
    local params=()

    if isPlatform "arm"; then
        params+=(ARCH=arm USE_DYNAREC=1)
        if isPlatform "neon"; then
            params+=(HAVE_NEON=1 BUILTIN_GPU=neon)
        else
            params+=(HAVE_NEON=0 BUILTIN_GPU=peops)
        fi
    fi

    make -f Makefile.libretro "${params[@]}" clean
    make -f Makefile.libretro "${params[@]}"
    md_ret_require="$md_build/pcsx_rearmed_libretro.so"
}

function install_lr-pcsx-rearmed() {
    md_ret_files=(
        'AUTHORS'
        'ChangeLog.df'
        'COPYING'
        'pcsx_rearmed_libretro.so'
        'NEWS'
        'README.md'
        'readme.txt'
    )
}

function configure_lr-pcsx-rearmed() {
    local def
        def=1

    local system
    local def=1
    for system in psx psx-japan  ; do
        def=0
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id" "$system" "$md_inst/pcsx_rearmed_libretro.so"
        addSystem "$system"
        local core_config="$system"
        cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp
        setRetroArchCoreOption "pcsx_rearmed_neon_enhancement_enable" "enabled" # Double resolution
        setRetroArchCoreOption "pcsx_rearmed_neon_enhancement_no_main" "enabled" # Speed hack
        setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sony-PlayStation.cfg"
        setRetroArchCoreOption  "input_overlay_opacity" "1.0"
        setRetroArchCoreOption  "input_overlay_scale" "1.0"
        setRetroArchCoreOption  "input_overlay_enable" "true"
        setRetroArchCoreOption  "video_smooth" "true"
        setRetroArchCoreOption  "rewind_enable" "false"
        setRetroArchCoreOption  "game_specific_options" "true"
        setRetroArchCoreOption  "input_player1_analog_dpad_mode" "0"
        setRetroArchCoreOption  "input_player2_analog_dpad_mode" "0"
        setRetroArchCoreOption  "pcsx_rearmed_neon_enhancement_enable" "enabled"
        setRetroArchCoreOption  "pcsx_rearmed_neon_enhancement_no_main" "enabled"
        setRetroArchCoreOption  "pcsx_rearmed_show_bios_bootlogo" "enabled"
    done


    if [ -e $md_instcore/pcsx1_libretro.so ] ;
                    then
                        for system in psx psx-japan  ; do
                        def=0
                        mkRomDir "$system"
                        ensureSystemretroconfig "$system"
                        addEmulator def "$md_id-core" "$system" "$md_instcore/pcsx_rearmed_libretro.so"
                        addSystem "$system"
                    done



    fi
        addBezel "psx"


    

}
