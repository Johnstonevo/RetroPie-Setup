#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-snes9x2010"
rp_module_desc="Super Nintendo emu - Snes9x 1.52 based port for libretro"
rp_module_help="Previously called lr-snes9x-next\n\nROM Extensions: .bin .smc .sfc .fig .swc .mgd .zip\n\nCopy your SNES roms to $romdir/snes"
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/snes9x2010/master/docs/snes9x-license.txt"
rp_module_section="main"

function _update_hook_lr-snes9x2010() {
    # move from old location and update emulators.cfg
    renameModule "lr-snes9x-next" "lr-snes9x2010"
}

function sources_lr-snes9x2010() {
    gitPullOrClone "$md_build" https://github.com/libretro/snes9x2010.git
}

function build_lr-snes9x2010() {
    make -f Makefile.libretro clean
    local platform=""
    isPlatform "arm" && platform+="armv"
    isPlatform "neon" && platform+="neon"
    if [[ -n "$platform" ]]; then
        make -f Makefile.libretro platform="$platform"
    else
        make -f Makefile.libretro
    fi
    md_ret_require="$md_build/snes9x2010_libretro.so"
}

function install_lr-snes9x2010() {
    md_ret_files=(
        'snes9x2010_libretro.so'
        'docs'
    )
}

function configure_lr-snes9x2010() {
     local system
    for system in snes sfc snescd nintendobsx sufami snesh; do
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        isPlatform "armv6" && def=1
        addEmulator $def "$md_id" "$system" "$md_inst/snes9x2002_libretro.so"
        addSystem "$system"
    done
if [ -e /usr/lib/libretro/snes9x2010_libretro.so ]
    then
    local system
    local def
    for system in snes sfc snescd snesh nintendobsx sufami; do
            def=0
            [[ "$system" == "snes" || "$system" == "snesh" || "$system" == "sfc" || "$system" == "snescd"  || "$system" == "nintendobsx" || "$system" == "sufami" ]] && def=1
            addEmulator  "$md_id-ppa" "$system" "$md_instppa/snes9x2010_libretro.so"
 done
fi


if [ ! -d $raconfigdir/overlay/GameBezels/SNES ]
then
    git clone  https://github.com/thebezelproject/bezelproject-SNES.git  "/home/$user/RetroPie-Setup/tmp/SNES"
    cp -r  /home/$user/RetroPie-Setup/tmp/SNES/retroarch/  /home/$user/.config/
   rm -rf /home/$user/RetroPie-Setup/tmp/SNES/
    cd /home/$user/.config/retroarch
    chown -R $user:$user ../retroarch
    find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
fi

if [ ! -d $raconfigdir/overlay/GameBezels/SFC ]
then
    git clone  https://github.com/thebezelproject/bezelproject-SFC.git  "/home/$user/RetroPie-Setup/tmp/SFC"
    cp -r  /home/$user/RetroPie-Setup/tmp/SFC/retroarch/  /home/$user/.config/
    rm -rf /home/$user/RetroPie-Setup/tmp/SFC/
    cd /home/$user/.config/retroarch/
    chown -R $user:$user ../retroarch
    find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
fi
if [  -d $raconfigdir/overlay/GameBezels/SNES ]
 then
             cp /home/$user/.config/RetroPie/snes/retroarch.cfg /home/$user/.config/RetroPie/snes/retroarch.cfg.bkp
            local core_config="$configdir/snes/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/snes/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "custom_viewport_width" "1194" "$core_config"
            iniSet "custom_viewport_height" "896" "$core_config"
            iniSet "custom_viewport_x" "363" "$core_config"
            iniSet "custom_viewport_y" "90" "$core_config"
            iniSet "aspect_ratio_index" "22" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            iniSet "video_smooth" "true" "$core_config"
            chown $user:$user "$core_config"
fi
if [  -d $raconfigdir/overlay/GameBezels/SNES ]
 then
             cp /home/$user/.config/RetroPie/snesh/retroarch.cfg /home/$user/.config/RetroPie/snesh/retroarch.cfg.bkp
            local core_config="$configdir/snesh/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/snesh/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "custom_viewport_width" "1194" "$core_config"
            iniSet "custom_viewport_height" "896" "$core_config"
            iniSet "custom_viewport_x" "363" "$core_config"
            iniSet "custom_viewport_y" "90" "$core_config"
            iniSet "aspect_ratio_index" "22" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            iniSet "video_smooth" "true" "$core_config"
            chown $user:$user "$core_config"
fi
if [  -d $configdir/snescd ]
 then
             cp /home/$user/.config/RetroPie/snescd/retroarch.cfg /home/$user/.config/RetroPie/snescd/retroarch.cfg.bkp
            local core_config="$configdir/snescd/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/snescd/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "custom_viewport_width" "1194" "$core_config"
            iniSet "custom_viewport_height" "896" "$core_config"
            iniSet "custom_viewport_x" "363" "$core_config"
            iniSet "custom_viewport_y" "90" "$core_config"
            iniSet "aspect_ratio_index" "22" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            iniSet "video_smooth" "true" "$core_config"
            chown $user:$user "$core_config"
fi
if [  -d $configdir/sfc ]
 then
             cp /home/$user/.config/RetroPie/sfc/retroarch.cfg /home/$user/.config/RetroPie/sfc/retroarch.cfg.bkp
            local core_config="$configdir/sfc/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/sfc/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "custom_viewport_width" "1194" "$core_config"
            iniSet "custom_viewport_height" "896" "$core_config"
            iniSet "custom_viewport_x" "363" "$core_config"
            iniSet "custom_viewport_y" "90" "$core_config"
            iniSet "aspect_ratio_index" "22" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            iniSet "video_smooth" "true" "$core_config"
            chown $user:$user "$core_config"
fi
if [  -d $configdir/nintendobsx ]
 then
             cp /home/$user/.config/RetroPie/nintendobsx/retroarch.cfg /home/$user/.config/RetroPie/nintendobsx/retroarch.cfg.bkp
            local core_config="$configdir/nintendobsx/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/nintendobsx/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "custom_viewport_width" "1194" "$core_config"
            iniSet "custom_viewport_height" "896" "$core_config"
            iniSet "custom_viewport_x" "363" "$core_config"
            iniSet "custom_viewport_y" "90" "$core_config"
            iniSet "aspect_ratio_index" "22" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            iniSet "video_smooth" "true" "$core_config"
            chown $user:$user "$core_config"
fi
if [  -d $configdir/sufami ]
 then
             cp /home/$user/.config/RetroPie/sufami/retroarch.cfg /home/$user/.config/RetroPie/sufami/retroarch.cfg.bkp
            local core_config="$configdir/sufami/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/sufami/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Super-Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0" "$core_config"
            iniSet "input_overlay_scale" "1.0" "$core_config"
            iniSet "video_fullscreen_x" "1920" "$core_config"
            iniSet "video_fullscreen_y" "1080" "$core_config"
            iniSet "custom_viewport_width" "1194" "$core_config"
            iniSet "custom_viewport_height" "896" "$core_config"
            iniSet "custom_viewport_x" "363" "$core_config"
            iniSet "custom_viewport_y" "90" "$core_config"
            iniSet "aspect_ratio_index" "22" "$core_config"
            iniSet "input_overlay_enable" "true" "$core_config"
            iniSet "video_smooth" "true" "$core_config"
            chown $user:$user "$core_config"
fi
}
