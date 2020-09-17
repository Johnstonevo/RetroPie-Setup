#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="mamearcade64"
rp_module_desc="MAME emulator"
rp_module_help="ROM Extension: .zip\n\nCopy your MAME roms to either $romdir/mame or\n$romdir/arcade"
rp_module_licence="GPL2 https://github.com/mamedev/mame/blob/master/LICENSE.md"
rp_module_section="exp"
rp_module_flags="!all 64bit"

function depends_mamearcade64() {
    if compareVersions $__gcc_version lt 6.0.0; then
        md_ret_errors+=("Sorry, you need an OS with gcc 6.0 or newer to compile mame")
        return 1
    fi

    # Additional libraries required for running
    getDepends libsdl2-ttf-2.0-0

    # Additional libraries required for compilation
    getDepends libfontconfig1-dev qt5-default libsdl2-ttf-dev libxinerama-dev  libsdl2-dev  
}

function sources_mamearcade64() {
    gitPullOrClone "$md_build" https://github.com/mamedev/mame.git
}

function build_mamearcade64() {
    rpSwap on 2048
    make clean
    make SUBTARGET=arcade
    rpSwap off
    md_ret_require="$md_build/mamearcade64"
}

function install_mamearcade64() {
    md_ret_files=(
        'artwork'
        'bgfx'
        'ctrlr'
        'docs'
        'hash'
        'hlsl'
        'ini'
        'language'
        'mamearcade64'
        #'nl_examples'
        'plugins'
        'roms'
        'samples'
        'uismall.bdf'
        #LICENSE.md'
    )
}

function configure_mamearcade64() {
    local system="mame"
    mkRomDir "arcade"
    mkRomDir "arcade/$system"
    mkRomDir "$system"
    #mkRomDir "arcadia"
   # mkRomDir "astrocade"
    #mkRomDir "bbcmicro"
    #mkRomDir "channelf"
    #mkRomDir "electron"
    #mkRomDir "supervision"


    #copyConfigDir "$home/.mame" "$md_conf_root/$system"

    # Create required MAME directories underneath the ROM directory
    if [[ "$md_mode" == "install" ]]; then
        local mame_sub_dir
        for mame_sub_dir in artwork cfg comments diff inp nvram samples scores snap sta; do
            mkRomDir "$system/$mame_sub_dir"
            ln -sf "$romdir/$system/$mame_sub_dir" "$romdir/arcade/$system"
            # fix for older broken symlink generation
            rm -f "$romdir/$system/$mame_sub_dir/$mame_sub_dir"
        done
     fi

     # Create a new INI file if one does not already exist
     if [[ "$md_mode" == "install" && ! -f "$md_conf_root/$system/mame.ini" ]]; then
        pushd "$md_conf_root/$system/"
        "$md_inst/mamearcade64" -createconfig
        popd

        iniConfig " " "" "$md_conf_root/$system/$md_id.ini"
        iniSet "rompath"            "$romdir/$system;$romdir/arcade"
        iniSet "hashpath"           "$md_inst/hash"
        iniSet "samplepath"         "$romdir/$system/samples;$romdir/arcade/samples"
        iniSet "artpath"            "$romdir/$system/artwork;$romdir/arcade/artwork"
        iniSet "ctrlrpath"          "$md_inst/ctrlr"
        iniSet "pluginspath"        "$md_inst/plugins"
        iniSet "languagepath"       "$md_inst/language"

        iniSet "cfg_directory"      "$romdir/$system/cfg"
        iniSet "nvram_directory"    "$romdir/$system/nvram"
        iniSet "input_directory"    "$romdir/$system/inp"
        iniSet "state_directory"    "$romdir/$system/sta"
        iniSet "snapshot_directory" "$romdir/$system/snap"
        iniSet "diff_directory"     "$romdir/$system/diff"
        iniSet "comment_directory"  "$romdir/$system/comments"

        iniSet "skip_gameinfo" "1"
        iniSet "plugin" "hiscore"
        iniSet "samplerate" "44100"

        iniConfig " " "" "$md_conf_root/$system/ui.ini"
        iniSet "scores_directory" "$romdir/$system/scores"

        iniConfig " " "" "$md_conf_root/$system/plugin.ini"
        iniSet "hiscore" "1"

        iniConfig " " "" "$md_conf_root/$system/hiscore.ini"
        iniSet "hi_path" "$romdir/$system/scores"

        chown -R $user:$user "$md_conf_root/$system"
        chmod a+r "$md_conf_root/$system/mame.ini"

    fi

    addEmulator 0 "$md_id" "arcade" "$md_inst/mamearcade64 %ROM%"
    addEmulator 0 "$md_id" "$system" "$md_inst/mamearcade64 %ROM%"
    #addEmulator 1 "$md_id-arcadia" "arcadia" "$md_inst/mamearcade64  arcadia -cfg_directory $configdir/arcadia/   -cart %ROM%"
    #addEmulator 1 "$md_id-astrocade" "astrocade" "$md_inst/mamearcade64 astrocade -cfg_directory $configdir/astrocade/ -cart %ROM%"
    #addEmulator 1 "$md_id-bbcmicro" "bbcmicro" "$md_inst/mamearcade64 bbcb -cfg_directory $configdir/bbcmicro/ -floppy %ROM%"
   # addEmulator 1 "$md_id-channelf" "channelf" "$md_inst/mamearcade64 channelf -cfg_directory $configdir/channelf/ -cart %ROM%"
   # addEmulator 1 "$md_id-electron" "electron" "$md_inst/mamearcade64 electron -cfg_directory $configdir/electron/ -cass %ROM%"
    #addEmulator 1 "$md_id-supervision" "supervision" "$md_inst/mamearcade64 svision -cfg_directory $configdir/supervision/ -cart %ROM%"
    addSystem "arcade"
    addSystem "$system"
    #addSystem "arcadia"
   # addSystem "astrocade"
    #addSystem "bbcmicro"
    #addSystem "channelf"
    #addSystem "electron"
    #addSystem "supervision"

}