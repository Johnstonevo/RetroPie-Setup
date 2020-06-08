#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="snes9x"
rp_module_desc="SNES emulator SNES9X-RPi"
rp_module_help="ROM Extensions: .bin .smc .sfc .fig .swc .mgd .zip\n\nCopy your SNES roms to $romdir/snes"
rp_module_licence="NONCOM https://raw.githubusercontent.com/RetroPie/snes9x-rpi/master/snes9x.h"
rp_module_section="opt"
rp_module_flags="dispmanx !all videocore"

function depends_snes9x() {
    getDepends libsdl1.2-dev libboost-thread-dev libboost-system-dev libsdl-ttf2.0-dev libasound2-dev
}

function sources_snes9x() {
    gitPullOrClone "$md_build" https://github.com/RetroPie/snes9x-rpi.git retropie
}

function build_snes9x() {
    make clean
    make
    md_ret_require="$md_build/snes9x"
}

function install_snes9x() {
    md_ret_files=(
        'changes.txt'
        'hardware.txt'
        'problems.txt'
        'readme.txt'
        'README.md'
        'snes9x'
    )
}

function configure_snes9x() {
    mkRomDir "snes"
    mkRomDir "snes-usa"
    mkRomDir "snesh"
    mkRomDir "sfc"
    mkRomDir "satellaview"
    mkRomDir "sufami"
    mkRomDir "smwhacks"
    mkRomDir "snesmsu1"

    setDispmanx "$md_id" 1

    addEmulator 0 "$md_id" "snes" "$md_inst/snes9x %ROM%"
    addEmulator 0 "$md_id" "snes-usa" "$md_inst/snes9x %ROM%"
    addEmulator 0 "$md_id" "snesh" "$md_inst/snes9x %ROM%"
    addEmulator 0 "$md_id" "sfc" "$md_inst/snes9x %ROM%"
    addEmulator 0 "$md_id" "satellaview" "$md_inst/snes9x %ROM%"
    addEmulator 0 "$md_id" "sufami" "$md_inst/snes9x %ROM%"
    addEmulator 0 "$md_id" "smwhacks" "$md_inst/snes9x %ROM%"
    addEmulator 0 "$md_id" "snesmsu1" "$md_inst/snes9x %ROM%"
    addSystem "snes"
    addSystem "snes-usa"
    addSystem "snesh"
    addSystem "sfc"
    addSystem "satellaview"
    addSystem "sufami"
    addSystem "smwhacks"
    addSystem "snesmsu1"
}
