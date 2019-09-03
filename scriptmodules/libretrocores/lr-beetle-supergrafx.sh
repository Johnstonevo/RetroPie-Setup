#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-beetle-supergrafx"
rp_module_desc="SuperGrafx TG-16 emulator - Mednafen PCE Fast port for libretro"
rp_module_help="ROM Extensions: .pce .ccd .cue .zip\n\nCopy your PC Engine / TurboGrafx roms to $romdir/pcengine\n\nCopy the required BIOS file syscard3.pce to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/beetle-supergrafx-libretro/master/COPYING"
rp_module_section="main"

function sources_lr-beetle-supergrafx() {
    gitPullOrClone "$md_build" https://github.com/libretro/beetle-supergrafx-libretro.git
}

function build_lr-beetle-supergrafx() {
    make clean
    make
    md_ret_require="$md_build/mednafen_supergrafx_libretro.so"
}

function install_lr-beetle-supergrafx() {
    md_ret_files=(
        'mednafen_supergrafx_libretro.so'
    )
}

function configure_lr-beetle-supergrafx() {
    local core_config="$configdir/supergrafx/retroarch.cfg"

    mkRomDir "pcengine"
    ensureSystemretroconfig "pcengine"

    addEmulator 0 "$md_id" "pcengine" "$md_inst/mednafen_supergrafx_libretro.so"
    addSystem "pcengine"

    mkRomDir "supergrafx"
    ensureSystemretroconfig "supergrafx"

    addEmulator 1 "$md_id" "supergrafx" "$md_inst/mednafen_supergrafx_libretro.so"
    addSystem "supergrafx"

    addBezel "supergrafx"

        if [ ! -d $raconfigdir/overlay/GameBezels/SuperGrafx ]
            then
             cp /home/$user/.config/RetroPie/supergrafx/retroarch.cfg /home/$user/.config/RetroPie/supergrafx/retroarch.cfg.bkp
            setRetroArchCoreOption  "core_options_path" "/home/$user/.config/RetroPie/sfgx/retroarch.cfg"
            setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/NEC-SuperGrafx.cfg"
            setRetroArchCoreOption  "input_overlay_opacity" "1.0"
            setRetroArchCoreOption  "input_overlay_scale" "1.0"
            setRetroArchCoreOption  "video_fullscreen_x" "1920"
            setRetroArchCoreOption  "video_fullscreen_y" "1080"
            setRetroArchCoreOption "input_overlay_enable" "true"
            setRetroArchCoreOption "video_shader_dir" "/home/$user/.config/retroarch/shaders/rpi/retropie"
            
        fi

}
