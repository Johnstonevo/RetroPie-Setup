#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mupen64plus"
rp_module_desc="N64 emu - Mupen64Plus + GLideN64 for libretro"
rp_module_help="ROM Extensions: .z64 .n64 .v64\n\nCopy your N64 roms to $romdir/n64"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mupen64plus-libretro/master/LICENSE"
rp_module_section="main"
rp_module_flags="!aarch64"

function _update_hook_lr-mupen64plus() {
    # retroarch renamed lr-mupen64plus to lr-parallel-n64 and
    # lr-glupen64 to lr-mupen64plus which makes this a little tricky as an update hook

    # we first need to rename lr-mupen64plus to lr-parallel-n64
    # (if it's not the lr-glupen64 fork)
    if [[ -d "$md_inst" ]] && ! grep -q "GLideN64" "$md_inst/README.md"; then
        renameModule "lr-mupen64plus" "lr-parallel-n64"
    fi
    # then we can rename lr-glupen64 to lr-mupen64plus
    renameModule "lr-glupen64" "lr-mupen64plus"
}

function depends_lr-mupen64plus() {
    local depends=(flex bison libpng-dev)
    isPlatform "x11" && depends+=(libglew-dev libglu1-mesa-dev)
    isPlatform "x86" && depends+=(nasm)
    isPlatform "mesa" && depends+=(libgles2-mesa-dev)
    isPlatform "videocore" && depends+=(libraspberrypi-dev)
    getDepends "${depends[@]}"
}

function sources_lr-mupen64plus() {
    gitPullOrClone "$md_build" https://github.com/libretro/mupen64plus-libretro.git

    # mesa workaround; see: https://github.com/libretro/libretro-common/issues/98
    if hasPackage libgles2-mesa-dev 18.2 ge; then
        applyPatch "$md_data/0001-eliminate-conflicting-typedefs.patch"
    fi
}

function build_lr-mupen64plus() {
    rpSwap on 750
    local params=()
    if isPlatform "videocore"; then
        params+=(platform="$__platform")
    elif isPlatform "mesa"; then
        params+=(platform="$__platform-mesa")
    elif isPlatform "mali"; then
        params+=(platform="odroid")
    else
        isPlatform "arm" && params+=(WITH_DYNAREC=arm)
        isPlatform "neon" && params+=(HAVE_NEON=1)
        isPlatform "gles" && params+=(FORCE_GLES=1)
        isPlatform "kms" && params+=(FORCE_GLES3=1)
    fi
    make clean
    make "${params[@]}"
    rpSwap off
    md_ret_require="$md_build/mupen64plus_libretro.so"
}

function install_lr-mupen64plus() {
    md_ret_files=(
        'mupen64plus_libretro.so'
        'LICENSE'
        'README.md'
        'BUILDING.md'
    )
}

function configure_lr-mupen64plus() {

    local system
    local def
    for system in n64 n64-japan n64dd ; do
        def=1
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id" "$system" "$md_inst/mupen64plus_libretro.so"
        addSystem "$system"

        cp /home/$user/.config/RetroPie/$system/retroarch.cfg /home/$user/.config/RetroPie/$system/retroarch.cfg.bkp
        local core_config="$system"
        setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-64.cfg" "$core_config"
        setRetroArchCoreOption "input_overlay_opacity" "1.0"
        setRetroArchCoreOption "input_overlay_scale" "1.0"
        setRetroArchCoreOption "input_overlay_enable" "true"
        setRetroArchCoreOption "video_aspect_ratio" "1.0"
        setRetroArchCoreOption "video_smooth" "true"

    done

  if [ -e $md_instcore/mupen64plus_libretro.so ]
  then
    local system
    local def
    for system in n64 n64-japan n64dd ; do
        def=0
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id-core" "$system" "$md_instcore/mupen64plus_libretro.so"
        addSystem "$system"
    done
fi

addBezel "n64"


}
