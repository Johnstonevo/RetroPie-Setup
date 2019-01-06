#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-pcsx-rearmed"
rp_module_desc="Playstation emulator - PCSX (arm optimised) port for libretro"
rp_module_help="ROM Extensions: .bin .cue .cbn .img .iso .m3u .mdf .pbp .toc .z .znx\n\nCopy your PSX roms to $romdir/psx\n\nCopy the required BIOS file SCPH1001.BIN to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/pcsx_rearmed/master/COPYING"
rp_module_section="main"

function depends_lr-pcsx-rearmed() {
    local depends=(libpng-dev)
    isPlatform "x11" && depends+=(libx11-dev)
    getDepends "${depends[@]}"
}

function sources_lr-pcsx-rearmed() {
    gitPullOrClone "$md_build" https://github.com/libretro/pcsx_rearmed.git
}

function build_lr-pcsx-rearmed() {
    if isPlatform "neon"; then
        ./configure --platform=libretro --enable-neon
    else
        ./configure --platform=libretro --disable-neon
    fi
    make clean
    make
    md_ret_require="$md_build/libretro.so"
}

function install_lr-pcsx-rearmed() {
    md_ret_files=(
        'AUTHORS'
        'ChangeLog.df'
        'COPYING'
        'libretro.so'
        'NEWS'
        'README.md'
        'readme.txt'
    )
}

function configure_lr-pcsx-rearmed() {
    local system
    local def
    for system in psx psx-japan; do
        def=1
        [[ "$system" == "psx" || "$system" == "psx-japan" ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator "$def" "$md_id" "$system" "$md_inst/libretro.so"
        addSystem "$system"
        setRetroArchCoreOption "pcsx_rearmed_neon_enhancement_enable" "enabled" # Double resolution
        setRetroArchCoreOption "pcsx_rearmed_neon_enhancement_no_main" "enabled" # Speed hack
        setRetroArchCoreOption "pcsx_rearmed_pad1type"  "analog"
        setRetroArchCoreOption "pcsx_rearmed_pad2type"  "analog"

    if [ -e /usr/lib/libretro/pcsx1_libretro.so ]
                    then 
                                addEmulator 0 "$md_id-ppa" "psx" "$md_instppa/pcsx1_libretro.so"
                                addSystem "psx" "$md_instppa/pcsx1_libretro.so"
                                addEmulator 0 "$md_id-ppa" "psx-japan" "$md_instppa/pcsx1_libretro.so"
                                addSystem "psx-japan" "$md_instppa/pcsx1_libretro.so"


    fi

    if [ ! -d $raconfigdir/overlay/GameBezels/PSX ]
        then 
            git clone  https://github.com/thebezelproject/bezelproject-PSX.git  "/home/$user/RetroPie-Setup/tmp/PSX"
            cp -r  /home/$user/RetroPie-Setup/tmp/PSX/retroarch/  /home/$user/.config/
            rm -rf /home/$user/RetroPie-Setup/tmp/PSX/
            cd /home/$user/.config/retroarch/
            chown -R $user:$user ../retroarch
            ln -s $raconfigdir/config/PCSX-ReARMed  $raconfigdir/config/Beetle\ PSX

            find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
    fi
    if [ -d $raconfigdir/overlay/GameBezels/PSX ]
    then
        local core_config="$configdir/psx/retroarch.cfg"
        iniConfig " = " '"' "$md_conf_root/psx/retroarch.cfg"
        iniSet  "core_options_path" "/home/$user/.config/RetroPie/psx/retroarch.cfg" "$core_config"
        iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Sony-PlayStation.cfg" "$core_config"
        iniSet  "input_overlay_opacity" "1.0" "$core_config"
        iniSet  "input_overlay_scale" "1.0" "$core_config"
        iniSet  "video_fullscreen_x" "1920" "$core_config"
        iniSet  "video_fullscreen_y" "1080" "$core_config"
        iniSet  "custom_viewport_width" "1280" "$core_config"
        iniSet  "custom_viewport_height" "960" "$core_config"
        iniSet  "custom_viewport_x" "320" "$core_config"
        iniSet  "custom_viewport_y" "60" "$core_config"
        iniSet  "aspect_ratio_index" "22" "$core_config"
        iniSet  "input_overlay_enable" "true" "$core_config"
        iniSet  "video_smooth" "true" "$core_config"
        iniSet  "rewind_enable" "false" "$core_config"
        iniSet  "game_specific_options" "true" "$core_config"
        iniSet  "input_player1_analog_dpad_mode" "0" "$core_config"
        iniSet  "input_player2_analog_dpad_mode" "0" "$core_config"
        #iniSet  "beetle_psx_hw_pgxp_texture" "On" "$core_config"
        iniSet  "pcsx_rearmed_neon_enhancement_enable" "enabled" "$core_config"
        iniSet  "pcsx_rearmed_neon_enhancement_no_main" "enabled" "$core_config"
        iniSet  "pcsx_rearmed_pad1type" "analog" "$core_config"
        iniSet  "pcsx_rearmed_pad2type" "analog" "$core_config"
    # iniSet  "pcsx_rearmed_show_bios_bootlogo" "enabled" "$core_config"
        iniSet  "beetle_psx_widescreen_hack" "on" "$core_config"
        iniSet  "beetle_psx_internal_resolution" "4x" "$core_config"
        iniSet  "beetle_psx_skipbios" "off"  "$core_config"
        chown $user:$user "$core_config"
    fi
    if [ -d $raconfigdir/overlay/GameBezels/PSX ]
    then
        local core_config="$configdir/psx-japan/retroarch.cfg"
        iniConfig " = " '"' "$md_conf_root/psx-japan/retroarch.cfg"
        iniSet  "core_options_path" "/home/$user/.config/RetroPie/psx-japan/retroarch.cfg" "$core_config"
        iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Sony-PlayStation.cfg" "$core_config"
        iniSet  "input_overlay_opacity" "1.0" "$core_config"
        iniSet  "input_overlay_scale" "1.0" "$core_config"
        iniSet  "video_fullscreen_x" "1920" "$core_config"
        iniSet  "video_fullscreen_y" "1080" "$core_config"
        iniSet  "custom_viewport_width" "1280" "$core_config"
        iniSet  "custom_viewport_height" "960" "$core_config"
        iniSet  "custom_viewport_x" "320" "$core_config"
        iniSet  "custom_viewport_y" "60" "$core_config"
        iniSet  "aspect_ratio_index" "22" "$core_config"
        iniSet  "input_overlay_enable" "true" "$core_config"
        iniSet  "video_smooth" "true" "$core_config"
        iniSet  "rewind_enable" "false" "$core_config"
        iniSet  "game_specific_options" "true" "$core_config"
        iniSet  "input_player1_analog_dpad_mode" "0" "$core_config"
        iniSet  "input_player2_analog_dpad_mode" "0" "$core_config"
    # iniSet  "beetle_psx_hw_pgxp_texture" "On" "$core_config"
        iniSet  "pcsx_rearmed_neon_enhancement_enable" "enabled" "$core_config"
        iniSet  "pcsx_rearmed_neon_enhancement_no_main" "enabled" "$core_config"
        iniSet  "pcsx_rearmed_pad1type" "analog" "$core_config"
        iniSet  "pcsx_rearmed_pad2type" "analog" "$core_config"
        #iniSet "pcsx_rearmed_show_bios_bootlogo" "enableded" "$core_config"
        iniSet  "beetle_psx_widescreen_hack" "on" "$core_config"
        iniSet  "beetle_psx_internal_resolution" "4x" "$core_config"

        chown $user:$user "$core_config"

    fi
    done
}