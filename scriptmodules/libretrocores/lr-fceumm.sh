#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-fceumm"
rp_module_desc="NES emu - FCEUmm port for libretro"
rp_module_help="ROM Extensions: .nes .zip\n\nCopy your NES roms to $romdir/nes\n\nFor the Famicom Disk System copy your roms to $romdir/fds\n\nFor the Famicom Disk System copy the required BIOS file disksys.rom to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/libretro-fceumm/master/Copying"
rp_module_section="main"

function sources_lr-fceumm() {
    gitPullOrClone "$md_build" https://github.com/libretro/libretro-fceumm.git
}

function build_lr-fceumm() {
    make -f Makefile.libretro clean
    make -f Makefile.libretro
    md_ret_require="$md_build/fceumm_libretro.so"
}

function install_lr-fceumm() {
    md_ret_files=(
        'Authors'
        'changelog.txt'
        'Copying'
        'fceumm_libretro.so'
        'whatsnew.txt'
        'zzz_todo.txt'
    )
}

function configure_lr-fceumm() {

    for system in nes nesh fds famicom ; do
        def=0
        [[ "$system" == "nes" || "$system" == "nesh"  || "$system" == "famicom"  ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id" "$system" "$md_inst/fceumm_libretro.so"
        addSystem "$system"
        addBezel "$system"

        cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp
        local core_config="$system"
        setRetroArchCoreOption "input_overlay_opacity" "1.0"
        setRetroArchCoreOption "input_overlay_scale" "1.0"
        setRetroArchCoreOption "input_overlay_enable" "true"
        setRetroArchCoreOption "video_smooth" "false"
        setRetroArchCoreOption "fceumm_region" "PAL"

    done

    local core_config="nes"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Entertainment-System.cfg"

    local core_config="nesh"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Entertainment-System.cfg"

    local core_config="famicom"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Famicom.cfg"

    local core_config="fds"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Famicom-Disk-System.cfg"


if [ -e $md_instcore=/fceumm_libretro.so ]
    then
        for system in nes nesh fds famicom ; do
        def=0
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id-core" "$system" "$md_inst-core/fceumm_libretro.so"
    done
fi

}
