#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mess"
rp_module_desc="MESS emulator - MESS Port for libretro"
rp_module_help="see wiki for detailed explanation"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame/master/LICENSE.md"
rp_module_section="exp"

function depends_lr-mess() {
    depends_lr-mame
}

function sources_lr-mess() {
    gitPullOrClone "$md_build" https://github.com/libretro/mame.git
}

function build_lr-mess() {
    rpSwap on 2000
    local params=($(_get_params_lr-mame) SUBTARGET=mess)
    make clean
    make "${params[@]}"
    rpSwap off
    md_ret_require="$md_build/mess_libretro.so"
}

function install_lr-mess() {
    md_ret_files=(
        'LICENSE.md'
        'mess_libretro.so'
        'README.md'
    )
}

function configure_lr-mess() {
    local module="$1"
    [[ -z "$module" ]] && module="mess_libretro.so"

      mkRomDir "nes"
      mkRomDir "gb"
      mkRomDir "coleco"
      mkRomDir "arcadia"
      mkRomDir "crvision"
      mkRomDir "neocdz"
      mkRomDir "cdimono1"
      ensureSystemretroconfig "nes"
      ensureSystemretroconfig "gb"
      ensureSystemretroconfig "coleco"
      ensureSystemretroconfig "arcadia"
      ensureSystemretroconfig "crvision"
      ensureSystemretroconfig "neocdz"
      ensureSystemretroconfig "cdimono1"
      addEmulator 0 "$md_id" "nes" "$md_inst/$module"
      addEmulator 0 "$md_id" "gb" "$md_inst/$module"
      addEmulator 0 "$md_id" "coleco" "$md_inst/$module"
      addEmulator 0 "$md_id" "arcadia" "$md_inst/$module"
      addEmulator 0 "$md_id" "crvison" "$md_inst/$module"
      addEmulator 1 "$md_id" "neocdz" "$md_inst/$module"
      addEmulator 1 "$md_id" "cdimono1" "$md_inst/$module"
      addSystem "nes"
      addSystem "gb"
      addSystem "coleco"
      addSystem "arcadia"
      addSystem "crvision"
      addSystem "neocdz"
      addSystem "cdimono1"
    
    
        local core_config="mess"
        setRetroArchCoreOption "mame_softlists_enable" "enabled"
        setRetroArchCoreOption "mame_softlists_auto_media" "enabled"
        setRetroArchCoreOption "mame_boot_from_cli" "enabled"

        mkdir "$biosdir/mame"
        cp -rv "$md_build/hash" "$biosdir/mame/"
        chown -R $user:$user "$biosdir/mame"
}
