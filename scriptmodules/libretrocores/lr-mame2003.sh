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

    local mame_dir
    local mame_sub_dir
    for mame_dir in arcade mame-libretro; do
        mkRomDir "$mame_dir"
        mkRomDir "$mame_dir/$dir_name"
        ensureSystemretroconfig "$mame_dir"

        for mame_sub_dir in cfg ctrlr diff hi memcard nvram; do
            mkRomDir "$mame_dir/$dir_name/$mame_sub_dir"
        done

        # lr-mame2003-plus also has an artwork folder
        [[ "$md_id" == "lr-mame2003-plus" ]] && mkRomDir "$mame_dir/$dir_name/artwork"
    done

    mkUserDir "$biosdir/$dir_name"
    mkUserDir "$biosdir/$dir_name/samples"

    # copy hiscore.dat
    cp "$md_inst/metadata/"{hiscore.dat,cheat.dat} "$biosdir/$dir_name/"
    chown $user:$user "$biosdir/$dir_name/"{hiscore.dat,cheat.dat}

    # Set core options
    setRetroArchCoreOption "${dir_name}-skip_disclaimer" "enabled"
    setRetroArchCoreOption "${dir_name}-dcs-speedhack" "enabled"
    setRetroArchCoreOption "${dir_name}-samples" "enabled"

    local so_name="$(_get_so_name_${md_id})"
    addEmulator 0 "$md_id" "arcade" "$md_inst/${so_name}_libretro.so"
    addEmulator 1 "$md_id" "mame-libretro" "$md_inst/${so_name}_libretro.so"
    addSystem "arcade"
    addSystem "mame-libretro"
    if [ -e /usr/lib/libretro/mame2003_libretro.so ]
    then
        addEmulator 0 "$md_id-ppa" "arcade" "$md_inst/${so_name}_libretro.so"
    addEmulator 1 "$md_id-ppa" "mame-libretro" "$md_inst/${so_name}_libretro.so"
    addSystem "arcade"
    addSystem "mame-libretro"
    fi
    if [ !  -d $raconfigdir/overlay/GameBezels/MAME ]
    then
      git clone  https://github.com/thebezelproject/bezelproject-MAME.git  "/home/$user/RetroPie-Setup/tmp/MAME"
      cp -r  /home/$user/RetroPie-Setup/tmp/MAME/retroarch/  /home/$user/.config/
      rm -rf /home/$user/RetroPie-Setup/tmp/MAME/
      cd /home/$user/.config/retroarch/
      chown -R $user:$user ../retroarch
      find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
      ln -s "$raconfigdir/config/MAME 2003" "$raconfigdir/config/MAME 2003 (0.78)"
      ln -s "$raconfigdir/config/MAME 2003" "$raconfigdir/config/MAME 2003-Plus"

    fi
    if [  -d $raconfigdir/overlay/GameBezels/MAME ]
     then
        cp /home/$user/.config/RetroPie/mame-libretro/retroarch.cfg /home/$user/.config/RetroPie/mame-libretro/retroarch.cfg.bkp
        local core_config="$configdir/mame-libretro/retroarch.cfg"
         iniConfig " = " '"' "$md_conf_root/mame-libretro/retroarch.cfg"

        iniSet "input_overlay"  "/home/$user/.config/retroarch/overlay/MAME-Horizontal.cfg"
        iniSet "input_overlay_opacity" "1.0"
        iniSet "input_overlay_enable" "true"
    fi
}
