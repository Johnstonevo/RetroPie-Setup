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
rp_module_licence="GPL3 https://raw.githubusercontent.com/libretro/mupen64plus-libretro/master/LICENSE"
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
    isPlatform "rpi" && depends+=(libraspberrypi-dev)
    getDepends "${depends[@]}"
}

function sources_lr-mupen64plus() {
    gitPullOrClone "$md_build" https://github.com/libretro/mupen64plus-libretro.git
}

function build_lr-mupen64plus() {
    rpSwap on 750
    local params=()
    if isPlatform "rpi"; then
        params+=(platform="$__platform")
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

  addEmulator 0 "$md_id" "n64" "$md_inst/mupen64plus_libretro.so"
  addEmulator 0 "$md_id" "n64-japan" "$md_inst/mupen64plus_libretro.so"
  addEmulator 0 "$md_id" "n64dd" "$md_inst/mupen64plus_libretro.so"
  addSystem "n64"
  addSystem "n64-japan"
  addSystem "n64dd"
  if [ -e /usr/lib/libretro/mupen64plus_libretro.so ]
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
    git clone  https://github.com/thebezelproject/bezelproject-N64.git  "/home/$user/RetroPie-Setup/tmp/N64"
    cp -r  /home/$user/RetroPie-Setup/tmp/N64/retroarch/  /home/$user/.config/
    rm -rf /home/$user/RetroPie-Setup/tmp/N64/
    cd /home/$user/.config/retroarch/
    chown -R $user:$user ../retroarch
    find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
fi
if [  -d $raconfigdir/overlay/GameBezels/N64 ]
 then
             cp /home/$user/.config/RetroPie/n64/retroarch.cfg /home/$user/.config/RetroPie/n64/retroarch.cfg.bkp
            local core_config="$configdir/n64/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/n64/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0"
            iniSet "input_overlay_scale" "1.0"
            iniSet "input_overlay_enable" "true"
            iniSet "video_force_aspect" "true"
            iniSet "video_aspect_ratio" "1.0"
            iniSet "video_smooth" "true"
            chown $user:$user "$core_config"

            cp /home/$user/.config/RetroPie/n64dd/retroarch.cfg /home/$user/.config/RetroPie/n64dd/retroarch.cfg.bkp
            local core_config="$configdir/n64dd/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/n64dd/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0"
            iniSet "input_overlay_scale" "1.0"
            iniSet "input_overlay_enable" "true"
            iniSet "video_force_aspect" "true"
            iniSet "video_aspect_ratio" "1.0"
            iniSet "video_smooth" "true"
            chown $user:$user "$core_config"


            cp /home/$user/.config/RetroPie/n64-japan/retroarch.cfg /home/$user/.config/RetroPie/n64-japan/retroarch.cfg.bkp
            local core_config="$configdir/n64-japan/retroarch.cfg"
            iniConfig " = " '"' "$md_conf_root/n64-japan/retroarch.cfg"
            iniSet  "input_overlay" "/home/$user/.config/retroarch/overlay/Nintendo-Entertainment-System.cfg" "$core_config"
            iniSet "input_overlay_opacity" "1.0"
            iniSet "input_overlay_scale" "1.0"
            iniSet "input_overlay_enable" "true"
            iniSet "video_force_aspect" "true"
            iniSet "video_aspect_ratio" "1.0"
            iniSet "video_smooth" "true"
            chown $user:$user "$core_config"


fi

}
