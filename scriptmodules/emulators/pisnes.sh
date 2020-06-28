#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="pisnes"
rp_module_desc="SNES emulator PiSNES"
rp_module_help="ROM Extensions: .bin .smc .sfc .fig .swc .mgd .zip\n\nCopy your SNES roms to $romdir/snes"
rp_module_licence="NONCOM https://raw.githubusercontent.com/RetroPie/pisnes/master/snes9x.h"
rp_module_section="opt"
rp_module_flags="!all videocore"

function depends_pisnes() {
    getDepends libasound2-dev libsdl1.2-dev libraspberrypi-dev libjpeg-dev
}

function sources_pisnes() {
    gitPullOrClone "$md_build" https://github.com/RetroPie/pisnes.git
}

function build_pisnes() {
    make clean
    make
    md_ret_require="$md_build/snes9x"
}

function install_pisnes() {
    md_ret_files=(
        'changes.txt'
        'hardware.txt'
        'problems.txt'
        'readme_snes9x.txt'
        'readme.txt'
        'roms'
        'skins'
        'snes9x'
        'snes9x.cfg.template'
        'snes9x.gui'
    )
}

function configure_pisnes() {
    mkRomDir "snes"
    mkRomDir "smwhacks"
    mkRomDir "snesh"
    mkRomDir "sfc"
    mkRomDir "satellaview"
    mkRomDir "sufami"
    mkRomDir "snes-usa"
    moveConfigFile "$md_inst/snes9x.cfg" "$md_conf_root/snes/snes9x.cfg"

    copyDefaultConfig "$md_inst/snes9x.cfg.template" "$md_conf_root/snes/snes9x.cfg"

    addEmulator 0 "$md_id" "snes" "$md_inst/snes9x %ROM%"
    addEmulator 0 "$md_id" "snes-usa" "$md_inst/snes9x %ROM%"
    addEmulator 0 "$md_id" "snesh" "$md_inst/snes9x %ROM%"
    addEmulator 0 "$md_id" "sfc" "$md_inst/snes9x %ROM%"
    addEmulator 0 "$md_id" "satellaview" "$md_inst/snes9x %ROM%"
    addEmulator 0 "$md_id" "sufami" "$md_inst/snes9x %ROM%"
    addEmulator 0 "$md_id" "sufami" "$md_inst/snes9x %ROM%"
    addEmulator 0 "$md_id" "smwhacks" "$md_inst/snes9x %ROM%"
    addSystem "snes"
    addSystem "snes-usa"
    addSystem "snesh"
    addSystem "sfc"
    addSystem "satellaview"
    addSystem "sufami"
    addSystem "smwhacks"

    [[ "$md_mode" == "remove" ]] && return

    moveConfigFile "$md_inst/snes9x.cfg" "$md_conf_root/snes/snes9x.cfg"
    copyDefaultConfig "$md_inst/snes9x.cfg.template" "$md_conf_root/snes/snes9x.cfg"
}
