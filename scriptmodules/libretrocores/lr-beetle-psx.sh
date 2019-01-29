#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-beetle-psx"
rp_module_desc="PlayStation emulator - Mednafen PSX Port for libretro"
rp_module_help="ROM Extensions: .bin .cue .cbn .img .iso .m3u .mdf .pbp .toc .z .znx\n\nCopy your PlayStation roms to $romdir/psx\n\nCopy the required BIOS files\n\nscph5500.bin and\nscph5501.bin and\nscph5502.bin to\n\n$biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/beetle-psx-libretro/master/COPYING"
rp_module_section="opt"
rp_module_flags="!arm"

function depends_lr-beetle-psx() {
    local depends=(libvulkan-dev libgl1-mesa-dev)
    getDepends "${depends[@]}"
}

function sources_lr-beetle-psx() {
    gitPullOrClone "$md_build" https://github.com/libretro/beetle-psx-libretro.git
}

function build_lr-beetle-psx() {
    make clean
    make HAVE_HW=1
    md_ret_require=(
        'mednafen_psx_hw_libretro.so'
    )
}

function install_lr-beetle-psx() {
    md_ret_files=(
        'mednafen_psx_hw_libretro.so'
    )
}

function configure_lr-beetle-psx() {
    local system
    local def
    for system in psx psx-japan; do
        def=0
        [[ "$system" == "psx" || "$system" == "psx-japan" ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 0 "$md_id" "$system" "$md_inst/mednafen_psx_hw_libretro.so"
        addSystem "$system"
    done
    if [ -e /usr/lib/libretro/mednafen_psx_hw_libretro.so ]
                    then 
                                addEmulator 0 "$md_id-mednafen_psx_hw-ppa" "psx" "$md_instppa/mednafen_psx_hw_libretro.so"
                                addSystem "psx" "$md_instppa/mednafen_psx_hw_libretro.so"
                                addEmulator 0 "$md_id-mednafen_psx_hw-ppa" "psx-japan" "$md_instppa/mednafen_psx_hw_libretro.so"
                                addSystem "psx-japan" "$md_instppa/mednafen_psx_hw_libretro.so"
                                

    fi
    if [ -e /usr/lib/libretro/mednafen_psx_libretro.so ]
                    then 
                                addEmulator 0 "$md_id-mednafen_psx-ppa" "psx" "$md_instppa/mednafen_psx_libretro.so"
                                addSystem "psx" "$md_instppa/mednafen_psx_libretro.so"
                                addEmulator 0 "$md_id-mednafen_psx-ppa" "psx-japan" "$md_instppa/mednafen_psx_libretro.so"
                                addSystem "psx-japan" "$md_instppa/mednafen_psx_libretro.so"
    fi
if [ ! -d $raconfigdir/overlay/GameBezels/PSX ]
    then 
        git clone  https://github.com/thebezelproject/bezelproject-PSX.git  "/home/$user/RetroPie-Setup/tmp/PSX"
        cp -r  /home/$user/RetroPie-Setup/tmp/PSX/retroarch/  /home/$user/.config/
        rm -rf /home/$user/RetroPie-Setup/tmp/PSX/
        cd /home/$user/.config/retroarch/
        chown -R $user:$user ../retroarch
        ln -s $raconfigdir/config/PCSX-ReARMed  $raconfigdir/config/PCSX1

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
    iniSet  "beetle_psx_hw_pgxp_texture" "On" "$core_config"
    iniSet "beetle_psx_internal_resolution" "1x(native)" "$core_config"
    iniSet "beetle_psx_widescreen_hack" "off" "$core_config"
    iniSet "beetle_psx_cd_access_method" "async" "$core_config"
    iniSet "beetle_psx_skip_bios"  "on" "$core_config"
    iniSet "beetle_psx_skipbios" "enabled" "$core_config"
    iniSet "beetle_psx_cd_fastload"  "2x (native)" "$core_config"
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
    iniSet  "beetle_psx_hw_pgxp_texture" "On" "$core_config"
    iniSet "beetle_psx_internal_resolution" "1x(native)" "$core_config"
    iniSet "beetle_psx_widescreen_hack" "disabled" "$core_config"
    iniSet "beetle_psx_cd_access_method" "async" "$core_config"
    iniSet "beetle_psx_skip_bios"  "enabled" "$core_config"
    iniSet "beetle_psx_skipbios" "enabled" "$core_config"
    iniSet "beetle_psx_cd_fastload"  "2x (native)" "$core_config"
    chown $user:$user "$core_config"

fi
}
