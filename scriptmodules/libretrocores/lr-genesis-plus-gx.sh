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
            isPlatform "armv6" && def=0

            for system in gamegear ggh mastersystem megadrive megadrive-japan genesis genh sg-1000  segacd markiii sega32x sc-3000 sor  ; do
                def=0
                [[ "$system" == "gamegear" || "$system" == "ggh"  || "$system" == "mastersystem"  || "$system" == "sg-1000"  || "$system" == "segacd"  || "$system" == "markiii"  || "$system" == "sc-1000"  ]] && def=1
                mkRomDir "$system"
                ensureSystemretroconfig "$system"
                addEmulator def "$md_id" "$system" "$md_inst/genesis_plus_gx_libretro.so"
                addSystem "$system"
            done






  addBezel "megadrive"
  addBezel "sg-1000"
  addBezel "segacd"
  addBezel "mastersystem"
  addBezel "sega32x

"
    if [ -e $md_instcore/genesis_plus_gx_libretro.so ] ;
        then
            local system
            local def
            for system in gamegear ggh mastersystem megadrive megadrive-japan genesis genh sg-1000  segacd markiii sega32x sc-3000 sor  ; do
                def=0
                mkRomDir "$system"
                ensureSystemretroconfig "$system"
                addEmulator def "$md_id-core" "$system" "$md_instcore/genesis_plus_gx_libretro.so"
                addSystem "$system"
                local core_config=$system

            done


    fi

            for system in megadrive megadrive-japan genesis genh  sor  ; do
            local core_config="$system"
                cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp
                setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sega-Mega-Drive.cfg"
                setRetroArchCoreOption  "input_overlay_opacity" "1.0"
                setRetroArchCoreOption  "input_overlay_scale" "1.0"
                setRetroArchCoreOption  "input_libretro_device_p1" "513"
                setRetroArchCoreOption  "input_libretro_device_p2" "513"
                setRetroArchCoreOption  "video_shader" "$raconfigdir/shaders/crt/zfast-crt.cgp"
                setRetroArchCoreOption  "video_shader_enable"  "true"
                setRetroArchCoreOption  "genesis_plus_gx_system_hw" "mega drive"

            done

##retroconfig##
###############



        cp /home/$user/.config/RetroPie/segacd/retroarch.cfg /home/$user/.config/RetroPie/segacd/retroarch.cfg.bkp
        local core_config="segacd"
        setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sega-CD.cfg"
        setRetroArchCoreOption "input_overlay_opacity" "1.0"
        setRetroArchCoreOption "input_overlay_scale" "1.0"
        setRetroArchCoreOption "input_libretro_device_p1" "513"
        setRetroArchCoreOption "input_libretro_device_p2" "513"
        setRetroArchCoreOption  "video_shader" "$raconfigdir/shaders/crt/zfast-crt.cgp"
        setRetroArchCoreOption  "video_shader_enable"  "true"


        cp /home/$user/.config/RetroPie/sg-1000/retroarch.cfg /home/$user/.config/RetroPie/sg-1000/retroarch.cfg.bkp
        local core_config="sg-1000"
        setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sega-SG-1000.cfg"
        setRetroArchCoreOption  "input_overlay_opacity" "1.0"
        setRetroArchCoreOption  "input_overlay_scale" "1.0"
        setRetroArchCoreOption  "custom_viewport_width" "1280"
        setRetroArchCoreOption  "custom_viewport_height" "960"
        setRetroArchCoreOption  "custom_viewport_x" "300"
        setRetroArchCoreOption  "custom_viewport_y" "65"
        setRetroArchCoreOption  "aspect_ratio_index" "22"
        setRetroArchCoreOption  "video_shader" "$raconfigdir/shaders/crt/zfast-crt.cgp"
        setRetroArchCoreOption  "video_shader_enable"  "true"
        setRetroArchCoreOption  "genesis_plus_gx_system_hw" "sg-1000 II"

        cp /home/$user/.config/RetroPie/mastersystem/retroarch.cfg /home/$user/.config/RetroPie/mastersystem/retroarch.cfg.bkp
        local core_config="mastersystem"
        setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Sega-Master-System.cfg"
        setRetroArchCoreOption  "input_overlay_opacity" "1.0"
        setRetroArchCoreOption  "input_overlay_scale" "1.0"
        setRetroArchCoreOption  "video_smooth" "false"
        setRetroArchCoreOption  "video_shader" "$raconfigdir/shaders/crt/zfast-crt.cgp"
        setRetroArchCoreOption  "video_shader_enable"  "true"
        setRetroArchCoreOption  "genesis_plus_gx_system_hw" "master system II"


 
    cp /home/$user/.config/RetroPie/gamegear/retroarch.cfg /home/$user/.config/RetroPie/gamegear/retroarch.cfg.bkp
    local core_config="gamegear"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlays/handhelds/gg.cfg"
    setRetroArchCoreOption "input_overlay_enable" "true"
    setRetroArchCoreOption "video_smooth" "false"
    setRetroArchCoreOption "input_overlay_opacity" "1.0"
    setRetroArchCoreOption "input_overlay_scale" "1.0"
    setRetroArchCoreOption "genesis_plus_gx_system_hw" "game gear"
    setRetroArchCoreOption  "game_specific_options" "false"
    setRetroArchCoreOption  "auto_overrides_enable" "false"

cp /home/$user/.config/RetroPie/ggh/retroarch.cfg /home/$user/.config/RetroPie/ggh/retroarch.cfg.bkp
    local core_config="ggh"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlays/handhelds/gg.cfg"
    setRetroArchCoreOption "input_overlay_enable" "true"
    setRetroArchCoreOption "video_smooth" "false"
    setRetroArchCoreOption "input_overlay_opacity" "1.0"
    setRetroArchCoreOption "input_overlay_scale" "1.0"
    setRetroArchCoreOption "genesis_plus_gx_system_hw" "game gear"
    setRetroArchCoreOption  "game_specific_options" "false"
    setRetroArchCoreOption  "auto_overrides_enable" "false"
}
