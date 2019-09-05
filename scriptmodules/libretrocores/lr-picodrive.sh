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
            local def
            isPlatform "armv6" && def=0

            for system in gamegear ggh mastersystem megadrive megadrive-japan genesis genh sg-1000  segacd markiii seag32x sc-3000 sor  ; do
                def=0
                [[ "$system" == "megadrive" || "$system" == "megadrive-japan"  || "$system" == "genesis"  || "$system" == "genh"  || "$system" == "sega32x"  || "$system" == "sc-3000"  || "$system" == "sor"  ]] && def=1
                mkRomDir "$system"
                ensureSystemretroconfig "$system"
                addEmulator def "$md_id" "$system" "$md_inst/picodrive_libretro.so"
                addSystem "$system"
                local core_config="$system"
                setRetroArchCoreOption  "input_overlay_opacity" "1.0" 
                setRetroArchCoreOption  "input_overlay_scale" "1.0" 
                setRetroArchCoreOption  "input_overlay_enable" "true" 
                setRetroArchCoreOption  "picodrive_input1" "6 button pad"
                setRetroArchCoreOption  "picodrive_input2" "6 button pad"
                setRetroArchCoreOption  "picodrive_sprlim" "disabled"
                setRetroArchCoreOption  "picodrive_ramcart" "disabled"
                setRetroArchCoreOption  "picodrive_region" "Auto"
                setRetroArchCoreOption  "picodrive_drc" "enabled"
                setRetroArchCoreOption  "video_smooth" "false" 
                setRetroArchCoreOption  "video_shader" "$raconfigdir/shaders/crt/zfast-crt.cgp" 
                setRetroArchCoreOption  "video_shader_enable"  "true" 
            done





        if [ -e $md_instppa/picodrive_libretro.so ]
            then

                local system
                local def
                isPlatform "armv6" && def=0

                for system in gamegear ggh mastersystem megadrive megadrive-japan genesis genh sg-1000  segacd markiii seag32x sc-3000 sor  ; do
                    def=0
                    mkRomDir "$system"
                    ensureSystemretroconfig "$system"
                    addEmulator def "$md_id-ppa" "$system" "$md_instppa/picodrive_libretro.so"
                    addSystem "$system"
                done

        fi



        for system in megadrive megadrive-japan genesis genh  ; do

            cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp
            local core_config="$system"
            setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sega-Mega-Drive.cfg"
        done





        cp /home/$user/.config/RetroPie/segacd/retroarch.cfg /home/$user/.config/RetroPie/segacd/retroarch.cfg.bkp
        local core_config="segacd"
        iniConfig " = " "\"" "$md_conf_root/segacd/retroarch.cfg"
        setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sega-CD.cfg"
        

        cp /home/$user/.config/RetroPie/mastersystem/retroarch.cfg /home/$user/.config/RetroPie/mastersystem/retroarch.cfg.bkp
        local core_config="mastersystem"
        setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sega-Master-System.cfg"
        


        cp /home/$user/.config/RetroPie/sega32x/retroarch.cfg /home/$user/.config/RetroPie/sega32x/retroarch.cfg.bkp
        local core_config="sega32x"
        setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sega-32X.cfg"
            



}
