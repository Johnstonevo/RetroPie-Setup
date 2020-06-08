#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-bsnes"
rp_module_desc="Super Nintendo emu - bsnes port for libretro"
rp_module_help="ROM Extensions: .bin .smc .sfc .fig .swc .mgd .zip\n\nCopy your SNES roms to $romdir/snes"
rp_module_licence="GPL3 https://raw.githubusercontent.com/libretro/bsnes-libretro/libretro/COPYING"
rp_module_section="opt"
rp_module_flags="!armv6"

function sources_lr-bsnes() {
    gitPullOrClone "$md_build" https://github.com/libretro/bsnes-libretro.git
}

function build_lr-bsnes() {
    make clean
    make
    md_ret_require="$md_build/out/bsnes_accuracy_libretro.so"
}

function install_lr-bsnes() {
    md_ret_files=(
        'out/bsnes_accuracy_libretro.so'
        'COPYING'
    )
}

function configure_lr-bsnes() {
    local system
    local def
    for system in snes snes-usa sfc snesh satellaview sufami snesmsu1 smwhacks; do
        def=0
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 0 "$md_id" "$system" "$md_inst/bsnes_accuracy_libretro.so"
        addSystem "$system"

        cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp
       
        local core_config="$system"

        setRetroArchCoreOption "input_overlay_opacity" "1.0"
        setRetroArchCoreOption "input_overlay_scale" "1.0"
        setRetroArchCoreOption "input_overlay_enable" "true"
        setRetroArchCoreOption "video_smooth" "false"
        setRetroArchCoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/snes_scanline.glslp"
        setRetroArchCoreOption "video_shader_enable"  "true" 
        setRetroArchCoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"

    done


    for system in snes sfc ; do
        addBezel "$system"
    done


    if [ -e $md_instcore/bsnes_balanced_libretro.so ] ;
        then
        local system
        local def
        for system in snes sfc snesh satellaview sufami smwhacks ; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc"  || "$system" == "snesh"  || "$system" == "satellaview" || "$system" == "sufami" || "$system" == "smwhacks" ]] && def=1
                addEmulator 0 "$md_id-balanced-core" "$system" "$md_instcore/bsnes_balanced_libretro.so"
                addSystem "$system"
    done
    fi

    if [ -e $md_instcore/bsnes_cplusplus98_libretro.so ] ;
        then
        local system
        local def
        for system in snes sfc snesh satellaview sufami smwhacks ; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc"  || "$system" == "snesh"  || "$system" == "satellaview" || "$system" == "sufami" || "$system" == "smwhacks" ]] && def=1
                addEmulator 0 "$md_id-cplusplus98-core" "$system" "$md_instcore/bsnes_cplusplus98_libretro.so"
                addSystem "$system"
    done
    fi

    if [ -e $md_instcore/bsnes_accuracy_libretro.so ] ;
        then
        local system
        local def
        for system in snes sfc snesh satellaview sufami smwhacks ; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc"  || "$system" == "snesh"  || "$system" == "satellaview" || "$system" == "sufami" || "$system" == "smwhacks" ]] && def=1
                addEmulator 0 "$md_id-core" "$system" "$md_instcore/bsnes_accuracy_libretro.so"
                addSystem "$system"
    done
    fi

    if [ -e $md_instcore/bsnes_mercury_accuracy_libretro.so ] ;
        then
        local system
        local def
        for system in snes sfc snesh satellaview sufami smwhacks ; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc"  || "$system" == "snesh"  || "$system" == "satellaview" || "$system" == "sufami" || "$system" == "smwhacks" ]] && def=1
                addEmulator 0 "$md_id-mercury_accuracy-core" "$system" "$md_instcore/bsnes_mercury_accuracy_libretro.so"
                addSystem "$system"
    done
    fi

    if [ -e $md_instcore/bsnes_mercury_balanced_libretro.so ] ;
        then
        local system
        local def
        for system in snes sfc snesh satellaview sufami smwhacks ; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc"  || "$system" == "snesh"  || "$system" == "satellaview" || "$system" == "sufami" || "$system" == "smwhacks" ]] && def=1
                addEmulator 0 "$md_id-mercury_balanced-core" "$system" "$md_instcore/bsnes_mercury_balanced_libretro.so"
                addSystem "$system"
    done
    fi

    if [ -e $md_instcore/bsnes_mercury_performance_libretro.so ] ;
        then
        local system
        local def
        for system in snes sfc snesh satellaview sufami smwhacks ; do
            def=0
            [[ "$system" == "snes" || "$system" == "sfc"  || "$system" == "snesh"  || "$system" == "satellaview" || "$system" == "sufami" || "$system" == "smwhacks" ]] && def=1
                addEmulator 0 "$md_id-mercury_performance-core" "$system" "$md_instcore/bsnes_mercury_performance_libretro.so"
                addSystem "$system"
    done
    fi

    if [ -e $md_instcore/bsnes_hd_libretro.so ] ;
        then
        local system
        local def
        for system in snes sfc snesh satellaview sufami smwhacks ; do
            def=1
            [[ "$system" == "snes" || "$system" == "sfc"  || "$system" == "snesh"  || "$system" == "satellaview" || "$system" == "sufami" || "$system" == "smwhacks" ]] && def=1
                addEmulator 0 "$md_id-hd-core" "$system" "$md_instcore/bsnes_hd_libretro.so"
                addSystem "$system"
                ensureSystemretroconfig "$system"

    done
    fi


    local core_config="sfc"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Super-Famicom.cfg"
    local core_config="satellaview"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Super-Famicom.cfg"
    local core_config="snes"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
    local core_config="snesh"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
    local core_config="smwhacks"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
    local core_config="sufami"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Super-Nintendo-Entertainment-System.cfg"
    
    
    if [ ! -L "$raconfigdir/config/bsnes" ] ;
        then
            ln -s $raconfigdir/config/Snes9x $raconfigdir/config/bsnes
        
    fi


    if [ ! -L "$raconfigdir/config/bsnes accuracy" ] ;
        then
            ln -s $raconfigdir/config/Snes9x $raconfigdir/config/bsnes\ accuracy
        
    fi



    if [ ! -L "$raconfigdir/config/bsnes balanced" ] ;
        then
            ln -s $raconfigdir/config/Snes9x $raconfigdir/config/bsnes\ balanced
        
    fi



    if [ ! -L "$raconfigdir/config/bSNES" ] ;
        then
            ln -s $raconfigdir/config/Snes9x $raconfigdir/config/bSNES
        
    fi



    if [ ! -L "$raconfigdir/config/bsnes HD" ] ;
        then
            ln -s $raconfigdir/config/Snes9x $raconfigdir/config/bsnes\ HD
        
    fi



    if [ ! -L "$raconfigdir/config/bsnes-mercury" ] ;
        then
            ln -s $raconfigdir/config/Snes9x $raconfigdir/config/bsnes-mercury
        
    fi






    if [ ! -L "$raconfigdir/config/bsnes performance" ] ;
        then
            ln -s $raconfigdir/config/Snes9x $raconfigdir/config/bsnes\ performance
        
    fi



}


