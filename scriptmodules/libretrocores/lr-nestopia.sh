#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-nestopia"
rp_module_desc="NES emu - Nestopia (enhanced) port for libretro"
rp_module_help="ROM Extensions: .nes .zip\n\nCopy your NES roms to $romdir/nes\n\nFor the Famicom Disk System copy your roms to $romdir/fds\n\nFor the Famicom Disk System copy the required BIOS file disksys.rom to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/nestopia/master/COPYING"
rp_module_section="main"

function sources_lr-nestopia() {
    gitPullOrClone "$md_build" https://github.com/libretro/nestopia.git
}

function build_lr-nestopia() {
    cd libretro
    rpSwap on 512
    make clean
    make
    rpSwap off
    md_ret_require="$md_build/libretro/nestopia_libretro.so"
}

function install_lr-nestopia() {
    md_ret_files=(
        'libretro/nestopia_libretro.so'
        'NstDatabase.xml'
        'COPYING'
    )
}

function configure_lr-nestopia() {
    local system
    local def=0
    for system in nes nesh fds famicom ; do
        def=0
        [[ "$system" == "nes" || "$system" == "nesh"  || "$system" == "fds"  || "$system" == "famicom"  ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id" "$system" "$md_inst/nestopia_libretro.so"
        
        addSystem "$system"

        cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp
        local core_config="$system"
        setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Entertainment-System.cfg"
        setRetroArchCoreOption "input_overlay_opacity" "1.0"
        setRetroArchCoreOption "input_overlay_scale" "1.0"
        setRetroArchCoreOption "input_overlay_enable" "true"
        setRetroArchCoreOption "video_smooth" "false"
        setRetroArchCoreOption "nestopia_palette" "pal"
        setRetroArchCoreOption "nestopia_nospritelimie" "enabled"

    done

    addBezel "fds"
    addBezel "nes"
    addBezel "famicom"


    local core_config="famicom"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Famicom.cfg"

    local core_config="fds"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Famicom-Disk-System"


    cp NstDatabase.xml "$biosdir/"
    chown $user:$user "$biosdir/NstDatabase.xml"



    cp NstDatabase.xml "$biosdir/"
    chown $user:$user "$biosdir/NstDatabase.xml"
    #setRetroArchCoreOption "nestopia_palette" "canonical"


        if [ -e $md_instcore/nestopia_libretro.so ]
        then
            local system
            local def
            for system in nes nesh fds famicom ; do
                def=0
                [[ "$system" == "nes" || "$system" == "nesh"  || "$system" == "fds"  || "$system" == "famicom"  ]] && def=1
                mkRomDir "$system"
                ensureSystemretroconfig "$system"
                addEmulator 0 "$md_id-core" "$system" "$md_instcore/nestopia_libretro.so"
                addSystem "$system"
            done
        fi




}
