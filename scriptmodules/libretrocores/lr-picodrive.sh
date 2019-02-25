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
  mkRomDir "gamegear"
  mkRomDir "ggh"
  mkRomDir "mastersystem"
  mkRomDir "megadrive"
  mkRomDir "megadrive-japan"
  mkRomDir "genesis"
  mkRomDir "genh"
  mkRomDir "sg-1000"
  mkRomDir "segacd"
  mkRomDir "markiii"
  mkRomDir "sega32x"
  mkRomDir "sc-3000"
  ensureSystemretroconfig "gamegear"
  ensureSystemretroconfig "ggh"
  ensureSystemretroconfig "mastersystem"
  ensureSystemretroconfig "megadrive"
  ensureSystemretroconfig "megadrive-japan"
  ensureSystemretroconfig "genesis"
  ensureSystemretroconfig "genh"
  ensureSystemretroconfig "sg-1000"
  ensureSystemretroconfig "segacd"
  ensureSystemretroconfig "markiii"
  ensureSystemretroconfig "sega32x"
  ensureSystemretroconfig "sc-3000"

  local def=0
  isPlatform "armv6" && def=0

  addEmulator 0 "$md_id"  "gamegear" "$md_inst/picodrive_libretro.so"
  addEmulator 0 "$md_id"  "ggh" "$md_inst/picodrive_libretro.so"
  addEmulator 1 "$md_id"  "mastersystem" "$md_inst/picodrive_libretro.so"
  addEmulator 1 "$md_id"  "megadrive" "$md_inst/picodrive_libretro.so"
  addEmulator 1 "$md_id"  "megadrive-japan" "$md_inst/picodrive_libretro.so"
  addEmulator 1 "$md_id"  "genesis" "$md_inst/picodrive_libretro.so"
  addEmulator 1 "$md_id"  "genh" "$md_inst/picodrive_libretro.so"
  addEmulator 0 "$md_id"  "sg-1000" "$md_inst/picodrive_libretro.so"
  addEmulator 0 "$md_id"  "segacd" "$md_inst/picodrive_libretro.so"
  addEmulator 0 "$md_id"  "markiii" "$md_inst/picodrive_libretro.so"
  addEmulator 1 "$md_id"  "sega32x" "$md_inst/picodrive_libretro.so"
  addEmulator 1 "$md_id"  "sc-3000" "$md_inst/picodrive_libretro.so"
  addSystem  "gamegear"
  addSystem  "mastersystem"
  addSystem  "megadrive"
  addSystem  "megadrive-japan"
  addSystem  "genesis"
  addSystem  "genh"
  addSystem  "sg-1000"
  addSystem  "segacd"
  addSystem  "markiii"
  addSystem  "sega32x"
  addSystem  "sc-3000"


        if [ -e $md_instppa/picodrive_libretro.so ]
            then
              mkRomDir "gamegear"
              mkRomDir "ggh"
              mkRomDir "mastersystem"
              mkRomDir "megadrive"
              mkRomDir "megadrive-japan"
              mkRomDir "genesis"
              mkRomDir "genh"
              mkRomDir "sg-1000"
              mkRomDir "segacd"
              mkRomDir "markiii"
              mkRomDir "sega32x"
              mkRomDir "sc-3000"
              ensureSystemretroconfig "gamegear"
              ensureSystemretroconfig "ggh"
              ensureSystemretroconfig "mastersystem"
              ensureSystemretroconfig "megadrive"
              ensureSystemretroconfig "megadrive-japan"
              ensureSystemretroconfig "genesis"
              ensureSystemretroconfig "genh"
              ensureSystemretroconfig "sg-1000"
              ensureSystemretroconfig "segacd"
              ensureSystemretroconfig "markiii"
              ensureSystemretroconfig "sega32x"
              ensureSystemretroconfig "sc-3000"

              local def=0
              isPlatform "armv6" && def=0

              addEmulator 0 "$md_id-ppa"  "gamegear" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "ggh" "$md_instppa/picodrive_libretro.so"
              addEmulator 1 "$md_id-ppa" "mastersystem" "$md_instppa/picodrive_libretro.so"
              addEmulator 1 "$md_id-ppa" "megadrive" "$md_instppa/picodrive_libretro.so"
              addEmulator 1 "$md_id-ppa" "megadrive-japan" "$md_instppa/picodrive_libretro.so"
              addEmulator 1 "$md_id-ppa" "genesis" "$md_instppa/picodrive_libretro.so"
              addEmulator 1 "$md_id-ppa" "genh" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "sg-1000" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "segacd" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "markiii" "$md_instppa/picodrive_libretro.so"
              addEmulator 1 "$md_id-ppa" "sega32x" "$md_instppa/picodrive_libretro.so"
              addEmulator 1 "$md_id-ppa" "sc-3000" "$md_instppa/picodrive_libretro.so"
              addSystem  "gamegear"
              addSystem  "mastersystem"
              addSystem  "megadrive"
              addSystem  "megadrive-japan"
              addSystem  "genesis"
              addSystem  "genh"
              addSystem  "sg-1000"
              addSystem  "segacd"
              addSystem  "markiii"
              addSystem  "sega32x"
              addSystem  "sc-3000"

        fi

