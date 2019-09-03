#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-gambatte"
rp_module_desc="Gameboy Color emu - libgambatte port for libretro"
rp_module_help="ROM Extensions: .gb .gbc .zip\n\nCopy your GameBoy roms to $romdir/gb\n\nCopy your GameBoy Color roms to $romdir/gbc"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/gambatte-libretro/master/COPYING"
rp_module_section="main"

function sources_lr-gambatte() {
    gitPullOrClone "$md_build" https://github.com/libretro/gambatte-libretro.git
}

function build_lr-gambatte() {
    make -f Makefile.libretro clean
    make -f Makefile.libretro
    md_ret_require="$md_build/gambatte_libretro.so"
}

function install_lr-gambatte() {
    md_ret_files=(
        'COPYING'
        'changelog'
        'README.md'
        'gambatte_libretro.so'
    )
}

function configure_lr-gambatte() {
    # add default green yellow palette for gameboy classic
    mkUserDir "$biosdir/palettes"
    cp "$md_data/default.pal" "$biosdir/palettes/"
    chown $user:$user "$biosdir/palettes/default.pal"


    mkRomDir "gbc"
    mkRomDir "gbch"
    mkRomDir "gb"
    mkRomDir "gbh"
    ensureSystemretroconfig "gb"
    ensureSystemretroconfig "gbh"
    ensureSystemretroconfig "gbc"
    ensureSystemretroconfig "gbch"
    addEmulator 1 "$md_id" "gb" "$md_inst/gambatte_libretro.so"
    addEmulator 1 "$md_id" "gbc" "$md_inst/gambatte_libretro.so"
    addEmulator 1 "$md_id" "gbch" "$md_inst/gambatte_libretro.so"
    addEmulator 1 "$md_id" "gbh" "$md_inst/gambatte_libretro.so"
    addSystem "gb"
    addSystem "gbh"
    addSystem "gbc"
    addSystem "gbch"
    addBezel "gbc"
    addBezel "gb"
    if [ -e $md_instppa/gambatte_libretro.so ]
        then
          ensureSystemretroconfig "gb"
          ensureSystemretroconfig "gbh"
          ensureSystemretroconfig "gbc"
          ensureSystemretroconfig "gbch"
          addEmulator 0 "$md_id-ppa" "gb" "$md_instppa/gambatte_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbc" "$md_instppa/gambatte_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbch" "$md_instppa/gambatte_libretro.so"
          addEmulator 0 "$md_id-ppa" "gbh" "$md_instppa/gambatte_libretro.so"
          addSystem "gb"
          addSystem "gbh"
          addSystem "gbc"
          addSystem "gbch"
    fi

#configure retroarcg cfg
    cp /home/$user/.config/RetroPie/gb/retroarch.cfg /home/$user/.config/RetroPie/gb/retroarch.cfg.bkp
    local core_config="gb"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlays/1080p_4-3/Gameboy_1080p.cfg"
    setRetroArchCoreOption  "input_overlay_enable" "true"
    setRetroArchCoreOption  "input_overlay_opacity" "0.8"
    setRetroArchCoreOption  "input_overlay_scale" "1.0"
    setRetroArchCoreOption  "video_shader"  "$raconfigdir/shaders/rpi/handheld/gameboy/gb-shader.glslp"
    setRetroArchCoreOption  "video_shader_enable"  "true"
    setRetroArchCoreOption  "video_smooth" "false"
    setRetroArchCoreOption  "gambatte_gb_colorization" "disabled"
    setRetroArchCoreOption  "gambatte_gb_internal_palette" "GB - DMG"
    setRetroArchCoreOption  "gambatte_gb_hwmode" "GB" 


    cp /home/$user/.config/RetroPie/gbh/retroarch.cfg /home/$user/.config/RetroPie/gbh/retroarch.cfg.bkp
    local core_config="gbh"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlays/1080p_4-3/Gameboy_1080p.cfg"
    setRetroArchCoreOption  "input_overlay_enable" "true"
    setRetroArchCoreOption  "input_overlay_opacity" "0.8"
    setRetroArchCoreOption  "input_overlay_scale" "1.0"
    setRetroArchCoreOption  "video_shader"  "$raconfigdir/shaders/rpi/handheld/gameboy/gb-shader.glslp"
    setRetroArchCoreOption  "video_shader_enable"  "true"
    setRetroArchCoreOption  "video_smooth" "false"
    setRetroArchCoreOption  "gambatte_gb_colorization" "disabled"
    setRetroArchCoreOption  "gambatte_gb_internal_palette" "GB - DMG"
    setRetroArchCoreOption  "gambatte_gb_hwmode" "GB" 

    cp /home/$user/.config/RetroPie/gbc/retroarch.cfg /home/$user/.config/RetroPie/gbc/retroarch.cfg.bkp
    local core_config="gbc"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyColor_1080p.cfg"
    setRetroArchCoreOption  "input_overlay_enable" "true"
    setRetroArchCoreOption  "input_overlay_opacity" "1.0"
    setRetroArchCoreOption  "input_overlay_scale" "1.0"
    setRetroArchCoreOption  "video_shader"  "$raconfigdir/shaders/rpi/hqx/hq4x.glslp"
    setRetroArchCoreOption  "video_shader_enable"  "true"
    setRetroArchCoreOption  "video_smooth" "false"
    setRetroArchCoreOption  "gambatte_gb_hwmode" "GBC" 

    cp /home/$user/.config/RetroPie/gbch/retroarch.cfg /home/$user/.config/RetroPie/gbh/retroarch.cfg.bkp
    local core_config="gbch"
    setRetroArchCoreOption  "input_overlay" "$raconfigdir/overlays/1080p_4-3/GameboyColor_1080p.cfg"
    setRetroArchCoreOption  "input_overlay_enable" "true"
    setRetroArchCoreOption  "input_overlay_opacity" "1.0"
    setRetroArchCoreOption  "input_overlay_scale" "1.0"
    setRetroArchCoreOption  "video_shader"  "$raconfigdir/shaders/rpi/hqx/hq4x.glslp"
    setRetroArchCoreOption  "video_shader_enable"  "true"
    setRetroArchCoreOption  "video_smooth" "false"
    setRetroArchCoreOption  "gambatte_gb_hwmode" "GBC" 
}
