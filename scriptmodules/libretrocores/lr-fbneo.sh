#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-fbneo"
rp_module_desc="Arcade emu - FinalBurn Neo v0.2.97.44 (WIP) port for libretro"
rp_module_help="Previously called lr-fba-next and fbalpha\n\ROM Extension: .zip\n\nCopy your FBA roms to\n$romdir/fba or\n$romdir/neogeo or\n$romdir/arcade\n\nFor NeoGeo games the neogeo.zip BIOS is required and must be placed in the same directory as your FBA roms."
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/FBNeo/master/src/license.txt"
rp_module_section="main armv6=opt"

function _update_hook_lr-fbneo() {
    # move from old location and update emulators.cfg
    renameModule "lr-fba-next" "lr-fbalpha"
    renameModule "lr-fbalpha" "lr-fbneo"
}

function sources_lr-fbneo() {
    gitPullOrClone "$md_build" https://github.com/libretro/FBNeo.git
}

function build_lr-fbneo() {
    cd src/burner/libretro
    local params=()
    isPlatform "arm" && params+=(USE_CYCLONE=1)
    isPlatform "neon" && params+=(HAVE_NEON=1)
    isPlatform "x86" && isPlatform "64bit" && params+=(USE_X64_DRC=1)
    make clean
    make "${params[@]}"
    md_ret_require="$md_build/src/burner/libretro/fbneo_libretro.so"
}

function install_lr-fbneo() {
    md_ret_files=(
        'fba.chm'
        'src/burner/libretro/fbneo_libretro.so'
        'gamelist.txt'
        'whatsnew.html'
        'preset-example.zip'
        'metadata'
        'dats'
    )
}

