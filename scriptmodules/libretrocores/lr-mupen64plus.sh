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
  mkRomDir "n64"
  mkRomDir "n64-japan"
  mkRomDir "n64dd"
  ensureSystemretroconfig "n64"
  ensureSystemretroconfig "n64-japan"
  ensureSystemretroconfig "n64dd"

  addEmulator 1 "$md_id" "n64" "$md_inst/mupen64plus_libretro.so"
  addEmulator 1 "$md_id" "n64-japan" "$md_inst/mupen64plus_libretro.so"
  addEmulator 1 "$md_id" "n64dd" "$md_inst/mupen64plus_libretro.so"
  addSystem "n64"
  addSystem "n64-japan"
  addSystem "n64dd"
  if [ -e $md_instppa/mupen64plus_libretro.so ]
  then
    ensureSystemretroconfig "n64"
    ensureSystemretroconfig "n64-japan"
    ensureSystemretroconfig "n64dd"

    addEmulator 0 "$md_id-ppa" "n64" "$md_instppa/mupen64plus_libretro.so"
    addEmulator 0 "$md_id-ppa" "n64-japan" "$md_instppa/mupen64plus_libretro.so"
    addEmulator 0 "$md_id-ppa" "n64dd" "$md_instppa/mupen64plus_libretro.so"
    addSystem "n64"
    addSystem "n64-japan"
    addSystem "n64dd"
fi
if [ ! -d $raconfigdir/overlay/GameBezels/N64 ]
then
    git clone https://github.com/thebezelproject/bezelproject-N64.git  "/home/$user/RetroPie-Setup/tmp/N64"
    cp -r  /home/$user/RetroPie-Setup/tmp/N64/retroarch/  /home/$user/.config/
    rm -rf /home/$user/RetroPie-Setup/tmp/N64/
    cd /home/$user/.config/retroarch/
    chown -R $user:$user ../retroarch
    find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
    ln -s "$raconfigdir/config/Mupen64Plus GLES2" "$raconfigdir/config/Mupen64Plus OpenGL"
fi

        cp /home/$user/.config/RetroPie/n64/retroarch.cfg /home/$user/.config/RetroPie/n64/retroarch.cfg.bkp
    local core_config="n64"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Entertainment-System.cfg" "$core_config"
    setRetroArchCoreOption "input_overlay_opacity" "1.0"
    setRetroArchCoreOption "input_overlay_scale" "1.0"
    setRetroArchCoreOption "input_overlay_enable" "true"
    setRetroArchCoreOption "video_aspect_ratio" "1.0"
    setRetroArchCoreOption "video_smooth" "true"

    cp /home/$user/.config/RetroPie/n64dd/retroarch.cfg /home/$user/.config/RetroPie/n64dd/retroarch.cfg.bkp
    local core_config="n64dd"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Entertainment-System.cfg" "$core_config"
    setRetroArchCoreOption "input_overlay_opacity" "1.0"
    setRetroArchCoreOption "input_overlay_scale" "1.0"
    setRetroArchCoreOption "input_overlay_enable" "true"
    setRetroArchCoreOption "video_aspect_ratio" "1.0"
    setRetroArchCoreOption "video_smooth" "true"


    cp /home/$user/.config/RetroPie/n64-japan/retroarch.cfg /home/$user/.config/RetroPie/n64-japan/retroarch.cfg.bkp
    local core_config="n64-japan"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlay/Nintendo-Entertainment-System.cfg" "$core_config"
    setRetroArchCoreOption "input_overlay_opacity" "1.0"
    setRetroArchCoreOption "input_overlay_scale" "1.0"
    setRetroArchCoreOption "input_overlay_enable" "true"
    setRetroArchCoreOption "video_aspect_ratio" "1.0"
    setRetroArchCoreOption "video_smooth" "true"




}
