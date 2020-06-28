#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-beetle-supergrafx"
rp_module_desc="SuperGrafx TG-16 emulator - Mednafen PCE Fast port for libretro"
rp_module_help="ROM Extensions: .pce .ccd .cue .zip\n\nCopy your PC Engine / TurboGrafx roms to $romdir/pcengine\n\nCopy the required BIOS file syscard3.pce to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/beetle-supergrafx-libretro/master/COPYING"
rp_module_section="main"

function sources_lr-beetle-supergrafx() {
    gitPullOrClone "$md_build" https://github.com/libretro/beetle-supergrafx-libretro.git
}

function build_lr-beetle-supergrafx() {
    make clean
    make
    md_ret_require="$md_build/mednafen_supergrafx_libretro.so"
}

function install_lr-beetle-supergrafx() {
    md_ret_files=(
        'mednafen_supergrafx_libretro.so'
    )
}

function configure_lr-beetle-supergrafx() {

    local system
    local def
    for system in tg16 tg-cd pcengine pce-cd supergrafx ; do
        def=0
        [[ "$system" == "tg16" || "$system" == "tg-cd"  || "$system" == "pcengine"  || "$system" == "pce-cd" || "$system" == "supergrafx"  ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 0 "$md_id" "$system" "$md_inst/mednafen_supergrafx_libretro.so"
        addSystem "$system"
        addBezel "$system"
        
        cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp

        local core_config="$system"
        setRetroArchCoreOption  "core_options_path" "/home/$user/.config/RetroPie/$system/retroarch.cfg"
        setRetroArchCoreOption  "input_overlay_opacity" "1.0"
        setRetroArchCoreOption  "input_overlay_scale" "1.0"
        setRetroArchCoreOption  "input_overlay_enable" "true"
        setRetroArchCoreOption  "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"

    done 
    
    addEmulator  1   "$md_id" "supergrafx" "$md_inst/mednafen_supergrafx_libretro.so"


    local core_config="tg16"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/NEC-TurboGrafx-16.cfg"

    local core_config="tg-cd"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/NEC-TurboGrafx-CD.cfg"

    local core_config="pcengine"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/NEC-PC-Engine.cfg"

    local core_config="pce-cd"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/NEC-PC-Engine-CD.cfg"
    
    local core_config="supergrafx"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/NEC-SuperGrafx.cfg"
           
    if [ -e $md_instcore/mednafen_supergrafx_libretro.so ] ;
        then
            local system
            local def
            for system in tg16 tg-cd pcengine pce-cd supergrafx ; do
                def=0
                [[ "$system" == "tg16" || "$system" == "tg-cd"  || "$system" == "pcengine"  || "$system" == "pce-cd"  ||"$system" == "supergrafx" ]] && def=1
                addEmulator 0 "$md_id-core" "$system" "$md_instcore/mednafen_supergrafx_libretro.so"
        done

    fi


}