function configure_lr-fbneo() {
    local dir
    for dir in arcade fba neogeo; do
        mkRomDir "$dir"
        ensureSystemretroconfig "$dir"
    done

    # Create samples directory
    mkUserDir "$biosdir/fbneo"
    mkUserDir "$biosdir/fbneo/samples"

    # copy hiscore.dat
    cp "$md_inst/metadata/hiscore.dat" "$biosdir/fbneo/"
    chown $user:$user "$biosdir/fbneo/hiscore.dat"

    local system
    local def
    for system in arcade neogeo fba ; do
        def=0
        [[ "$system" == "neogeo"  || "$system" == "fba" ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id" "$system" "$md_inst/fbneo_libretro.so"
        addSystem "$system"
        cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp
        local core_config="$system"
        setRetroArchCoreOption "input_overlay"  "$raconfigdir/overlay/MAME-Horizontal.cfg"
        setRetroArchCoreOption "input_overlay_opacity" "1.0"
        setRetroArchCoreOption "fbneo-diagnostic-input" "Hold Start"

    done

    for system in arcade neogeo fba neocdz ; do
        def=0
        [[ "$system" == "neocdz" ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id-neocd" "$system" "$md_inst/fbneo_libretro.so --subsystem neocd"
        addSystem "$system"
    done

    for system in megadrive genesis megadrive-japan ; do
        def=0
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id-md" "$system" "$md_inst/fbneo_libretro.so --subsystem md"
        addSystem "$system"
    done

    for system in pcengine supergrafx tg16 ; do
        def=0
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id-pce" "$system" "$md_inst/fbneo_libretro.so --subsystem pce"
        addSystem "$system"
    done

    for system in pcengine supergrafx tg16 ; do
        def=0
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id-sgx" "$system" "$md_inst/fbneo_libretro.so --subsystem sgx"
        addSystem "$system"
    done


    for system in pcengine supergrafx tg16 ; do
        def=0
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id-tg" "$system" "$md_inst/fbneo_libretro.so --subsystem tg"
        addSystem "$system"
    done

    for system in gamegear mastersystem sg-1000 coleco msx zxspectrum ; do
        def=0
        [[ "$system" == "gamegear" || "$system" == "mastersystem"  || "$system" == "sg-1000"  || "$system" == "coleco"  || "$system" == "msx"  || "$system" == "zxspectrum" ]] && def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addSystem "$system"
    done

    addEmulator 0 "$md_id-gg" "gamegear" "$md_inst/fbneo_libretro.so --subsystem gg"
    addEmulator 0 "$md_id-sms" "mastersystem" "$md_inst/fbneo_libretro.so --subsystem sms"
    addEmulator 0 "$md_id-sg1k" "sg-1000" "$md_inst/fbneo_libretro.so --subsystem sg1k"
    addEmulator 0 "$md_id-cv" "coleco" "$md_inst/fbneo_libretro.so --subsystem cv"
    addEmulator 0 "$md_id-msx" "msx" "$md_inst/fbneo_libretro.so --subsystem msx"
    addEmulator 0 "$md_id-spec" "zxspectrum" "$md_inst/fbneo_libretro.so --subsystem spec"
    addEmulator 0 "$md_id-spec" "zxspectrum+3" "$md_inst/fbneo_libretro.so --subsystem spec"

    
    addEmulator 0 "$md_id-fds" "fds" "$md_inst/fbneo_libretro.so --subsystem fds"
    addEmulator 0 "$md_id-nes" "nes" "$md_inst/fbneo_libretro.so --subsystem nes"

    addSystem "arcade"
    addSystem "neogeo"
    addSystem "fba"

    addSystem "pcengine"
    addSystem "gamegear"
    addSystem "mastersystem"
    addSystem "megadrive"
    addSystem "megadrive-japan"
    addSystem "sg-1000"
    addSystem "coleco"
    addSystem "msx"
    addSystem "zxspectrum"
    
    addBezel "fba"

if [ -e $md_instcore/fbneo_libretro.so ] ;
    then
        for system in arcade neogeo fba ; do
            def=0
            mkRomDir "$system"
            ensureSystemretroconfig "$system"
            addEmulator def "$md_id-core" "$system" "$md_instcore/fbneo_libretro.so"
            addSystem "$system"
        done

        for system in arcade neogeo fba neocdz ; do
            def=0
            mkRomDir "$system"
            ensureSystemretroconfig "$system"
            addEmulator def "$md_id-neocd-core" "$system" "$md_instcore/fbneo_libretro.so --subsystem neocd"
            addSystem "$system"
        done

        for system in megadrive genesis megadrive-japan ; do
            def=0
            mkRomDir "$system"
            ensureSystemretroconfig "$system"
            addEmulator def "$md_id-md-core" "$system" "$md_instcore/fbneo_libretro.so --subsystem md"
            addSystem "$system"
        done

        for system in pcengine supergrafx tg16 ; do
            def=0
            mkRomDir "$system"
            ensureSystemretroconfig "$system"
            addEmulator def "$md_id-pce-core" "$system" "$md_instcore/fbneo_libretro.so --subsystem pce"
            addSystem "$system"
        done

        for system in pcengine supergrafx tg16 ; do
            def=0
            mkRomDir "$system"
            ensureSystemretroconfig "$system"
            addEmulator def "$md_id-sgx-core" "$system" "$md_instcore/fbneo_libretro.so --subsystem sgx"
            addSystem "$system"
        done


        for system in pcengine supergrafx tg16 ; do
            def=0
            mkRomDir "$system"
            ensureSystemretroconfig "$system"
            addEmulator def "$md_id-tg-core" "$system" "$md_instcore/fbneo_libretro.so --subsystem tg"
            addSystem "$system"
        done

        addEmulator 0 "$md_id-gg-core" "gamegear" "$md_instcore/fbneo_libretro.so --subsystem gg"
        addEmulator 0 "$md_id-sms-core" "mastersystem" "$md_instcore/fbneo_libretro.so --subsystem sms"
        addEmulator 0 "$md_id-sg1k-core" "sg-1000" "$md_instcore/fbneo_libretro.so --subsystem sg1k"
        addEmulator 0 "$md_id-cv-core" "coleco" "$md_instcore/fbneo_libretro.so --subsystem cv"
        addEmulator 0 "$md_id-msx-core" "msx" "$md_instcore/fbneo_libretro.so --subsystem msx"
        addEmulator 0 "$md_id-spec-core" "zxspectrum" "$md_instcore/fbneo_libretro.so --subsystem spec"

fi





}
