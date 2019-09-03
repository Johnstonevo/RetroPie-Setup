#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-gpsp"
rp_module_desc="GBA emu - gpSP port for libretro"
rp_module_help="ROM Extensions: .gba .zip\n\nCopy your Game Boy Advance roms to $romdir/gba\n\nCopy the required BIOS file gba_bios.bin to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/gpsp/master/COPYING"
rp_module_section="main"
rp_module_flags="!x86"

function sources_lr-gpsp() {
    gitPullOrClone "$md_build" https://github.com/libretro/gpsp.git
}

function build_lr-gpsp() {
    make clean
    rpSwap on 512
    local params=()
    isPlatform "arm" && params+=(platform=armv)
    make "${params[@]}"
    rpSwap off
    md_ret_require="$md_build/gpsp_libretro.so"
}

function install_lr-gpsp() {
    md_ret_files=(
        'gpsp_libretro.so'
        'COPYING'
        'readme.txt'
        'game_config.txt'
    )
}

function configure_lr-gpsp() {
  mkRomDir "gba"
  ensureSystemretroconfig "gba"
  mkRomDir "gbah"
  ensureSystemretroconfig "gbah"

    local def=0
    isPlatform "armv6" && def=1
    addEmulator $def "$md_id" "gba" "$md_inst/gpsp_libretro.so"
    addEmulator $def "$md_id" "gbah" "$md_inst/gpsp_libretro.so"
    addSystem "gba"
    addSystem "gbah"

    if [ -e $md_instppa/gpsp_libretro.so ]
        then
          mkRomDir "gba"
          ensureSystemretroconfig "gba"
          mkRomDir "gbah"
          ensureSystemretroconfig "gbah"
          addEmulator 0 "$md_id-ppa" "gba" "$md_instppa/gpsp_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbah" "$md_instppa/gpsp_libretro.so"
          addSystem "gba"
          addSystem "gbah"
      fi

##ConfigureRetroarch##
#####################

      cp /home/$user/.config/RetroPie/gba/retroarch.cfg /home/$user/.config/RetroPie/gba/retroarch.cfg.bkp
      local core_config="gba"
      sertRetroArchcoreOption  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyAdvance_1080p.cfg"
      sertRetroArchcoreOption  "input_overlay_enable" "true"
      sertRetroArchcoreOption  "video_fullscreen_x" "1920"
      sertRetroArchcoreOption  "video_fullscreen_y" "1080"
      sertRetroArchcoreOption  "input_overlay_opacity" "1.0"
      sertRetroArchcoreOption  "input_overlay_scale" "1.0"
      sertRetroArchcoreOption  "custom_viewport_width"  "960"
      sertRetroArchcoreOption  "custom_viewport_height" "640"
      sertRetroArchcoreOption  "custom_viewport_x" "480"
      sertRetroArchcoreOption  "custom_viewport_y" "220"
      sertRetroArchcoreOption  "aspect_ratio_index" "23"
      sertRetroArchcoreOption  "video_shader"  "$raconfigdir/shaders/rpi/retropie/shaders/crt-hyllian-sharpness-hack.glsl"
      sertRetroArchcoreOption  "video_shader_enable"  "true"
      sertRetroArchcoreOption  "video_smooth" "false"


      cp /home/$user/.config/RetroPie/gbah/retroarch.cfg /home/$user/.config/RetroPie/gbah/retroarch.cfg.bkp
      local core_config="$configdir/gbah/retroarch.cfg"
      sertRetroArchcoreOption  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyAdvance_1080p.cfg"
      sertRetroArchcoreOption  "input_overlay_enable" "true"
      sertRetroArchcoreOption  "video_fullscreen_x" "1920"
      sertRetroArchcoreOption  "video_fullscreen_y" "1080"
      sertRetroArchcoreOption  "input_overlay_opacity" "1.0"
      sertRetroArchcoreOption  "input_overlay_scale" "1.0"
      sertRetroArchcoreOption  "custom_viewport_width"  "960"
      sertRetroArchcoreOption  "custom_viewport_height" "640"
      sertRetroArchcoreOption  "custom_viewport_x" "480"
      sertRetroArchcoreOption  "custom_viewport_y" "220"
      sertRetroArchcoreOption  "aspect_ratio_index" "23"
      sertRetroArchcoreOption  "video_shader"  "$raconfigdir/shaders/rpi/retropie/shaders/crt-hyllian-sharpness-hack.glsl"
      sertRetroArchcoreOption  "video_shader_enable"  "true"
      sertRetroArchcoreOption  "video_smooth" "false"


}
