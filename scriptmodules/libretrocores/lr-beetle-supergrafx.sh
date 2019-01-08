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
    mkRomDir "pcengine"
    ensureSystemretroconfig "pcengine"

    addEmulator 0 "$md_id" "pcengine" "$md_inst/mednafen_supergrafx_libretro.so"
    addSystem "pcengine"
    
    mkRomDir "sgfx"
    ensureSystemretroconfig "sgfx"

    addEmulator 0 "$md_id" "sgfx" "$md_inst/mednafen_supergrafx_libretro.so"
    addSystem "sgfx"
        if [ ! -d $raconfigdir/overlay/GameBezels/SuperGrafx ]
        then
            git clone  https://github.com/thebezelproject/bezelproject-SuperGrafx.git  "/home/$user/RetroPie-Setup/tmp/SuperGrafx"
            cp -r  /home/$user/RetroPie-Setup/tmp/SuperGrafx/retroarch/  /home/$user/.config/
            rm -rf /home/$user/RetroPie-Setup/tmp/SuperGrafx/
            cd /home/$user/.config/retroarch
            chown -R $user:$user ../retroarch
            find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
        fi
        if [ ! -d $raconfigdir/overlay/GameBezels/SuperGrafx ]
            then
             cp /home/$user/.config/RetroPie/sgfx/retroarch.cfg /home/$user/.config/RetroPie/sgfx/retroarch.cfg.bkp
            local core_config="$configdir/sgfx/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/sgfx/retroarch.cfg"
            iniSet  "core_options_path" "/home/$user/.config/RetroPie/sfgx/retroarch.cfg" "$core_config"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/NEC-SuperGrafx.cfg" "$core_config"
            iniSet  "input_overlay_opacity" "1.0" "$core_config"
            iniSet  "input_overlay_scale" "1.0" "$core_config"
            iniSet  "video_fullscreen_x" "1920" "$core_config"
            iniSet  "video_fullscreen_y" "1080" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
        fi

}
