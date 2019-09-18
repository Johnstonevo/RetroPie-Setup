#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-quicknes"
rp_module_desc="NES emulator - QuickNES Port for libretro"
rp_module_help="ROM Extensions: .nes .zip\n\nCopy your NES roms to $romdir/nes"
rp_module_licence="GPL2"
rp_module_section="main"

function sources_lr-quicknes() {
    gitPullOrClone "$md_build" https://github.com/libretro/QuickNES_Core.git
}

function build_lr-quicknes() {
    make clean
    make
    md_ret_require="$md_build/quicknes_libretro.so"
}

function install_lr-quicknes() {
    md_ret_files=(
        'quicknes_libretro.so'
    )
}

function configure_lr-quicknes() {
    local system
    local def
    for system in nes nesh fds famicom ; do
        def=0
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id" "$system" "$md_inst/quicknes_libretro.so"
        addSystem "$system"
        local core_config="$system"
        setRetroArchCoreOption "input_overlay_opacity" "1.0"
        setRetroArchCoreOption "input_overlay_scale" "1.0"
        setRetroArchCoreOption "input_overlay_enable" "true"
        setRetroArchCoreOption "video_smooth" "false"
    done

    addBezel "nes"
    addBezel "fds"
    addBezel "famicom"

    
if [ -e $md_instcore=/quicknes_libretro.so ]
then
    local system
    local def
    for system in nes nesh fds famicom ; do
        def=0
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id-core" "$system" "$md_instcore/quicknes_libretro.so"
        addSystem "$system"

    done

fi

    for system in nes nesh ; do

        cp /home/$user/.config/RetroPie/nes/retroarch.cfg /home/$user/.config/RetroPie/nes/retroarch.cfg.bkp
        local core_config="$system"
        setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Entertainment-System.cfg"
    done



    cp /home/$user/.config/RetroPie/fds/retroarch.cfg /home/$user/.config/RetroPie/fds/retroarch.cfg.bkp
    local core_config="fds"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Famicom-Disk-System.cfg"


    cp /home/$user/.config/RetroPie/famicom/retroarch.cfg /home/$user/.config/RetroPie/famicom/retroarch.cfg.bkp
    local core_config="famicom"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Famicom.cfg"


}
