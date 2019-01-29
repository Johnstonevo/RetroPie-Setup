#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mame"
rp_module_desc="MAME emulator - MAME (current) port for libretro"
rp_module_help="ROM Extension: .zip\n\nCopy your MAME roms to either $romdir/mame-libretro or\n$romdir/arcade"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame/master/LICENSE.md"
rp_module_section="main"

function _get_params_lr-mame() {
    local params=(OSD=retro RETRO=1 NOWERROR=1 OS=linux TARGETOS=linux CONFIG=libretro NO_USE_MIDI=1 TARGET=mame)
    isPlatform "64bit" && params+=(PTR64=1)
    echo "${params[@]}"
}

function depends_lr-mame() {
    if compareVersions $__gcc_version lt 5.0.0; then
        md_ret_errors+=("Sorry, you need an OS with gcc 5.0 or newer to compile lr-mame")
        return 1
    fi
}

function sources_lr-mame() {
    gitPullOrClone "$md_build" https://github.com/libretro/mame.git
}

function build_lr-mame() {
    rpSwap on 2000
    local params=($(_get_params_lr-mame) SUBTARGET=arcade)
    make clean
    make "${params[@]}"
    rpSwap off
    md_ret_require="$md_build/mamearcade_libretro.so"
}

function install_lr-mame() {
    md_ret_files=(
        'mamearcade_libretro.so'
    )
}

function configure_lr-mame() {
    local system
    for system in arcade mame-current; do
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 0 "$md_id" "$system" "$md_inst/mamearcade_libretro.so"
        addSystem "$system"
    done

  if [ -e /usr/lib/libretro/mame_libretro.so ]
  then
      addEmulator 0 "$md_id-ppa" "arcade" "$md_instppa/mame_libretro.so"
  addEmulator 0 "$md_id-ppa" "mame-current" "$md_instppa/mame_libretro.so"
  fi
if [ !  -d $raconfigdir/overlay/ArcadeBezels ]
then
  git clone  https://github.com/thebezelproject/bezelproject-MAME.git  "/home/$user/RetroPie-Setup/tmp/MAME"
  cp -r  /home/$user/RetroPie-Setup/tmp/MAME/retroarch/  /home/$user/.config/
  rm -rf /home/$user/RetroPie-Setup/tmp/MAME/
  cd /home/$user/.config/retroarch/
  chown -R $user:$user ../retroarch
  find  -type f -exec sed -i 's/\/opt\/retropie\/configs\/all\/retroarch\/overlay/~\/.config\/retroarch\/overlay/' {} \;
  ln -s "$raconfigdir/config/MAME 2010" "$raconfigdir/config/MAME"

fi
  if [  -d $raconfigdir/overlay/ArcadeBezels ]
   then
      cp /home/$user/.config/RetroPie/mame-current/retroarch.cfg /home/$user/.config/RetroPie/mame-current/retroarch.cfg.bkp
      local core_config="$configdir/mame-current/retroarch.cfg"
       iniConfig " = " '"' "$md_conf_root/mame-current/retroarch.cfg"

      iniSet "input_overlay"  "/home/$user/.config/retroarch/overlay/MAME-Horizontal.cfg"
      iniSet "input_overlay_opacity" "1.0"
      iniSet "input_overlay_enable" "true"
      iniSet "mame-skip_disclaimer" "enabled"
      iniSet "mame-dcs-speedhack" "enabled"
      iniSet "mame-samples" "enabled"
  fi

}
