#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-fceumm"
rp_module_desc="NES emu - FCEUmm port for libretro"
rp_module_help="ROM Extensions: .nes .zip\n\nCopy your NES roms to $romdir/nes\n\nFor the Famicom Disk System copy your roms to $romdir/fds\n\nFor the Famicom Disk System copy the required BIOS file disksys.rom to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/libretro-fceumm/master/Copying"
rp_module_section="main"

function sources_lr-fceumm() {
    gitPullOrClone "$md_build" https://github.com/libretro/libretro-fceumm.git
}

function build_lr-fceumm() {
    make -f Makefile.libretro clean
    make -f Makefile.libretro
    md_ret_require="$md_build/fceumm_libretro.so"
}

function install_lr-fceumm() {
    md_ret_files=(
        'Authors'
        'changelog.txt'
        'Copying'
        'fceumm_libretro.so'
        'whatsnew.txt'
        'zzz_todo.txt'
    )
}

function configure_lr-fceumm() {
    mkRomDir "nes"
    mkRomDir "fds"
    mkRomDir "famicom"
    ensureSystemretroconfig "nes"
    ensureSystemretroconfig "fds"
    ensureSystemretroconfig "famicom"

    local def=1
    isPlatform "armv6" && def=0

    addEmulator "$def" "$md_id" "nes" "$md_inst/fceumm_libretro.so"
    addEmulator 0 "$md_id" "fds" "$md_inst/fceumm_libretro.so"
    addEmulator 0 "$md_id" "famicom" "$md_inst/fceumm_libretro.so"
    addSystem "nes"
    addSystem "fds"
    addSystem "famicom"

if [ -e /usr/lib/libretro/fceumm_libretro.so ]
    then
    addEmulator "$def" "$md_id-ppa" "nes" "$md_inst/fceumm_libretro.so"
    addEmulator 0 "$md_id-ppa" "fds" "$md_inst/fceumm_libretro.so"
    addEmulator 0 "$md_id-ppa" "famicom" "$md_inst/fceumm_libretro.so"
    addSystem "nes"
    addSystem "fds"
    addSystem "famicom"
fi


if [ ! -d $raconfigdir/overlay/GameBezels/NES ]
then 
    git clone  https://github.com/thebezelproject/bezelproject-NES.git  "/home/$user/RetroPie-Setup/tmp/NES"
    cp -r  /home/$user/RetroPie-Setup/tmp/NES/retroarch/  /home/$user/.config/
    rm -rf /home/$user/RetroPie-Setup/tmp/NES/
    cd /home/$user/.config/retroarch/
    chown -R $user:$user ../retroarch
    find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
fi
if [ ! -d $raconfigdir/overlay/GameBezels/FDS ]
then 
    git clone  https://github.com/thebezelproject/bezelproject-FDS.git  "/home/$user/RetroPie-Setup/tmp/FDS"
    cp -r  /home/$user/RetroPie-Setup/tmp/FDS/retroarch/  /home/$user/.config/
    rm -rf /home/$user/RetroPie-Setup/tmp/FDS/
    cd /home/$user/.config/retroarch/
    chown -R $user:$user ../retroarch
    find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
fi
if [ ! -d $raconfigdir/overlay/GameBezels/Famicom ]
then 
    git clone  https://github.com/thebezelproject/bezelproject-Famicom.git  "/home/$user/RetroPie-Setup/tmp/Famicom"
    cp -r  /home/$user/RetroPie-Setup/tmp/Famicom/retroarch/  /home/$user/.config/
    rm -rf /home/$user/RetroPie-Setup/tmp/Famicom/
    cd /home/$user/.config/retroarch/
    chown -R $user:$user ../retroarch
    find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
fi
if [  -d $raconfigdir/overlay/GameBezels/NES ]
 then
             cp /home/$user/.config/RetroPie/nes/retroarch.cfg /home/$user/.config/RetroPie/nes/retroarch.cfg.bkp
            local core_config="$configdir/nes/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/nes/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0"
            iniSet "input_overlay_scale" "1.0"
            iniSet "video_fullscreen_x" "1920"
            iniSet "video_fullscreen_y" "1080"
            iniSet "custom_viewport_width" "1280"
            iniSet "custom_viewport_height" "960"
            iniSet "custom_viewport_x" "78"
            iniSet "custom_viewport_y" "57"
            iniSet "aspect_ratio_index" "22"
            iniSet "input_overlay_enable" "true"
            iniSet "video_force_aspect" "true"
            iniSet "video_aspect_ratio" "-1.0"
            iniSet "video_smooth" "false"
            iniSet "fceumm_region" "PAL"
           chown $user:$user "$core_config"

fi
if [  -d $raconfigdir/overlay/GameBezels/fds ]
 then
             cp /home/$user/.config/RetroPie/fds/retroarch.cfg /home/$user/.config/RetroPie/fds/retroarch.cfg.bkp
            local core_config="$configdir/fds/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/fds/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0"
            iniSet "input_overlay_scale" "1.0"
            iniSet "video_fullscreen_x" "1920"
            iniSet "video_fullscreen_y" "1080"
            iniSet "custom_viewport_width" "1280"
            iniSet "custom_viewport_height" "960"
            iniSet "custom_viewport_x" "78"
            iniSet "custom_viewport_y" "57"
            iniSet "aspect_ratio_index" "22"
            iniSet "input_overlay_enable" "true"
            iniSet "video_force_aspect" "true"
            iniSet "video_aspect_ratio" "-1.0"
            iniSet "video_smooth" "false"
            iniSet "fceumm_region" "PAL"
           chown $user:$user "$core_config"

fi
if [  -d $raconfigdir/overlay/GameBezels/Famicom ]
 then
             cp /home/$user/.config/RetroPie/famicom/retroarch.cfg /home/$user/.config/RetroPie/famicom/retroarch.cfg.bkp
            local core_config="$configdir/famicom/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/famicom/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0"
            iniSet "input_overlay_scale" "1.0"
            iniSet "video_fullscreen_x" "1920"
            iniSet "video_fullscreen_y" "1080"
            iniSet "custom_viewport_width" "1280"
            iniSet "custom_viewport_height" "960"
            iniSet "custom_viewport_x" "78"
            iniSet "custom_viewport_y" "57"
            iniSet "aspect_ratio_index" "22"
            iniSet "input_overlay_enable" "true"
            iniSet "video_force_aspect" "true"
            iniSet "video_aspect_ratio" "-1.0"
            iniSet "video_smooth" "false"
            iniSet "fceumm_region" "PAL"
           chown $user:$user "$core_config"
fi
}
