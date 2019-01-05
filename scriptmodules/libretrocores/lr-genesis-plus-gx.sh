#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-genesis-plus-gx"
rp_module_desc="Sega 8/16 bit emu - Genesis Plus (enhanced) port for libretro"
rp_module_help="ROM Extensions: .bin .cue .gen .gg .iso .md .sg .smd .sms .zip\nCopy your Game Gear roms to $romdir/gamegear\nMasterSystem roms to $romdir/mastersystem\nMegadrive / Genesis roms to $romdir/megadrive\nSG-1000 roms to $romdir/sg-1000\nSegaCD roms to $romdir/segacd\nThe Sega CD requires the BIOS files bios_CD_U.bin and bios_CD_E.bin and bios_CD_J.bin copied to $biosdir"
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/Genesis-Plus-GX/master/LICENSE.txt"
rp_module_section="main"

function sources_lr-genesis-plus-gx() {
    gitPullOrClone "$md_build" https://github.com/libretro/Genesis-Plus-GX.git
}

function build_lr-genesis-plus-gx() {
    make -f Makefile.libretro clean
    make -f Makefile.libretro
    md_ret_require="$md_build/genesis_plus_gx_libretro.so"
}

function install_lr-genesis-plus-gx() {
    md_ret_files=(
        'genesis_plus_gx_libretro.so'
        'HISTORY.txt'
        'LICENSE.txt'
        'README.md'
    )
}

