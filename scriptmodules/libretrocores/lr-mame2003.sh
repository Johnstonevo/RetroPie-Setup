#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mame2003"
rp_module_desc="Arcade emu - MAME 0.78 port for libretro"
rp_module_help="ROM Extension: .zip\n\nCopy your MAME roms to either $romdir/mame-libretro or\n$romdir/arcade"
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/mame2003-libretro/master/LICENSE.md"
rp_module_section="main"

function _get_dir_name_lr-mame2003() {
    echo "mame2003"
}

function _get_so_name_lr-mame2003() {
    echo "mame2003"
}

function sources_lr-mame2003() {
    gitPullOrClone "$md_build" https://github.com/libretro/mame2003-libretro.git
}

function build_lr-mame2003() {
    rpSwap on 750
    make clean
    local params=()
    isPlatform "arm" && params+=("ARM=1")
    make ARCH="$CFLAGS" "${params[@]}"
    rpSwap off
    md_ret_require="$md_build/$(_get_so_name_${md_id})_libretro.so"
}

function install_lr-mame2003() {
    md_ret_files=(
        "$(_get_so_name_${md_id})_libretro.so"
        'README.md'
        'CHANGELOG.md'
        'metadata'
    )
}

function configure_lr-mame2003() {
    local dir_name="$(_get_dir_name_${md_id})"
  local core_config=mame-2003    local mame_dir
    local mame_sub_dir
    for mame_dir in arcade mame-2003 mame-2003-plus ; do
        mkRomDir "$mame_dir"
        mkRomDir "$mame_dir/$dir_name"
        ensureSystemretroconfig "$mame_dir"

        for mame_sub_dir in cfg ctrlr diff hi memcard nvram; do
            mkRomDir "$mame_dir/$dir_name/$mame_sub_dir"
        done

        # lr-mame-2003-plus also has an artwork folder
        [[ "$md_id" == "lr-mame-2003-plus" ]] && mkRomDir "$mame_dir/$dir_name/artwork"
    done

    mkUserDir "$biosdir/$dir_name"
    mkUserDir "$biosdir/$dir_name/samples"

    # copy hiscore.dat
    cp "$md_inst/metadata/"{hiscore.dat,cheat.dat} "$biosdir/$dir_name/"
    chown $user:$user "$biosdir/$dir_name/"{hiscore.dat,cheat.dat}

    # Set core options

    local so_name="$(_get_so_name_${md_id})"

    local system
    local def
    for system in arcade mame-2003 ; do
        def=0
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id" "$system" "$md_inst/${so_name}_libretro.so"
        addSystem "$system"

        local core_config="$system"
        setRetroArchCoreOption "mame2003_skip_disclaimer" "enabled"
        setRetroArchCoreOption "mame2003_dcs-speedhack" "enabled"
        setRetroArchCoreOption "mame2003_samples" "enabled"
        setRetroArchCoreOption "input_overlay"  "$raconfigdir/overlay/MAME-Horizontal.cfg"
        setRetroArchCoreOption "input_overlay_opacity" "1.0"
        setRetroArchCoreOption "input_overlay_enable" "true"
        setRetroArchCoreOption  "mame2003_core_save_subfolder" "enabled"
        setRetroArchCoreOption  "mame2003_core_sys_subfolder" "enabled"
        setRetroArchCoreOption  "mame2003_dcs_speedhack" "enabled"
        setRetroArchCoreOption  "mame2003_display_artwork" "enabled"
        setRetroArchCoreOption  "mame2003_display_setup" "disabled"
        setRetroArchCoreOption  "mame2003_dual_joysticks" "disabled"
        setRetroArchCoreOption  "mame2003_frameskip" "0"
        setRetroArchCoreOption  "mame2003_gamma" "1.2"
        setRetroArchCoreOption  "mame2003_input_interface" "retroarch"
        setRetroArchCoreOption  "mame2003_machine_timing" "enabled"
        setRetroArchCoreOption  "mame2003_mame_remapping" "disabled"
        setRetroArchCoreOption  "mame2003_mouse_device" "mouse"
        setRetroArchCoreOption  "mame2003_rstick_to_btns" "enabled"
        setRetroArchCoreOption  "mame2003_sample_rate" "48000"
        setRetroArchCoreOption  "mame2003_skip_disclaimer" "enabled"
        setRetroArchCoreOption  "mame2003_skip_warnings" "enabled"
        setRetroArchCoreOption  "mame2003_tate_mode" "disabled"

    done

    addBezel "mame-2003"



    if [ -e $md_instcore/mame2003_libretro.so ]
    then
        addEmulator 0 "$md_id-core" "arcade" "$md_instcore/${so_name}_libretro.so"
        addEmulator 0 "$md_id-core" "mame-2003-plus" "$md_instcore/${so_name}_libretro.so"
    fi

        ln -s "$raconfigdir/config/MAME 2003" "$raconfigdir/config/MAME 2003 (0.78)"
        ln -s "$raconfigdir/config/MAME 2003" "$raconfigdir/config/MAME 2003-Plus"


    
    
}
