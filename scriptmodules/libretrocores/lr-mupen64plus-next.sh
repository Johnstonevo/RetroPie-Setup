#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mupen64plus-next"
rp_module_desc="N64 emulator - Mupen64Plus + GLideN64 for libretro (next version)"
rp_module_help="ROM Extensions: .z64 .n64 .v64\n\nCopy your N64 roms to $romdir/n64"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mupen64plus-libretro-nx/master/LICENSE"
rp_module_section="exp"
rp_module_flags="!armv6"

function depends_lr-mupen64plus-next() {
    local depends=(flex bison libpng-dev)
    isPlatform "x11" && depends+=(libglew-dev libglu1-mesa-dev)
    isPlatform "x86" && depends+=(nasm)
    isPlatform "videocore" && depends+=(libraspberrypi-dev)
    isPlatform "mesa" && depends+=(libgles2-mesa-dev)
    getDepends "${depends[@]}"
}

function sources_lr-mupen64plus-next() {
    gitPullOrClone "$md_build" https://github.com/libretro/mupen64plus-libretro-nx.git develop
}

function build_lr-mupen64plus-next() {
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
    # use a custom core name to avoid core option name clashes with lr-mupen64plus
    params+=(CORE_NAME=mupen64plus-next)
    make "${params[@]}" clean
    make "${params[@]}"
    md_ret_require="$md_build/mupen64plus_next_libretro.so"
}

function install_lr-mupen64plus-next() {
    md_ret_files=(
        'mupen64plus_next_libretro.so'
        'LICENSE'
        'README.md'
    )
}

function configure_lr-mupen64plus-next() {
    
    local system
    local def
    for system in n64 n64-japan n64dd ; do
        def=0
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator def "$md_id" "$system" "$md_inst/mupen64plus_next_libretro.so"
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
    
    addBezel "n64"
}