function configure_lr-genesis-plus-gx() {
    local system
    local def
    for system in gamegear mastersystem megadrive sg-1000 segacd megadrive-japan; do
        def=0
        [[ "$system" == "gamegear" || "$system" == "sg-1000"|| "$system" == "mastersystem"|| "$system" == "megadrive"|| "$system" == "segacd" || "$system" == "megadrive-japan" ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator "$def" "$md_id" "$system" "$md_inst/genesis_plus_gx_libretro.so"
        addSystem "$system"
        if [ -e /usr/lib/libretro/genesis_plus_gx_libretro.so ]
        then
        addEmulator "$def" "$md_id-ppa" "$system" "$md_instppa/genesis_plus_gx_libretro.so"
        addSystem "$system"
    
    fi
    if [ ! -d $raconfigdir/overlay/GameBezels/Megadrive ]
        then
            git clone  https://github.com/thebezelproject/bezelproject-MegaDrive.git  "/home/$user/RetroPie-Setup/tmp/MegaDrive"
            cp -r  /home/$user/RetroPie-Setup/tmp/MegaDrive/retroarch/  /home/$user/.config/
            rm -rf /home/$user/RetroPie-Setup/tmp/MegaDrive/
            cd /home/$user/.config/retroarch
            chown -R $user:$user ../retroarch
            find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
    fi
    if [ ! -d $raconfigdir/overlay/GameBezels/SG-1000 ]
        then
            git clone  https://github.com/thebezelproject/bezelproject-SG-1000.git  "/home/$user/RetroPie-Setup/tmp/SG-1000"
            cp -r  /home/$user/RetroPie-Setup/tmp/SG-1000/retroarch/  /home/$user/.config/
            rm -rf /home/$user/RetroPie-Setup/tmp/SG-1000/
            cd /home/$user/.config/retroarch
            chown -R $user:$user ../retroarch
            find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
    fi
    if [ ! -d $raconfigdir/overlay/GameBezels/SegaCD ]
        then
            git clone  https://github.com/thebezelproject/bezelproject-SegaCD.git  "/home/$user/RetroPie-Setup/tmp/SegaCD"
            cp -r  /home/$user/RetroPie-Setup/tmp/SegaCD/retroarch/  /home/$user/.config/
            rm -rf /home/$user/RetroPie-Setup/tmp/SegaCD/
            cd /home/$user/.config/retroarch
            chown -R $user:$user ../retroarch
            find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
    fi
    if [ ! -d $raconfigdir/overlay/GameBezels/MasterSystem ]
        then
            git clone  https://github.com/thebezelproject/bezelproject-MasterSystem.git  "/home/$user/RetroPie-Setup/tmp/MasterSystem"
            cp -r  /home/$user/RetroPie-Setup/tmp/MasterSystem/retroarch/  /home/$user/.config/
            rm -rf /home/$user/RetroPie-Setup/tmp/MasterSystem/
            cd /home/$user/.config/retroarch
            chown -R $user:$user ../retroarch
            find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
    fi
    if [  -d $raconfigdir/overlay/GameBezels/Megadrive ]
    then
                cp /home/$user/.config/RetroPie/megadrive/retroarch.cfg /home/$user/.config/RetroPie/megadrive/retroarch.cfg.bkp
                local core_config="$configdir/megadrive/retroarch.cfg"
                iniConfig " = " '"' "$md_conf_root/megadrive/retroarch.cfg"
                iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Sega-Mega-Drive.cfg" "$core_config"
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
                iniSet "input_libretro_device_p1" "513" "$core_config"
                iniSet "input_libretro_device_p2" "513" "$core_config"
    fi
    if [  -d $raconfigdir/overlay/GameBezels/SG-1000 ]
    then
                cp /home/$user/.config/RetroPie/sg-1000/retroarch.cfg /home/$user/.config/RetroPie/sg-1000/retroarch.cfg.bkp
                local core_config="$configdir/sg-1000/retroarch.cfg"
                iniConfig " = " '"' "$md_conf_root/sg-1000/retroarch.cfg"
                iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/SG-1000.cfg" "$core_config"
                iniSet "input_overlay_opacity" "1.0" "$core_config"
                iniSet "input_overlay_scale" "1.0" "$core_config"
                iniSet "video_fullscreen_x" "1920" "$core_config"
                iniSet "video_fullscreen_y" "1080" "$core_config"
    fi
    if [  -d $raconfigdir/overlay/GameBezels/SegaCD ]
    then
                cp /home/$user/.config/RetroPie/segacd/retroarch.cfg /home/$user/.config/RetroPie/segacd/retroarch.cfg.bkp
                local core_config="$configdir/segacd/retroarch.cfg"
                iniConfig " = " '"' "$md_conf_root/segacd/retroarch.cfg"
                iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/segacd.cfg" "$core_config"
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
                iniSet "input_libretro_device_p1" "513" "$core_config"
                iniSet "input_libretro_device_p2" "513" "$core_config"
    fi
    if [  -d $raconfigdir/overlay/GameBezels/SG-1000 ]
    then
                cp /home/$user/.config/RetroPie/sg-1000/retroarch.cfg /home/$user/.config/RetroPie/sg-1000/retroarch.cfg.bkp
                local core_config="$configdir/sg-1000/retroarch.cfg"
                iniConfig " = " '"' "$md_conf_root/sg-1000/retroarch.cfg"
                iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Sega-SG-1000.cfg" "$core_config"
                iniSet "input_overlay_opacity" "1.0" "$core_config"
                iniSet "input_overlay_scale" "1.0" "$core_config"
                iniSet "video_fullscreen_x" "1920" "$core_config"
                iniSet "video_fullscreen_y" "1080" "$core_config"
    fi
    if [  -d $raconfigdir/overlay/GameBezels/MasterSystem ]
    then
                cp /home/$user/.config/RetroPie/mastersystem/retroarch.cfg /home/$user/.config/RetroPie/mastersystem/retroarch.cfg.bkp
                local core_config="$configdir/mastersystem/retroarch.cfg"
                iniConfig " = " '"' "$md_conf_root/mastersystem/retroarch.cfg"
                iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Sega-Master-System.cfg" "$core_config"
                iniSet "input_overlay_opacity" "1.0" "$core_config"
                iniSet "input_overlay_scale" "1.0" "$core_config"
                iniSet "video_fullscreen_x" "1920" "$core_config"
                iniSet "video_fullscreen_y" "1080" "$core_config"
    fi
done
}
