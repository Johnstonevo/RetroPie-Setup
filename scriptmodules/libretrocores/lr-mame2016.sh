#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mame2016"
rp_module_desc="MAME emulator - MAME 0.174 port for libretro"
rp_module_help="ROM Extension: .zip\n\nCopy your MAME roms to either $romdir/mame-libretro or\n$romdir/arcade"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame2016-libretro/master/LICENSE.md"
rp_module_section="exp"
rp_module_flags="nobin"

function sources_lr-mame2016() {
    gitPullOrClone "$md_build" https://github.com/libretro/mame2016-libretro.git
}

function build_lr-mame2016() {
    rpSwap on 1200
    local params=($(_get_params_lr-mame) SUBTARGET=arcade)
    make -f Makefile.libretro clean
    make -f Makefile.libretro "${params[@]}"
    rpSwap off
    md_ret_require="$md_build/mamearcade2016_libretro.so"
}

function install_lr-mame2016() {
    md_ret_files=(
        'mamearcade2016_libretro.so'
    )
}

function configure_lr-mame2016() {
    local system
    for system in arcade mame-2016; do
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 0 "$md_id" "$system" "$md_inst/mame2016_libretro.so"
        addSystem "$system"
        local core_config="$system"
        setRetroarchCoreOption "input_overlay"  "$raconfigdir/overlay/MAME-Horizontal.cfg"
        setRetroarchCoreOption "input_overlay_opacity" "1.0"
        setRetroarchCoreOption "input_overlay_enable" "true"
        setRetroarchCoreOption "mame2016-skip_disclaimer" "enabled"
        setRetroarchCoreOption "mame2016-dcs-speedhack" "enabled"
        setRetroarchCoreOption "mame2016-samples" "enabled"
    done
    if [ -e $md_instcore/mame2016_libretro.so ] ;
    then
        addEmulator 0 "$md_id-core" "arcade" "$md_instcore/mame2016_libretro.so"
        addEmulator 0 "$md_id-core" "mame-2016" "$md_instcore/mame2016_libretro.so"
    fi
        addBezel "mame-2016"
        ln -s "$raconfigdir/config/MAME 2010" "$raconfigdir/config/MAME 2016"




}
