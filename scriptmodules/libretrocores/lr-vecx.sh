#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-vecx"
rp_module_desc="Vectrex emulator - vecx port for libretro"
rp_module_help="ROM Extensions: .vec .gam .bin .zip\n\nCopy your Vectrex roms to $romdir/vectrex"
rp_module_licence="GPL3 https://raw.githubusercontent.com/libretro/libretro-vecx/master/LICENSE.md"
rp_module_section="main"

function sources_lr-vecx() {
    gitPullOrClone "$md_build" https://github.com/libretro/libretro-vecx.git
}

function build_lr-vecx() {
    make clean
    make -f Makefile.libretro
    md_ret_require="$md_build/vecx_libretro.so"
}

function install_lr-vecx() {
    md_ret_files=(
        'vecx_libretro.so'
        'bios/fast.bin'
        'bios/skip.bin'
        'bios/system.bin'
    )
}

function configure_lr-vecx() {
    mkRomDir "vectrex"
    ensureSystemretroconfig "vectrex"

    if [[ "$md_mode" == "install" ]]; then
        # Copy bios files
        cp -v "$md_inst/"{fast.bin,skip.bin,system.bin} "$biosdir/"
        chown $user:$user "$biosdir/"{fast.bin,skip.bin,system.bin}
    else
        rm -f "$biosdir/"{fast.bin,skip.bin,system.bin}
    fi

    addEmulator 0 "$md_id" "vectrex" "$md_inst/vecx_libretro.so"
    addSystem "vectrex"
    addBezel "vectrex"
    if [ -e $md_instcore/vecx_libretro.so ] ;
        then
          addEmulator 0 "$md_id-core" "vectrex" "$md_instcore/vecx_libretro.so"
          addSystem "vectrex"
    fi


          cp /home/$user/.config/RetroPie/vectrex/retroarch.cfg /home/$user/.config/RetroPie/vectrex/retroarch.cfg.bkp
          local core_config="vectrex"
          setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/GCE-Vectrex.cfg"
          setRetroArchCoreOption "input_overlay_opacity" "1.0"
          setRetroArchCoreOption "input_overlay_scale" "1.0"
          setRetroArchCoreOption "input_overlay_enable" "true"
          setRetroArchCoreOption "video_smooth" "true"

}
