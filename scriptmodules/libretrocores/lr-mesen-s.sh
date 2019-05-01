#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mesen-s"
rp_module_desc="NES emu - Mesen port for libretro"
rp_module_help="ROM Extensions: .nes .fds .nsf .nsf  .unf\n\nCopy your NES roms t1es\n\nFor the Famicom Disk System copy your roms to $romdir/fds\n\nFor the Famicom Disk System copy the required BIOS file disksys.rom to $biosdir"
rp_module_licence="GPL3 https://raw.githubusercontent.com/SourMesen/Mesen-S/master/LICENSE"
rp_module_section="exp"
rp_module_flags="!arm x86 "

function depends_lr-mesen-s() {

    # Additional libraries required for running
    local depends=(libsdl2-dev mono-devel )
    getDepends "${depends[@]}"
}

function sources_lr-mesen-s() {
    gitPullOrClone "$md_build" https://github.com/SourMesen/Mesen-S.git
}

function build_lr-mesen-s() {
    cd Mesen-S
    make libretro
    md_ret_require="$md_build/mesens_libretro.x64.so"
}

function install_lr-mesen-s() {
    md_ret_files=(
        'mesens_libretro.x64.so'
    )
}

function configure_lr-mesen-s() {
    mkRomDir "snes"
    mkRomDir "snesh"
    mkRomDir "sfc"
    mkRomDir "satellaview"
    mkRomDir "sufami"
    ensureSystemretroconfig "snes"
    ensureSystemretroconfig "snesh"
    ensureSystemretroconfig "sfc"
    ensureSystemretroconfig "satellaview"
    ensureSystemretroconfig "sufami"

    addEmulator 0 "$md_id" "snes" "$md_inst/mesens_libretro.x64.so"
    addEmulator 0 "$md_id" "snesh" "$md_inst/mesens_libretro.x64.so"
    addEmulator 0 "$md_id" "sfc" "$md_inst/mesens_libretro.x64.so"
    addEmulator 0 "$md_id" "satellaview" "$md_inst/mesens_libretro.x64.so"
    addEmulator 0 "$md_id" "sufami" "$md_inst/mesens_libretro.x64.so"
    addSystem "snes"
    addSystem "snesh"
    addSystem "sfc"
    addSystem "satellaview"
    addSystem "sufami"

    addBezel "snes"
    addBezel "sfc"
    ln -s   $raconfigdir/config/Snes9x $raconfigdir/config/Mesen-S






    
}
