#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-picodrive"
rp_module_desc="Sega 8/16 bit emu - picodrive arm optimised libretro core"
rp_module_help="ROM Extensions: .32x .iso .cue .sms .smd .bin .gen .md .sg .zip\n\nCopy your Megadrive / Genesis roms to $romdir/megadrive\nMasterSystem roms to $romdir/mastersystem\nSega 32X roms to $romdir/sega32x and\nSegaCD roms to $romdir/segacd\nThe Sega CD requires the BIOS files us_scd1_9210.bin, eu_mcd1_9210.bin, jp_mcd1_9112.bin copied to $biosdir"
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/picodrive/master/COPYING"
rp_module_section="main"

function sources_lr-picodrive() {
    gitPullOrClone "$md_build" https://github.com/libretro/picodrive.git
}

function build_lr-picodrive() {
    local params=()
    isPlatform "arm" && params+=(platform=armv ARM_ASM=1 use_fame=0 use_cyclone=1 use_sh2drc=1 use_svpdrc=1)
    if isPlatform "armv6"; then
        params+=(use_cz80=0 use_drz80=1)
    else
        params+=(use_cz80=1 use_drz80=0)
    fi
    make clean
    make -f Makefile.libretro "${params[@]}"
    md_ret_require="$md_build/picodrive_libretro.so"
}

function install_lr-picodrive() {
    md_ret_files=(
        'AUTHORS'
        'COPYING'
        'picodrive_libretro.so'
        'README'
    )
}

function configure_lr-picodrive() {
    local system
    for system in megadrive mastersystem segacd sega32x megadrive-japan; do
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 1 "$md_id" "$system" "$md_inst/picodrive_libretro.so"
        addSystem "$system"
    

        if [ -e /usr/lib/libretro/picodrive_libretro.so ]
            then
                addEmulator "$def" "$md_id-ppa" "$system" "$md_instppa/picodrive_libretro.so"
                addSystem "$system"
        fi
    done
setRetroArchCoreOption "picodrive_input1" "6 button pad"
setRetroArchCoreOption "picodrive_input2" "6 button pad"
setRetroArchCoreOption "picodrive_sprlim" "disabled"
setRetroArchCoreOption "picodrive_ramcart" "disabled"
setRetroArchCoreOption "picodrive_region" "Auto"
setRetroArchCoreOption "picodrive_drc" "enabled"

 if [ ! -d $raconfigdir/overlay/GameBezels/Megadrive ]
    then
        git clone  https://github.com/thebezelproject/bezelproject-MegaDrive.git  "/home/$user/RetroPie-Setup/tmp/MegaDrive"
        cp -r  /home/$user/RetroPie-Setup/tmp/MegaDrive/retroarch/  /home/$user/.config/
        rm -rf /home/$user/RetroPie-Setup/tmp/MegaDrive/
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
 if [ ! -d $raconfigdir/overlay/GameBezels/Sega32X ]
    then
        git clone  https://github.com/thebezelproject/bezelproject-Sega32X.git  "/home/$user/RetroPie-Setup/tmp/Sega32X"
        cp -r  /home/$user/RetroPie-Setup/tmp/Sega32X/retroarch/  /home/$user/.config/
        rm -rf /home/$user/RetroPie-Setup/tmp/Sega32X/
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
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_sprlim"  "disabled" "$core_config"
            iniSet "picodrive_ramcart"  "disabled" "$core_config"
            iniSet "picodrive_region"  "Auto" "$core_config"
            iniSet "picodrive_drc"  "enabled" "$core_config"
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
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_sprlim"  "disabled" "$core_config"
            iniSet "picodrive_ramcart"  "disabled" "$core_config"
            iniSet "picodrive_region"  "Auto" "$core_config"
            iniSet "picodrive_drc"  "enabled" "$core_config"
fi
if [  -d $raconfigdir/overlay/GameBezels/MegaDrive ]
 then
             cp /home/$user/.config/RetroPie/megadrive-japan/retroarch.cfg /home/$user/.config/RetroPie/megadrive-japan/retroarch.cfg.bkp
            local core_config="$configdir/megadrive-japan/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/megadrive-japan/retroarch.cfg"
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
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_sprlim"  "disabled" "$core_config"
            iniSet "picodrive_ramcart"  "disabled" "$core_config"
            iniSet "picodrive_region"  "Auto" "$core_config"
            iniSet "picodrive_drc"  "enabled" "$core_config"
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
if [  -d $raconfigdir/overlay/GameBezels/Sega32X ]
 then
             cp /home/$user/.config/RetroPie/sega32x/retroarch.cfg /home/$user/.config/RetroPie/sega32x/retroarch.cfg.bkp
            local core_config="$configdir/sega32x/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/sega32x/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Sega-32X.cfg" "$core_config"
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
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_sprlim"  "disabled" "$core_config"
            iniSet "picodrive_ramcart"  "disabled" "$core_config"
            iniSet "picodrive_region"  "Auto" "$core_config"
            iniSet "picodrive_drc"  "enabled" "$core_config"
fi
}
