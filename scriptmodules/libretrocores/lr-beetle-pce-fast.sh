#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-beetle-pce-fast"
rp_module_desc="PCEngine emu - Mednafen PCE Fast port for libretro"
rp_module_help="ROM Extensions: .pce .ccd .cue .zip\n\nCopy your PC Engine / TurboGrafx roms to $romdir/pcengine\n\nCopy the required BIOS file syscard3.pce to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/beetle-pce-fast-libretro/master/COPYING"
rp_module_section="main"

function _update_hook_lr-beetle-pce-fast() {
    # move from old location and update emulators.cfg
    renameModule "lr-mednafen-pce-fast" "lr-beetle-pce-fast"
}

function sources_lr-beetle-pce-fast() {
    gitPullOrClone "$md_build" https://github.com/libretro/beetle-pce-fast-libretro.git
}

function build_lr-beetle-pce-fast() {
    make clean
    make
    md_ret_require="$md_build/mednafen_pce_fast_libretro.so"
}

function install_lr-beetle-pce-fast() {
    md_ret_files=(
        'mednafen_pce_fast_libretro.so'
        'README.md'
    )
}

function configure_lr-beetle-pce-fast() {
    mkRomDir "pcengine"
    mkRomDir "pce-cd"
    mkRomDir "pcengine"
    mkRomDir "pce-cd"
    ensureSystemretroconfig "tg16"
    ensureSystemretroconfig "tg-cd"

    addEmulator 1 "$md_id" "pcengine" "$md_inst/mednafen_pce_fast_libretro.so"
    addEmulator 1 "$md_id" "pce-cd" "$md_inst/mednafen_pce_fast_libretro.so"
    addEmulator 1 "$md_id" "tg16" "$md_inst/mednafen_pce_fast_libretro.so"
    addEmulator 1 "$md_id" "tg-cd" "$md_inst/mednafen_pce_fast_libretro.so"
    addSystem "pcengine"
    addSystem "pce-cd"
    addSystem "tg16"
    addSystem "tg-cd"

        if [ -e $md_instppa/mednafen_pce_fast.so ]
        then
        ensureSystemretroconfig "tg16"
        ensureSystemretroconfig "tg-cd"

        addEmulator 0 "$md_id" "pcengine" "$md_inst/mednafen_pce_fast_libretro.so"
        addEmulator 0 "$md_id" "pce-cd" "$md_inst/mednafen_pce_fast_libretro.so"
        addEmulator 0 "$md_id" "tg16" "$md_inst/mednafen_pce_fast_libretro.so"
        addEmulator 0 "$md_id" "tg-cd" "$md_inst/mednafen_pce_fast_libretro.so"
        addSystem "pcengine"
        addSystem "pce-cd"
        addSystem "tg16"
        addSystem "tg-cd"

        fi
        if [ ! -d $raconfigdir/overlay/GameBezels/TG-CD ]
        then
            git clone https://github.com/thebezelproject/bezelproject-TG-CD.git  "/home/$user/RetroPie-Setup/tmp/TG-CD"
            cp -r  /home/$user/RetroPie-Setup/tmp/TG-CD/retroarch/  /home/$user/.config/
            rm -rf /home/$user/RetroPie-Setup/tmp/TG-CD/
            ln -s "$raconfigdir/config/Mednafen PCE Fast" "$raconfigdir/config/Beetle PCE Fast"
            cd /home/$user/.config/retroarch
            chown -R $user:$user ../retroarch
            find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
        fi
        if [ ! -d $raconfigdir/overlay/GameBezels/TG16 ]
        then
            git clone https://github.com/thebezelproject/bezelproject-TG16.git  "/home/$user/RetroPie-Setup/tmp/TG16"
            cp -r  /home/$user/RetroPie-Setup/tmp/TG16/retroarch/  /home/$user/.config/
            rm -rf /home/$user/RetroPie-Setup/tmp/TG16/
            cd /home/$user/.config/retroarch
            ln -s  "$raconfigdir/config/Mednafen PCE Fast" "$raconfigdir/config/Beetle PCE Fast"
            chown -R $user:$user ../retroarch
            find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
        fi
        if [ ! -d $raconfigdir/overlay/GameBezels/TG16 ]
            then
             cp /home/$user/.config/RetroPie/tg16/retroarch.cfg /home/$user/.config/RetroPie/tg16/retroarch.cfg.bkp
            local core_config="$configdir/tg16/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/tg16/retroarch.cfg"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"

            cp /home/$user/.config/RetroPie/pcengine/retroarch.cfg /home/$user/.config/RetroPie/pcengine/retroarch.cfg.bkp
           local core_config="$configdir/pcengine/retroarch.cfg"
           iniConfig " = " '"' "$md_conf_root/pcengine/retroarch.cfg"
           iniSet "input_overlay_opacity" "1.0" "$core_config"
           iniSet "input_overlay_scale" "1.0" "$core_config"
           iniSet "input_overlay_enable" "true" "$core_config"

        fi
        if [ ! -d $raconfigdir/overlay/GameBezels/TG-CD ]
            then
             cp /home/$user/.config/RetroPie/tg-cd/retroarch.cfg /home/$user/.config/RetroPie/tg-cd/retroarch.cfg.bkp
            local core_config="$configdir/tg-cd/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/tg-cd/retroarch.cfg"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            cp /home/$user/.config/RetroPie/pce-cd/retroarch.cfg /home/$user/.config/RetroPie/pce-cd/retroarch.cfg.bkp
            local core_config="$configdir/pce-cd/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/pce-cd/retroarch.cfg"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"

        fi



}