setRetroArchCoreOption "picodrive_input1" "6 button pad"
setRetroArchCoreOption "picodrive_input2" "6 button pad"
setRetroArchCoreOption "picodrive_sprlim" "disabled"
setRetroArchCoreOption "picodrive_ramcart" "disabled"
setRetroArchCoreOption "picodrive_region" "Auto"
setRetroArchCoreOption "picodrive_drc" "enabled"

 if [ ! -d $raconfigdir/overlay/GameBezels/Megadrive ]
    then
        git clone https://github.com/thebezelproject/bezelproject-MegaDrive.git  "/home/$user/RetroPie-Setup/tmp/MegaDrive"
        cp -r  /home/$user/RetroPie-Setup/tmp/MegaDrive/retroarch/  /home/$user/.config/
        rm -rf /home/$user/RetroPie-Setup/tmp/MegaDrive/
        cd /home/$user/.config/retroarch
        chown -R $user:$user ../retroarch
        find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
fi
 if [ ! -d $raconfigdir/overlay/GameBezels/SegaCD ]
    then
        git clone https://github.com/thebezelproject/bezelproject-SegaCD.git  "/home/$user/RetroPie-Setup/tmp/SegaCD"
        cp -r  /home/$user/RetroPie-Setup/tmp/SegaCD/retroarch/  /home/$user/.config/
        rm -rf /home/$user/RetroPie-Setup/tmp/SegaCD/
        cd /home/$user/.config/retroarch
        chown -R $user:$user ../retroarch
        find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
fi
 if [ ! -d $raconfigdir/overlay/GameBezels/MasterSystem ]
    then
        git clone https://github.com/thebezelproject/bezelproject-MasterSystem.git  "/home/$user/RetroPie-Setup/tmp/MasterSystem"
        cp -r  /home/$user/RetroPie-Setup/tmp/MasterSystem/retroarch/  /home/$user/.config/
        rm -rf /home/$user/RetroPie-Setup/tmp/MasterSystem/
        cd /home/$user/.config/retroarch
        chown -R $user:$user ../retroarch
        find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
fi
 if [ ! -d $raconfigdir/overlay/GameBezels/Sega32X ]
    then
        git clone https://github.com/thebezelproject/bezelproject-Sega32X.git  "/home/$user/RetroPie-Setup/tmp/Sega32X"
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
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_sprlim"  "disabled" "$core_config"
            iniSet "picodrive_ramcart"  "disabled" "$core_config"
            iniSet "picodrive_region"  "Auto" "$core_config"
            iniSet "picodrive_drc"  "enabled" "$core_config"
            iniSet "picodrive_region" "Auto" "$core_config"
            iniSet "video_smooth" "false" "$core_config"
            iniSet  "video_shader" "/home/$user/.config/retroarch/shaders/crt/zfast-crt.cgp" "$core_config"
            iniSet  "video_shader_enable"  "true" "$core_config"

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
            iniSet "video_smooth" "false" "$core_config"
            iniSet  "video_shader" "/home/$user/.config/retroarch/shaders/crt/zfast-crt.cgp" "$core_config"
            iniSet  "video_shader_enable"  "true" "$core_config"
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_sprlim"  "disabled" "$core_config"
            iniSet "picodrive_ramcart"  "disabled" "$core_config"
            iniSet "picodrive_region"  "Auto" "$core_config"
            iniSet "picodrive_drc"  "enabled" "$core_config"
            iniSet "picodrive_region" "Japan Pal" "$core_config"

            cp /home/$user/.config/RetroPie/genesis/retroarch.cfg /home/$user/.config/RetroPie/genesis/retroarch.cfg.bkp
            local core_config="$configdir/genesis/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/genesis/retroarch.cfg"
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
            iniSet "video_smooth" "false" "$core_config"
            iniSet  "video_shader" "/home/$user/.config/retroarch/shaders/crt/zfast-crt.cgp" "$core_config"
            iniSet  "video_shader_enable"  "true" "$core_config"
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_sprlim"  "disabled" "$core_config"
            iniSet "picodrive_ramcart"  "disabled" "$core_config"
            iniSet "picodrive_region"  "Auto" "$core_config"
            iniSet "picodrive_drc"  "enabled" "$core_config"

            cp /home/$user/.config/RetroPie/genh/retroarch.cfg /home/$user/.config/RetroPie/genh/retroarch.cfg.bkp
            local core_config="$configdir/genh/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/genh/retroarch.cfg"
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
            iniSet "video_smooth" "false" "$core_config"
            iniSet  "video_shader" "/home/$user/.config/retroarch/shaders/crt/zfast-crt.cgp" "$core_config"
            iniSet  "video_shader_enable"  "true" "$core_config"
            iniSet "input_libretro_device_p1" "513" "$core_config"
            iniSet "input_libretro_device_p2" "513" "$core_config"
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
            iniSet "video_smooth" "false" "$core_config"
            iniSet  "video_shader" "/home/$user/.config/retroarch/shaders/crt/zfast-crt.cgp" "$core_config"
            iniSet  "video_shader_enable"  "true" "$core_config"
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_input1" "6 button pad" "$core_config"
            iniSet "picodrive_sprlim"  "disabled" "$core_config"
            iniSet "picodrive_ramcart"  "disabled" "$core_config"
            iniSet "picodrive_region"  "Auto" "$core_config"
            iniSet "picodrive_drc"  "enabled" "$core_config"
            iniSet "picodrive_region" "Auto" "$core_config"


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
            iniSet "picodrive_region" "Auto" "$core_config"
            iniSet "video_smooth" "false" "$core_config"
            iniSet  "video_shader" "/home/$user/.config/retroarch/shaders/crt/zfast-crt.cgp" "$core_config"
            iniSet  "video_shader_enable"  "true" "$core_config"


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
            iniSet "picodrive_region" "Auto" "$core_config"
            iniSet "video_smooth" "false" "$core_config"
            iniSet  "video_shader" "/home/$user/.config/retroarch/shaders/crt/zfast-crt.cgp" "$core_config"
            iniSet  "video_shader_enable"  "true" "$core_config"


fi
}
