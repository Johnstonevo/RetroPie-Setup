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
    mkRomDir "nes"
    mkRomDir "nesh"
    mkRomDir "fds"
    mkRomDir "famicom"
    ensureSystemretroconfig "nes"
    ensureSystemretroconfig "nesh"
    ensureSystemretroconfig "fds"
    ensureSystemretroconfig "famicom"

    local def=0
    isPlatform "armv6" && def=0

    addEmulator 1 "$md_id" "nes" "$md_inst/fceumm_libretro.so"
    addEmulator 1 "$md_id" "nesh" "$md_inst/fceumm_libretro.so"
    addEmulator 0 "$md_id" "fds" "$md_inst/fceumm_libretro.so"
    addEmulator 1 "$md_id" "famicom" "$md_inst/fceumm_libretro.so"
    addSystem "nes"
    addSystem "nesh"
    addSystem "fds"
    addSystem "famicom"

    addBezel "fds"
    addBezel "nes"
    addBezel "famicom"

if [ -e $md_instppa/fceumm_libretro.so ]
    then
      addEmulator 0 "$md_id-ppa" "nes" "$md_inst/fceumm_libretro.so"
      addEmulator 0 "$md_id-ppa" "nesh" "$md_inst/fceumm_libretro.so"
    addEmulator 0 "$md_id-ppa" "fds" "$md_inst/fceumm_libretro.so"
    addEmulator 0 "$md_id-ppa" "famicom" "$md_inst/fceumm_libretro.so"
    addSystem "nes"
    addSystem "fds"
    addSystem "famicom"
fi


             cp /home/$user/.config/RetroPie/nes/retroarch.cfg /home/$user/.config/RetroPie/nes/retroarch.cfg.bkp
            local core_config="nes"
            setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Entertainment-System.cfg"
            setRetroArchCoreOption "input_overlay_opacity" "1.0"
            setRetroArchCoreOption "input_overlay_scale" "1.0"
            setRetroArchCoreOption "input_overlay_enable" "true"
            setRetroArchCoreOption "video_smooth" "false"
            setRetroArchCoreOption "fceumm_region" "PAL"

             cp /home/$user/.config/RetroPie/nesh/retroarch.cfg /home/$user/.config/RetroPie/nesh/retroarch.cfg.bkp
            local core_config="nesh"
            setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Entertainment-System.cfg"
            setRetroArchCoreOption "input_overlay_opacity" "1.0"
            setRetroArchCoreOption "input_overlay_scale" "1.0"
            setRetroArchCoreOption "input_overlay_enable" "true"
            setRetroArchCoreOption "video_smooth" "false"

             cp /home/$user/.config/RetroPie/fds/retroarch.cfg /home/$user/.config/RetroPie/fds/retroarch.cfg.bkp
            local core_config="fds"
            iniConfig " = " '"' "$md_conf_root/fds/retroarch.cfg"
            setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Entertainment-System.cfg"
            setRetroArchCoreOption "input_overlay_opacity" "1.0"
            setRetroArchCoreOption "input_overlay_scale" "1.0"
            setRetroArchCoreOption "input_overlay_enable" "true"
            setRetroArchCoreOption "video_smooth" "false"

             cp /home/$user/.config/RetroPie/famicom/retroarch.cfg /home/$user/.config/RetroPie/famicom/retroarch.cfg.bkp
            local core_config="famicom"
            setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Entertainment-System.cfg"
            setRetroArchCoreOption "input_overlay_opacity" "1.0"
            setRetroArchCoreOption "input_overlay_scale" "1.0"
            setRetroArchCoreOption "input_overlay_enable" "true"
            setRetroArchCoreOption "video_smooth" "false"
}
