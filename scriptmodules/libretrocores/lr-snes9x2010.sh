#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-snes9x2010"
rp_module_desc="Super Nintendo emu - snes9x2010 1.52 based port for libretro"
rp_module_help="Previously called lr-snes9x2010-next\n\nROM Extensions: .bin .smc .sfc .fig .swc .mgd .zip\n\nCopy your SNES roms to $romdir/snes"
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/snes9x2010/master/docs/snes9x2010-license.txt"
rp_module_section="main"

function _update_hook_lr-snes9x2010() {
    # move from old location and update emulators.cfg
    renameModule "lr-snes9x2010-next" "lr-snes9x2010"
}

function sources_lr-snes9x2010() {
    gitPullOrClone "$md_build" https://github.com/libretro/snes9x2010.git
}

function build_lr-snes9x2010() {
    make -f Makefile.libretro clean
    local platform=""
    isPlatform "arm" && platform+="armv"
    isPlatform "neon" && platform+="neon"
    if [[ -n "$platform" ]]; then
        make -f Makefile.libretro platform="$platform"
    else
        make -f Makefile.libretro
    fi
    md_ret_require="$md_build/snes9x2010_libretro.so"
}

function install_lr-snes9x2010() {
    md_ret_files=(
        'snes9x2010_libretro.so'
        'docs'
    )
}

function configure_lr-snes9x2010() {
    local system
    local def
    for system in snes smwhacks snesh sfc satellaview sufami ; do
        def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id" "$system" "$md_inst/snes9x2010_libretro.so"
        addSystem "$system"
        local core_config="$system"
        setRetroArchCoreOption "input_overlay_opacity" "1.0"
        setRetroArchCoreOption "input_overlay_scale" "1.0"
        setRetroArchCoreOption "input_overlay_enable" "true"
        setRetroArchCoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp"
        setRetroArchCoreOption "video_shader_enable"  "true" 
        setRetroArchCoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"

    done

    
    addBezel "snes"
    addBezel "sfc"

    if [ -e $md_instcore/snes9x2010_libretro.so ]
        then
            local system
            local def
            for system in snes smwhacks snesh sfc satellaview sufami ; do
                def=0
                addEmulator def "$md_id-core" "$system" "$md_instcore/snes9x2010_libretro.so"
            done
    fi


    for system in snes smwhacks snesh ; do

            cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp
            local core_config="$system"
            setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
    done
           
           
    for system in  sfc satellaview sufami ; do

            cp /home/$user/.config/RetroPie/sfc/retroarch.cfg /home/$user/.config/RetroPie/sfc/retroarch.cfg.bkp
        local core_config="$system"
        setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
    done


}
