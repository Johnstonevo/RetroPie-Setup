#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-atari800"
rp_module_desc="Atari 8-bit/800/5200 emulator - Atari800 port for libretro"
rp_module_help="ROM Extensions: .a52 .bas .bin .car .xex .atr .xfd .dcm .atr.gz .xfd.gz\n\nCopy your Atari800 games to $romdir/atari800\n\nCopy your Atari 5200 roms to $romdir/atari5200 You need to copy the Atari 800/5200 BIOS files (5200.ROM, ATARIBAS.ROM, ATARIOSB.ROM and ATARIXL.ROM) to the folder $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/libretro-atari800/master/atari800/COPYING"
rp_module_section="main"

function sources_lr-atari800() {
    gitPullOrClone "$md_build" https://github.com/libretro/libretro-atari800.git
}

function build_lr-atari800() {
    make clean
    CFLAGS+=" -DDEFAULT_CFG_NAME=\\\"$md_conf_root/atari800/lr-atari800.cfg\\\"" make
    md_ret_require="$md_build/atari800_libretro.so"
}

function install_lr-atari800() {
    md_ret_files=(
        'atari800_libretro.so'
        'atari800/COPYING'
    )
}

function configure_lr-atari800() {
    local system
    local def
    for system in atari800 atari5200; do
        def=0
        [[ "$system" == "atari800" || "$system" == "atari5200" ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id" "$system" "$md_inst/atari800_libretro.so"
        addSystem "$system"
        local core_config="$system"
        setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Atari-5200.cfg"
        setRetroArchCoreOption "input_overlay_opacity" "1.0"
        setRetroArchCoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"

    done

    mkUserDir "$md_conf_root/atari800"

    addBezel "atari5200"

    local core_config="atari800"
    setRetroArchCoreOption "atari800_system" "800"
    setRetroArchCoreOption "atari800_ntscpal" "PAL"
    
    local core_config="atari5200"
    local a5200_core_config="$configdir/atari5200/retroarch.cfg"
    setRetroArchCoreOption  "atari800_system" "5200"
    setRetroArchCoreOption  "atari800_artifacting"  "enabled"
    setRetroArchCoreOption  "atari800_cassboot"  "disabled"
    setRetroArchCoreOption  "atari800_internalbasic"  "disabled"
    setRetroArchCoreOption  "atari800_keyboard"  "poll"
    setRetroArchCoreOption  "atari800_ntscpal"  "NTSC"
    setRetroArchCoreOption  "atari800_opt1"  "disabled"
    setRetroArchCoreOption  "atari800_opt2"  "disabled"
    setRetroArchCoreOption  "atari800_resolution"  "336x240"
    setRetroArchCoreOption  "atari800_sioaccel"  "enabled"



     if [ -e $md_instcore/atari800_libretro.so ] ;
        then
            addEmulator 0 "lr-atari800-core" "atari800" "$md_instcore/atari800_libretro.so"
            addEmulator 0 "lr-atari800-core" "atari5200" "$md_instcore/atari800_libretro.so"
    fi




}
