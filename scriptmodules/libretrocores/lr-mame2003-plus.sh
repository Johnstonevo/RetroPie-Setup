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
    echo "mame2003-plus"
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

  local mame_dir
  local mame_sub_dir
  for mame_dir in mame-2003-plus ; do
      mkRomDir "$mame_dir"
      mkRomDir "$mame_dir/$dir_name"
      ensureSystemretroconfig "$mame_dir"

      for mame_sub_dir in cfg ctrlr diff hi memcard nvram; do
          mkRomDir "$mame_dir/$dir_name/$mame_sub_dir"
      done

      # lr-mame2003-plus also has an artwork folder
      [[ "$md_id" == "lr-mame2003-plus" ]] && mkRomDir "$mame_dir/$dir_name/artwork"
  done

  mkUserDir "$biosdir/$dir_name"
  mkUserDir "$biosdir/$dir_name/samples"

  # copy hiscore.dat
  cp "$md_inst/metadata/"{hiscore.dat,cheat.dat} "$biosdir/$dir_name/"
  chown $user:$user "$biosdir/$dir_name/"{hiscore.dat,cheat.dat}

  # Set core options
  setRetroArchCoreOption "${dir_name}-skip_disclaimer" "enabled"
  setRetroArchCoreOption "${dir_name}-dcs-speedhack" "enabled"
  setRetroArchCoreOption "${dir_name}-samples" "enabled"

  local so_name="$(_get_so_name_${md_id})"
  addEmulator 1 "$md_id" "mame-2003-plus" "$md_inst/${so_name}_libretro.so"
  addSystem "arcade"
  addSystem "mame-2003-plus"
    if [ ! -d $raconfigdir/overlay/ArcadeBezels ]
    then
      git clone  https://github.com/thebezelproject/bezelproject-MAME.git  "/home/$user/RetroPie-Setup/tmp/MAME"
      cp -r  /home/$user/RetroPie-Setup/tmp/MAME/retroarch/  /home/$user/.config/
      rm -rf /home/$user/RetroPie-Setup/tmp/MAME/
      cd /home/$user/.config/retroarch/
      chown -R $user:$user ../retroarch
      find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
      ln -s "$raconfigdir/config/MAME 2003" "$raconfigdir/config/MAME 2003-Plus"

    fi
    if [  -d $raconfigdir/overlay/ArcadeBezels ]
     then
        cp /home/$user/.config/RetroPie/mame-2003-plus/retroarch.cfg /home/$user/.config/RetroPie/mame-2003-plus/retroarch.cfg.bkp
        local core_config="$configdir/mame-2003/retroarch.cfg"
         iniConfig " = " '"' "$md_conf_root/mame-2003-plus/retroarch.cfg"

        iniSet "input_overlay"  "/home/$user/.config/retroarch/overlay/MAME-Horizontal.cfg"
        iniSet "input_overlay_opacity" "1.0"
        iniSet "input_overlay_enable" "true"
        iniSet  "mame2003-plus_cheat_input ports" "disabled"
        iniSet  "mame2003-plus_core_save_subfolder" "enabled"
        iniSet  "mame2003-plus_core_sys_subfolder" "enabled"
        iniSet  "mame2003-plus_dcs_speedhack" "enabled"
        iniSet  "mame2003-plus_display_artwork" "enabled"
        iniSet  "mame2003-plus_display_setup" "disabled"
        iniSet  "mame2003-plus_dual_joysticks" "disabled"
        iniSet  "mame2003-plus_frameskip" "0"
        iniSet  "mame2003-plus_gamma" "1.2"
        iniSet  "mame2003-plus_input_interface" "retroarch"
        iniSet  "mame2003-plus_machine_timing" "enabled"
        iniSet  "mame2003-plus_mame_remapping" "disabled"
        iniSet  "mame2003-plus_mouse_device" "mouse"
        iniSet  "mame2003-plus_rstick_to_btns" "enabled"
        iniSet  "mame2003-plus_sample_rate" "48000"
        iniSet  "mame2003-plus_skip_disclaimer" "enabled"
        iniSet  "mame2003-plus_skip_warnings" "enabled"
        iniSet  "mame2003-plus_tate_mode" "disabled"
        iniSet  "mame2003-plus-dcs-speedhack" "enabled"
        iniSet "mame2003-plus-samples" "enabled"
    fi


}
