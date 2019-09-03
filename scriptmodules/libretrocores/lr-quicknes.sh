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

    addEmulator 0 "$md_id" "nes" "$md_inst/quicknes_libretro.so"
    addEmulator 0 "$md_id" "nesh" "$md_inst/quicknes_libretro.so"
    addEmulator 0 "$md_id" "fds" "$md_inst/quicknes_libretro.so"
    addEmulator 0 "$md_id" "famicom" "$md_inst/quicknes_libretro.so"
    addSystem "nes"
    addSystem "nesh"
    addSystem "fds"
    addSystem "famicom"

    addBezel "nes"
    addBezel "fds"
    addBezel "famicom"
if [ -e $md_instppa/quicknes_libretro.so ]
then
  addEmulator 0 "$md_id-ppa" "nes" "$md_inst/quicknes_libretro.so"
  addEmulator 0 "$md_id-ppa" "nesh" "$md_inst/quicknes_libretro.so"
    addEmulator 0 "$md_id-ppa" "fds" "$md_inst/quicknes_libretro.so"
    addEmulator 0 "$md_id-ppa" "famicom" "$md_inst/quicknes_libretro.so"
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


    cp /home/$user/.config/RetroPie/nesh/retroarch.cfg /home/$user/.config/RetroPie/nesh/retroarch.cfg.bkp
    local core_config="nesh"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Entertainment-System.cfg"
    setRetroArchCoreOption "input_overlay_opacity" "1.0"
    setRetroArchCoreOption "input_overlay_scale" "1.0"
    setRetroArchCoreOption "input_overlay_enable" "true"
    setRetroArchCoreOption "video_smooth" "false"


    cp /home/$user/.config/RetroPie/fds/retroarch.cfg /home/$user/.config/RetroPie/fds/retroarch.cfg.bkp
    local core_config="fds"
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
