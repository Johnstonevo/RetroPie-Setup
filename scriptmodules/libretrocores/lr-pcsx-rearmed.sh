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
rp_module_section="main"

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
        mkRomDir "psx"
        ensureSystemretroconfig "psx"
        addEmulator 1 "$md_id" "psx" "$md_inst/libretro.so"
        addSystem "psx"
        addBezel "psx"
        mkRomDir "psx-japan"
        ensureSystemretroconfig "psx-japan"
        addEmulator 1 "$md_id" "psx-japan" "$md_inst/libretro.so"
        addSystem "psx-japan"

        setRetroArchCoreOption "pcsx_rearmed_neon_enhancement_enable" "enabled" # Double resolution
        setRetroArchCoreOption "pcsx_rearmed_neon_enhancement_no_main" "enabled" # Speed hack

    if [ -e $md_instppa/pcsx1_libretro.so ]
                    then
                                addEmulator 0 "$md_id-ppa" "psx" "$md_instppa/pcsx1_libretro.so"
                                addSystem "psx" "$md_instppa/pcsx1_libretro.so"
                                addEmulator 0 "$md_id-ppa" "psx-japan" "$md_instppa/pcsx1_libretro.so"
                                addSystem "psx-japan" "$md_instppa/pcsx1_libretro.so"


    fi

        ln -s $raconfigdir/config/PCSX-ReARMed  $raconfigdir/config/Beetle\ PSX

        local core_config="$configdir/psx/retroarch.cfg"
        iniConfig " = " '"' "$md_conf_root/psx/retroarch.cfg"
        iniSet  "core_options_path" "/home/$user/.config/RetroPie/psx/retroarch.cfg" "$core_config"
        iniSet  "input_overlay" "$raconfigdir/overlay/Sony-PlayStation.cfg" "$core_config"
        iniSet  "input_overlay_opacity" "1.0" "$core_config"
        iniSet  "input_overlay_scale" "1.0" "$core_config"
        iniSet  "video_fullscreen_x" "1920" "$core_config"
        iniSet  "video_fullscreen_y" "1080" "$core_config"
        iniSet  "input_overlay_enable" "true" "$core_config"
        iniSet  "video_smooth" "true" "$core_config"
        iniSet  "rewind_enable" "false" "$core_config"
        iniSet  "game_specific_options" "true" "$core_config"
        iniSet  "input_player1_analog_dpad_mode" "0" "$core_config"
        iniSet  "input_player2_analog_dpad_mode" "0" "$core_config"
        iniSet  "pcsx_rearmed_neon_enhancement_enable" "enabled" "$core_config"
        iniSet  "pcsx_rearmed_neon_enhancement_no_main" "enabled" "$core_config"
        iniSet  "pcsx_rearmed_show_bios_bootlogo" "enabled" "$core_config"
        chown $user:$user "$core_config"


        local core_config="$configdir/psx-japan/retroarch.cfg"
        iniConfig " = " '"' "$md_conf_root/psx-japan/retroarch.cfg"
        iniSet  "core_options_path" "/home/$user/.config/RetroPie/psx-japan/retroarch.cfg" "$core_config"
        iniSet  "input_overlay" "$raconfigdir/overlay/Sony-PlayStation.cfg" "$core_config"
        iniSet  "input_overlay_opacity" "1.0" "$core_config"
        iniSet  "input_overlay_scale" "1.0" "$core_config"
        iniSet  "video_fullscreen_x" "1920" "$core_config"
        iniSet  "video_fullscreen_y" "1080" "$core_config"
        iniSet  "input_overlay_enable" "true" "$core_config"
        iniSet  "video_smooth" "true" "$core_config"
        iniSet  "rewind_enable" "false" "$core_config"
        iniSet  "game_specific_options" "true" "$core_config"
        iniSet  "input_player1_analog_dpad_mode" "0" "$core_config"
        iniSet  "input_player2_analog_dpad_mode" "0" "$core_config"
        iniSet  "pcsx_rearmed_neon_enhancement_enable" "enabled" "$core_config"
        iniSet  "pcsx_rearmed_neon_enhancement_no_main" "enabled" "$core_config"
        iniSet  "pcsx_rearmed_pad1type" "analog" "$core_config"
        iniSet  "pcsx_rearmed_pad2type" "analog" "$core_config"
        iniSet "pcsx_rearmed_show_bios_bootlogo" "enabled" "$core_config"

        chown $user:$user "$core_config"

    

}
