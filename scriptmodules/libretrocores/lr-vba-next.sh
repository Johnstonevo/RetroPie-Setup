#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-vba-next"
rp_module_desc="GBA emulator - VBA-M (optimised) port for libretro"
rp_module_help="ROM Extensions: .gba .zip\n\nCopy your Game Boy Advance roms to $romdir/gba\n\nCopy the required BIOS file gba_bios.bin to $biosdir"
rp_module_licence="GPL2"
rp_module_section="main"
rp_module_flags="!armv6"

function sources_lr-vba-next() {
    gitPullOrClone "$md_build" https://github.com/libretro/vba-next.git
}

function build_lr-vba-next() {
    make -f Makefile.libretro clean
    if isPlatform "neon"; then
        make -f Makefile.libretro platform=armvhardfloatunix TILED_RENDERING=1 HAVE_NEON=1
    else
        make -f Makefile.libretro
    fi
    md_ret_require="$md_build/vba_next_libretro.so"
}

function install_lr-vba-next() {
    md_ret_files=(
        'vba_next_libretro.so'
    )
}

function configure_lr-vba-next() {
  mkRomDir "gba"
  ensureSystemretroconfig "gba"
  mkRomDir "gbah"
  ensureSystemretroconfig "gbah"

  addEmulator 0 "$md_id" "gba" "$md_inst/vba_next_libretro.so"
  addEmulator 0 "$md_id" "gbah" "$md_inst/vba_next_libretro.so"
  addSystem "gba"
  addSystem "gbah"

    if [ -e $md_instppa/vba_next_libretro.so ]
        then


          mkRomDir "gba"
          ensureSystemretroconfig "gba"
          mkRomDir "gbah"
          ensureSystemretroconfig "gbah"

          addEmulator 0 "$md_id-ppa" "gba" "$md_instppa/vba_next_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbah" "$md_instppa/vba_next_libretro.so"
          addSystem "gba"
          addSystem "gbah"
    fi

##configure retroarch##
########################

    cp /home/$user/.config/RetroPie/gba/retroarch.cfg /home/$user/.config/RetroPie/gba/retroarch.cfg.bkp
    local core_config="gba"
    setRetroArchCoreOption "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyAdvance_1080p.cfg"
    setRetroArchCoreOption "input_overlay_enable" "true"
    setRetroArchCoreOption "video_fullscreen_x" "1920"
    setRetroArchCoreOption "video_fullscreen_y" "1080"
    setRetroArchCoreOption "input_overlay_opacity" "1.0"
    setRetroArchCoreOption "input_overlay_scale" "1.0"
    setRetroArchCoreOption "custom_viewport_width"  "960"
    setRetroArchCoreOption "custom_viewport_height" "640"
    setRetroArchCoreOption "custom_viewport_x" "480"
    setRetroArchCoreOption "custom_viewport_y" "220"
    setRetroArchCoreOption "aspect_ratio_index" "23"
    setRetroArchCoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/shaders/crt-hyllian-sharpness-hack.glsl"
    setRetroArchCoreOption "video_shader_enable"  "true"
    setRetroArchCoreOption "video_smooth" "false"



    cp /home/$user/.config/RetroPie/gbah/retroarch.cfg /home/$user/.config/RetroPie/gbah/retroarch.cfg.bkp
    local core_config="gbah"
    setRetroArchCoreOption "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyAdvance_1080p.cfg"
    setRetroArchCoreOption "input_overlay_enable" "true"
    setRetroArchCoreOption "video_fullscreen_x" "1920"
    setRetroArchCoreOption "video_fullscreen_y" "1080"
    setRetroArchCoreOption "input_overlay_opacity" "1.0"
    setRetroArchCoreOption "input_overlay_scale" "1.0"
    setRetroArchCoreOption "custom_viewport_width"  "960"
    setRetroArchCoreOption "custom_viewport_height" "640"
    setRetroArchCoreOption "custom_viewport_x" "480"
    setRetroArchCoreOption "custom_viewport_y" "220"
    setRetroArchCoreOption "aspect_ratio_index" "23"
    setRetroArchCoreOption "video_shader"  "$raconfigdir/shaders/rpi/retropie/shaders/crt-hyllian-sharpness-hack.glsl"
    setRetroArchCoreOption "video_shader_enable"  "true"
    setRetroArchCoreOption "video_smooth" "false"


}
