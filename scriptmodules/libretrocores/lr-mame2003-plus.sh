#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mame2003-plus"
rp_module_desc="Arcade emu - updated MAME 0.78 port for libretro with added game support"
rp_module_help="ROM Extension: .zip\n\nCopy your MAME roms to either $romdir/mame-libretro or\n$romdir/arcade"
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/mame2003-plus-libretro/master/LICENSE.md"
rp_module_section="exp"

function _get_dir_name_lr-mame2003-plus() {
    echo "mame2003-plus"
}

function _get_so_name_lr-mame2003-plus() {
    echo "mame2003_plus"
}

function sources_lr-mame2003-plus() {
    gitPullOrClone "$md_build" https://github.com/libretro/mame2003-plus-libretro.git
}

function build_lr-mame2003-plus() {
    build_lr-mame2003
}

function install_lr-mame2003-plus() {
    install_lr-mame2003
}

function configure_lr-mame2003-plus() {
    configure_lr-mame2003
    iniSet  "mame2003-plus_cheat_input ports" "disabled"
    iniSet  "mame2003-plus_core_save_subfolder" "enabled"
    iniSet  "mame2003-plus_core_sys_subfolder" "enabled"
    iniSet  "mame2003-plus_dcs_speedhack" "enabled"
    iniSet  "mame2003-plus_display_artwork" "enabled"
    iniSet  "mame2003-plus_display_setup" "disabled"
    iniSet  "mame2003-plus_dual_joysticks" "disabled"
    iniSet  "mame2003-plus_frameskip" "0"
    iniSet  "mame2003-plus_gamma" "1.2"
    iniSet  "mame2003-plus_input_interface" "retroarch"
    iniSet  "mame2003-plus_machine_timing" "enabled"
    iniSet  "mame2003-plus_mame_remapping" "disabled"
    iniSet  "mame2003-plus_mouse_device" "mouse"
    iniSet  "mame2003-plus_rstick_to_btns" "enabled"
    iniSet  "mame2003-plus_sample_rate" "48000"
    iniSet  "mame2003-plus_skip_disclaimer" "enabled"
    iniSet  "mame2003-plus_skip_warnings" "enabled"
    iniSet  "mame2003-plus_tate_mode" "disabled"
}
