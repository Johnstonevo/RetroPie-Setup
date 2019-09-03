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
  mkRomDir "sor"
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
  ensureSystemretroconfig "sor"

  local def=0
  isPlatform "armv6" && def=0

  addEmulator 0 "$md_id"  "gamegear" "$md_inst/picodrive_libretro.so"
  addEmulator 0 "$md_id"  "ggh" "$md_inst/picodrive_libretro.so"
  addEmulator 0 "$md_id"  "mastersystem" "$md_inst/picodrive_libretro.so"
  addEmulator 1 "$md_id"  "megadrive" "$md_inst/picodrive_libretro.so"
  addEmulator 1 "$md_id"  "megadrive-japan" "$md_inst/picodrive_libretro.so"
  addEmulator 1 "$md_id"  "genesis" "$md_inst/picodrive_libretro.so"
  addEmulator 1 "$md_id"  "genh" "$md_inst/picodrive_libretro.so"
  addEmulator 0 "$md_id"  "sg-1000" "$md_inst/picodrive_libretro.so"
  addEmulator 0 "$md_id"  "segacd" "$md_inst/picodrive_libretro.so"
  addEmulator 0 "$md_id"  "markiii" "$md_inst/picodrive_libretro.so"
  addEmulator 1 "$md_id"  "sega32x" "$md_inst/picodrive_libretro.so"
  addEmulator 1 "$md_id"  "sc-3000" "$md_inst/picodrive_libretro.so"
  addEmulator 1 "$md_id"  "sor" "$md_inst/picodrive_libretro.so"
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
  addSystem  "sor"

  addBezel "megadrive"
  addBezel "sg-1000"
  addBezel "segacd"
  addBezel "mastersystem"
  addBezel "sega32x"


        if [ -e $md_instppa/picodrive_libretro.so ]
            then
              local def=0
              isPlatform "armv6" && def=0

              addEmulator 0 "$md_id-ppa"  "gamegear" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "ggh" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "mastersystem" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "megadrive" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "megadrive-japan" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "genesis" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "genh" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "sg-1000" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "segacd" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "markiii" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "sega32x" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "sc-3000" "$md_instppa/picodrive_libretro.so"
              addEmulator 0 "$md_id-ppa" "sor" "$md_instppa/picodrive_libretro.so"
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

