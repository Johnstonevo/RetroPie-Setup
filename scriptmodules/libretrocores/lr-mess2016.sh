#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mess2016"
rp_module_desc="MESS emulator - MESS Port for libretro"
rp_module_help="see wiki for detailed explanation"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame2016-libretro/master/LICENSE.md"
rp_module_section="exp"
rp_module_flags="nobin"

function sources_lr-mess2016() {
    gitPullOrClone "$md_build" https://github.com/libretro/mame2016-libretro.git
    # disable bgfx (fails on neon with recent GCC due to outdated SIMD instrinsics)
    # see https://github.com/libretro/mame2016-libretro/pull/25
    applyPatch "$scriptdir/scriptmodules/$md_type/lr-mame2016/01_disable_bgfx.diff"
}

function build_lr-mess2016() {
    rpSwap on 1200
    local params=($(_get_params_lr-mame) SUBTARGET=mess)
    make clean
    make "${params[@]}"
    rpSwap off
    md_ret_require="$md_build/mess2016_libretro.so"
}

function install_lr-mess2016() {
    md_ret_files=(
        'mess2016_libretro.so'
    )
}

function configure_lr-mess2016() {
    local module="$1"
    [[ -z "$module" ]] && module="mess2016_libretro.so"
    local system
    local def
    for system in nes gb coleco arcadia crvision neocdz cdimono1 ; do
        def=0
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id" "$system" "$md_inst/mess2016_libretro.so"
        addSystem "$system"
            
        local core_config="$system"
        setRetroArchCoreOption "mame2016_softlists_enable" "enabled"
        setRetroArchCoreOption "mame2016_softlists_auto_media" "enabled"
        setRetroArchCoreOption "mame2016_boot_from_cli" "enabled"

    done

    

        mkdir "$biosdir/mame"
        cp -rv "$md_build/hash" "$biosdir/mame/"
        chown -R $user:$user "$biosdir/mame"
}
