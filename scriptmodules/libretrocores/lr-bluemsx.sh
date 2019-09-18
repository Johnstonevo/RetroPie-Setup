#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-bluemsx"
rp_module_desc="MSX/MSX2/Colecovision emu - blueMSX port for libretro"
rp_module_help="ROM Extensions: .rom .mx1 .mx2 .col .dsk .zip\n\nCopy your MSX/MSX2 games to $romdir/msx\nCopy your Colecovision games to $romdir/coleco\n\nlr-bluemsx requires the BIOS files from the full standalone package of BlueMSX to be copied to '$biosdir/Machines' folder.\nColecovision BIOS needs to be copied to '$biosdir/Machines/COL - ColecoVision\coleco.rom'"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/blueMSX-libretro/master/license.txt"
rp_module_section="opt"

function sources_lr-bluemsx() {
    gitPullOrClone "$md_build" https://github.com/libretro/blueMSX-libretro.git
}

function build_lr-bluemsx() {
    make -f Makefile.libretro clean
    make -f Makefile.libretro
    md_ret_require="$md_build/bluemsx_libretro.so"
}

function install_lr-bluemsx() {
    md_ret_files=(
        'bluemsx_libretro.so'
        'README.md'
        'system/bluemsx/Databases'
        'system/bluemsx/Machines'
    )
}

function configure_lr-bluemsx() {

    local system
    local def
    for system in msx msx2 msx2+ coleco ; do
        def=0
        [[ "$system" == "msx" || "$system" == "msx2"  || "$system" == "msx2+"  || "$system" == "coleco"  ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 0 "$md_id" "$system" "$md_inst/bluemsx_libretro.so"
        addSystem "$system"
        local core_config="$system"
        setRetroArchCoreOption "input_overlay_opacity" "1.0"
        setRetroArchCoreOption "input_overlay_scale" "1.0"
        setRetroArchCoreOption "input_overlay_enable" "true"
        setRetroArchCoreOption "video_smooth" "true"
        setRetroArchCoreOption "input_libretro_device_p2" "3"

    done    


    addBezel "coleco"

# force colecovision system
    local core_config="coleco"
    setRetroArchCoreOption "bluemsx_msxtype" "ColecoVision"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Colecovision.cfg"
     setRetroArchCoreOption "bluemsx_msxtype" "ColecoVision"

# force msx system
    local core_config="msx"
    setRetroArchCoreOption "bluemsx_msxtype" "MSX"
    setRetroArchCoreOption "msx_video_mode" "PAL"
    setRetroArchCoreOption "bluemsx_nospritelimits" "ON"

# force msx2 system
    local core_config="msx2"
    setRetroArchCoreOption "bluemsx_msxtype" "MSX2+"
    setRetroArchCoreOption "msx_video_mode" "PAL"
    setRetroArchCoreOption "bluemsx_nospritelimits" "ON"

    cp -rv "$md_inst/"{Databases,Machines} "$biosdir/"
    chown -R $user:$user "$biosdir/"{Databases,Machines}



    
     if [ -e $md_instcore=/bluemsx_libretro.so ]
                then

                for system in msx msx2 msx2+ coleco ; do
                    def=0
                    [[ "$system" == "msx" || "$system" == "msx2"  || "$system" == "msx2+"  || "$system" == "coleco"  ]] && def=1
                    mkRomDir "$system"
                    ensureSystemretroconfig "$system"
                    addEmulator 0 "$md_id" "$system" "$md_instcore/bluemsx_libretro.so"
                    addSystem "$system"
                    local core_config="$system"


                done    

    fi




}