#setRetroArchCoreOption "picodrive_input1" "6 button pad"
#setRetroArchCoreOption "picodrive_input2" "6 button pad"
#setRetroArchCoreOption "picodrive_sprlim" "disabled"
#setRetroArchCoreOption "picodrive_ramcart" "disabled"
#setRetroArchCoreOption "picodrive_region" "Auto"
#setRetroArchCoreOption "picodrive_drc" "enabled"



            cp /home/$user/.config/RetroPie/megadrive/retroarch.cfg /home/$user/.config/RetroPie/megadrive/retroarch.cfg.bkp
            local core_config="megadrive"
            setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sega-Mega-Drive.cfg"
            setRetroArchCoreOption "input_overlay_opacity" "1.0" 
            setRetroArchCoreOption "input_overlay_scale" "1.0" 
            setRetroArchCoreOption "input_overlay_enable" "true" 
            setRetroArchCoreOption "picodrive_input1" "6 button pad" 
            setRetroArchCoreOption "picodrive_input2" "6 button pad" 
            setRetroArchCoreOption "picodrive_sprlim"  "disabled" 
            setRetroArchCoreOption "picodrive_ramcart"  "disabled" 
            setRetroArchCoreOption "picodrive_region"  "Auto" 
            setRetroArchCoreOption "picodrive_drc"  "enabled" 
            setRetroArchCoreOption "video_smooth" "false" 
            setRetroArchCoreOption  "video_shader" "$raconfigdir/shaders/crt/zfast-crt.cgp" 
            setRetroArchCoreOption  "video_shader_enable"  "true" 



            cp /home/$user/.config/RetroPie/megadrive-japan/retroarch.cfg /home/$user/.config/RetroPie/megadrive-japan/retroarch.cfg.bkp
            local core_config="megadrive-japan"
            setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sega-Mega-Drive.cfg" 
            setRetroArchCoreOption "input_overlay_opacity" "1.0" 
            setRetroArchCoreOption "input_overlay_scale" "1.0" 
            setRetroArchCoreOption "input_overlay_enable" "true" 
            setRetroArchCoreOption "video_smooth" "false" 
            setRetroArchCoreOption  "video_shader" "$raconfigdir/shaders/crt/zfast-crt.cgp" 
            setRetroArchCoreOption  "video_shader_enable"  "true" 
            setRetroArchCoreOption "picodrive_input1" "6 button pad" 
            setRetroArchCoreOption "picodrive_input2" "6 button pad" 
            setRetroArchCoreOption "picodrive_sprlim"  "disabled" 
            setRetroArchCoreOption "picodrive_ramcart"  "disabled" 
            setRetroArchCoreOption "picodrive_drc"  "enabled" 
            setRetroArchCoreOption "picodrive_region" "Auto" 



            cp /home/$user/.config/RetroPie/genesis/retroarch.cfg /home/$user/.config/RetroPie/genesis/retroarch.cfg.bkp
            local core_config="genesis"
            setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sega-Mega-Drive.cfg"
            setRetroArchCoreOption "input_overlay_opacity" "1.0" 
            setRetroArchCoreOption "input_overlay_scale" "1.0" 
            setRetroArchCoreOption "input_overlay_enable" "true" 
            setRetroArchCoreOption "video_smooth" "false" 
            setRetroArchCoreOption  "video_shader" "$raconfigdir/shaders/crt/zfast-crt.cgp" 
            setRetroArchCoreOption  "video_shader_enable"  "true" 
            setRetroArchCoreOption "picodrive_input1" "6 button pad" 
            setRetroArchCoreOption "picodrive_input2" "6 button pad" 
            setRetroArchCoreOption "picodrive_sprlim"  "disabled" 
            setRetroArchCoreOption "picodrive_ramcart"  "disabled" 
            setRetroArchCoreOption "picodrive_region"  "Auto" 
            setRetroArchCoreOption "picodrive_drc"  "enabled" 




            cp /home/$user/.config/RetroPie/genh/retroarch.cfg /home/$user/.config/RetroPie/genh/retroarch.cfg.bkp
            local core_config="genh"
            setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sega-Mega-Drive.cfg"
            setRetroArchCoreOption "input_overlay_opacity" "1.0" 
            setRetroArchCoreOption "input_overlay_scale" "1.0" 
            setRetroArchCoreOption "input_overlay_enable" "true" 
            setRetroArchCoreOption "video_smooth" "false" 
            setRetroArchCoreOption  "video_shader" "$raconfigdir/shaders/crt/zfast-crt.cgp" 
            setRetroArchCoreOption  "video_shader_enable"  "true" 
            setRetroArchCoreOption "picodrive_input1" "6 button pad" 
            setRetroArchCoreOption "picodrive_input2" "6 button pad" 
            setRetroArchCoreOption "picodrive_sprlim"  "disabled" 
            setRetroArchCoreOption "picodrive_ramcart"  "disabled" 
            setRetroArchCoreOption "picodrive_region"  "Auto" 
            setRetroArchCoreOption "picodrive_drc"  "enabled" 


             cp /home/$user/.config/RetroPie/segacd/retroarch.cfg /home/$user/.config/RetroPie/segacd/retroarch.cfg.bkp
            local core_config="segacd"
            iniConfig " = " "\"" "$md_conf_root/segacd/retroarch.cfg"
            setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/segacd.cfg"
            setRetroArchCoreOption "input_overlay_opacity" "1.0" 
            setRetroArchCoreOption "input_overlay_scale" "1.0" 
            setRetroArchCoreOption "input_overlay_enable" "true" 
            setRetroArchCoreOption "video_smooth" "false" 
            setRetroArchCoreOption  "video_shader" "$raconfigdir/shaders/crt/zfast-crt.cgp" 
            setRetroArchCoreOption  "video_shader_enable"  "true" 
            setRetroArchCoreOption "picodrive_input1" "6 button pad" 
            setRetroArchCoreOption "picodrive_input2" "6 button pad" 
            setRetroArchCoreOption "picodrive_sprlim"  "disabled" 
            setRetroArchCoreOption "picodrive_ramcart"  "disabled" 
            setRetroArchCoreOption "picodrive_region"  "Auto" 
            setRetroArchCoreOption "picodrive_drc"  "enabled" 



             cp /home/$user/.config/RetroPie/mastersystem/retroarch.cfg /home/$user/.config/RetroPie/mastersystem/retroarch.cfg.bkp
            local core_config="mastersystem"
            setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sega-Master-System.cfg"
            setRetroArchCoreOption "input_overlay_opacity" "1.0"
            setRetroArchCoreOption "input_overlay_scale" "1.0"
            setRetroArchCoreOption "picodrive_region" "Auto"
            setRetroArchCoreOption "video_smooth" "false"
            setRetroArchCoreOption  "video_shader" "$raconfigdir/shaders/crt/zfast-crt.cgp"
            setRetroArchCoreOption  "video_shader_enable"  "true"


      cp /home/$user/.config/RetroPie/sega32x/retroarch.cfg /home/$user/.config/RetroPie/sega32x/retroarch.cfg.bkp
            local core_config="sega32x"
            setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sega-32X.cfg"
            setRetroArchCoreOption "input_overlay_opacity" "1.0"
            setRetroArchCoreOption "input_overlay_scale" "1.0"
            setRetroArchCoreOption "input_overlay_enable" "true"
            setRetroArchCoreOption "video_smooth" "false"
            setRetroArchCoreOption "picodrive_input1" "6 button pad"
            setRetroArchCoreOption "picodrive_input2" "6 button pad"
            setRetroArchCoreOption "picodrive_sprlim"  "disabled"
            setRetroArchCoreOption "picodrive_ramcart"  "disabled"
            setRetroArchCoreOption "picodrive_region"  "Auto"
            setRetroArchCoreOption "picodrive_drc"  "enabled"
            setRetroArchCoreOption "video_smooth" "false"
            setRetroArchCoreOption  "video_shader" "$raconfigdir/shaders/crt/zfast-crt.cgp"
            setRetroArchCoreOption  "video_shader_enable"  "true"



}
