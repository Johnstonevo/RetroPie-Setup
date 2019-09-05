#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mame2003-plus"
rp_module_desc="Arcade emu - updated MAME 0.78 port for libretro with added game support"
rp_module_help="ROM Extension: .zip\n\nCopy your MAME roms to either $romdir/mame-libretro or\n$romdir/arcade"
rp_module_licence="NONCOM https://raw.githubusercontent.com/libretro/mame2003-plus-libretro/master/LICENSE.md"
rp_module_section="main"

function _get_dir_name_lr-mame2003-plus() {
    echo "mame-2003-plus"
}

function _get_so_name_lr-mame2003-plus() {
    echo "mame2003_plus"
}

function sources_lr-mame2003-plus() {
    gitPullOrClone "$md_build" https://github.com/libretro/mame2003-plus-libretro.git
}

function build_lr-mame2003-plus() {
    build_lr-mame2003
}

function install_lr-mame2003-plus() {
    install_lr-mame2003
}

function configure_lr-mame2003-plus() {
  local dir_name="$(_get_dir_name_${md_id})"
  local core_config=mame-2003-plus
  local mame_dir
  local mame_sub_dir
  #for mame_dir in mame-2003-plus ; do
      mkRomDir "mame-2003-plus"
      mkRomDir "$mame_dir/$dir_name"
      ensureSystemretroconfig "mame-2003-plus"

      for mame_sub_dir in cfg ctrlr diff hi memcard nvram; do
          mkRomDir "$mame_dir/$dir_name/$mame_sub_dir"
      done

      # lr-mame2003-plus also has an artwork folder
      [[ "$md_id" == "lr-mame2003-plus" ]] && mkRomDir "$mame_dir/$dir_name/artwork"


  mkUserDir "$biosdir/$dir_name"
  mkUserDir "$biosdir/$dir_name/samples"

  # copy hiscore.dat
  cp "$md_inst/metadata/"{hiscore.dat,cheat.dat} "$biosdir/$dir_name/"
  chown $user:$user "$biosdir/$dir_name/"{hiscore.dat,cheat.dat}

  # Set core options


  local so_name="$(_get_so_name_${md_id})"
  addEmulator 1 "$md_id" "mame-2003-plus" "$md_inst/${so_name}_libretro.so"
  addSystem "arcade"
  addSystem "mame-2003-plus"
  addBezel "mame-2003-plus"
  
  ln -s "$raconfigdir/config/MAME 2003" "$raconfigdir/config/MAME 2003-Plus"
  
  setRetroArchCoreOption "mame2003-plus_skip_disclaimer" "enabled"
  setRetroArchCoreOption "mame2003-plus_dcs-speedhack" "enabled"
  setRetroArchCoreOption "mame2003-plus_samples" "enabled"
  setRetroArchCoreOption "input_overlay"  "$raconfigdir/overlay/MAME-Horizontal.cfg"
  setRetroArchCoreOption "input_overlay_opacity" "1.0"
  setRetroArchCoreOption "input_overlay_enable" "true"
  setRetroArchCoreOption  "mame2003-plus_core_save_subfolder" "enabled"
  setRetroArchCoreOption  "mame2003-plus_core_sys_subfolder" "enabled"
  setRetroArchCoreOption  "mame2003-plus_dcs_speedhack" "enabled"
  setRetroArchCoreOption  "mame2003-plus_display_artwork" "enabled"
  setRetroArchCoreOption  "mame2003-plus_display_setup" "disabled"
  setRetroArchCoreOption  "mame2003-plus_dual_joysticks" "disabled"
  setRetroArchCoreOption  "mame2003-plus_frameskip" "0"
  setRetroArchCoreOption  "mame2003-plus_gamma" "1.2"
  setRetroArchCoreOption  "mame2003-plus_input_interface" "retroarch"
  setRetroArchCoreOption  "mame2003-plus_machine_timing" "enabled"
  setRetroArchCoreOption  "mame2003-plus_mame_remapping" "disabled"
  setRetroArchCoreOption  "mame2003-plus_mouse_device" "mouse"
  setRetroArchCoreOption  "mame2003-plus_rstick_to_btns" "enabled"
  setRetroArchCoreOption  "mame2003-plus_sample_rate" "48000"
  setRetroArchCoreOption  "mame2003-plus_skip_disclaimer" "enabled"
  setRetroArchCoreOption  "mame2003-plus_skip_warnings" "enabled"
  setRetroArchCoreOption  "mame2003-plus_tate_mode" "disabled"
  setRetroArchCoreOption  "mame2003-plus-dcs-speedhack" "enabled"
  setRetroArchCoreOption "mame2003-plus-samples" "enabled"





}
