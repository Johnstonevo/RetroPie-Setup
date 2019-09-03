#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-beetle-pce-fast"
rp_module_desc="PCEngine emu - Mednafen PCE Fast port for libretro"
rp_module_help="ROM Extensions: .pce .ccd .cue .zip\n\nCopy your PC Engine / TurboGrafx roms to $romdir/pcengine\n\nCopy the required BIOS file syscard3.pce to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/beetle-pce-fast-libretro/master/COPYING"
rp_module_section="main"

function _update_hook_lr-beetle-pce-fast() {
    # move from old location and update emulators.cfg
    renameModule "lr-mednafen-pce-fast" "lr-beetle-pce-fast"
}

function sources_lr-beetle-pce-fast() {
    gitPullOrClone "$md_build" https://github.com/libretro/beetle-pce-fast-libretro.git
}

function build_lr-beetle-pce-fast() {
    make clean
    make
    md_ret_require="$md_build/mednafen_pce_fast_libretro.so"
}

function install_lr-beetle-pce-fast() {
    md_ret_files=(
        'mednafen_pce_fast_libretro.so'
        'README.md'
    )
}

function configure_lr-beetle-pce-fast() {
    local system
    local def
    for system in tg16 tg-cd pcengine pce-cd ; do
        def=0
        [[ "$system" == "tg16" || "$system" == "tg-cd"  || "$system" == "pcengine"  || "$system" == "pce-cd"  ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 0 "$md_id" "$system" "$md_inst/mednafen_pce_fast_libretro.so"
        addSystem "$system"
        addBezel "$system"

        local core_config="$system"
        setRetroArchCoreOption "input_overlay_opacity" "1.0"
        setRetroArchCoreOption "input_overlay_scale" "1.0"
        setRetroArchCoreOption "input_overlay_enable" "true"
        setRetroArchCoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"

 done

    local core_config="tg16"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/NEC-TurboGrafx-16.cfg"

    local core_config="tg-cd"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/NEC-TurboGrafx-CD.cfg"

    local core_config="pcengine"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/NEC-PC-Engine.cfg"

    local core_config="pce-cd"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/NEC-PC-Engine-CD.cfg"


    if [ -e $md_instppa/mednafen_pce_fast_libretro.so ]
        then
            local system
            local def
            for system in tg16 tg-cd pcengine pce-cd ; do
                def=0
                [[ "$system" == "tg16" || "$system" == "tg-cd"  || "$system" == "pcengine"  || "$system" == "pce-cd"  ]] && def=1
                mkRomDir "$system"
                addEmulator 0 "$md_id-ppa" "$system" "$md_instppa/mednafen_pce_fast_libretro.so"

        done

    fi




        


}
