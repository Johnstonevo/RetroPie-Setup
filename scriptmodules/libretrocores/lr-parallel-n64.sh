#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-parallel-n64"
rp_module_desc="N64 emu - Highly modified Mupen64Plus port for libretro"
rp_module_help="ROM Extensions: .z64 .n64 .v64\n\nCopy your N64 roms to $romdir/n64"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/parallel-n64/master/parallel-n64-core/LICENSES"
rp_module_section="opt"

function depends_lr-parallel-n64() {
    local depends=()
    isPlatform "x11" && depends+=(libgl1-mesa-dev)
    isPlatform "rpi" && depends+=(libraspberrypi-dev)
    getDepends "${depends[@]}"
}

function sources_lr-parallel-n64() {
    local branch"master"
    local commit=""
    # build from ab155da1 due to https://github.com/libretro/parallel-n64/issues/544
    isPlatform "arm" && commit="ab155da1"
    gitPullOrClone "$md_build" https://github.com/libretro/parallel-n64.git "$branch" "$commit"
}

function build_lr-parallel-n64() {
    rpSwap on 1000
    make clean
    local params=()
    if isPlatform "rpi" || isPlatform "odroid-c1"; then
        params+=(platform="$__platform")
    elif isPlatform "tinker"; then
        params+=(CPUFLAGS="-DNO_ASM -DARM -D__arm__ -DARM_ASM -D__NEON_OPT -DNOSSE")
        params+=(GLES=1 HAVE_NEON=1 WITH_DYNAREC=arm)
        params+=(GL_LIB:=-lGLESv2)
    fi
    make "${params[@]}"
    rpSwap off
    md_ret_require="$md_build/parallel_n64_libretro.so"
}

function install_lr-parallel-n64() {
    md_ret_files=(
        'parallel_n64_libretro.so'
        'README.md'
    )
}

function configure_lr-parallel-n64() {
  mkRomDir "n64"
  mkRomDir "n64-japan"
  mkRomDir "n64dd"
  ensureSystemretroconfig "n64"
  ensureSystemretroconfig "n64-japan"
  ensureSystemretroconfig "n64dd"

    # Set core options
    setRetroArchCoreOption "parallel-n64-gfxplugin" "auto"
    setRetroArchCoreOption "parallel-n64-gfxplugin-accuracy" "low"
    setRetroArchCoreOption "parallel-n64-screensize" "640x480"

    # Copy config files
    cat > $home/RetroPie/BIOS/gles2n64rom.conf << _EOF_
#rom specific settings

rom name=SUPER MARIO 64
target FPS=25

rom name=Kirby64
target FPS=25

rom name=Banjo-Kazooie
framebuffer enable=1
update mode=4
target FPS=25

rom name=BANJO TOOIE
hack banjo tooie=1
ignore offscreen rendering=1
framebuffer enable=1
update mode=4

rom name=STARFOX64
window width=864
window height=520
target FPS=27

rom name=MARIOKART64
target FPS=27

rom name=THE LEGEND OF ZELDA
texture use IA=0
hack zelda=1
target FPS=17

rom name=ZELDA MAJORA'S MASK
texture use IA=0
hack zelda=1
rom name=F-ZERO X
window width=864
window height=520
target FPS=55
rom name=WAVE RACE 64
window width=864
window height=520
target FPS=27
rom name=SMASH BROTHERS
framebuffer enable=1
window width=864
window height=520
target FPS=27
rom name=1080 SNOWBOARDING
update mode=2
target FPS=27
rom name=PAPER MARIO
update mode=4
rom name=STAR WARS EP1 RACER
video force=1
video width=320
video height=480
rom name=JET FORCE GEMINI
framebuffer enable=1
update mode=2
ignore offscreen rendering=1
target FPS=27
rom name=RIDGE RACER 64
window width=864
window height=520
enable lighting=0
target FPS=27
rom name=Diddy Kong Racing
target FPS=27
rom name=MarioParty
update mode=4
rom name=MarioParty3
update mode=4
rom name=Beetle Adventure Rac
window width=864
window height=520
target FPS=27
rom name=EARTHWORM JIM 3D
rom name=LEGORacers
rom name=GOEMONS GREAT ADV
window width=864
window height=520
rom name=Buck Bumble
window width=864
window height=520
rom name=BOMBERMAN64U2
window width=864
window height=520
rom name=ROCKETROBOTONWHEELS
window width=864
window height=520
rom name=GOLDENEYE
force screen clear=1
framebuffer enable=1
window width=864
window height=520
target FPS=25
rom name=Mega Man 64
framebuffer enable=1
target FPS=25
_EOF_
    chown $user:$user "$biosdir/gles2n64rom.conf"

    addEmulator 0 "$md_id" "n64" "$md_inst/parallel-n64_libretro.so"
    addEmulator 0 "$md_id" "n64-japan" "$md_inst/parallel-n64_libretro.so"
    addEmulator 0 "$md_id" "n64dd" "$md_inst/parallel-n64_libretro.so"
    addSystem "n64"
    addSystem "n64-japan"
    addSystem "n64dd"
    if [ -e /usr/lib/libretro/parallel-n64_libretro.so ]
    then
      ensureSystemretroconfig "n64"
      ensureSystemretroconfig "n64-japan"
      ensureSystemretroconfig "n64dd"

      addEmulator 0 "$md_id-ppa" "n64" "$md_instppa/parallel-n64_libretro.so"
      addEmulator 0 "$md_id-ppa" "n64-japan" "$md_instppa/parallel-n64_libretro.so"
      addEmulator 0 "$md_id-ppa" "n64dd" "$md_instppa/parallel-n64_libretro.so"
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
              iniSet "parallel-n64-gfxplugin" "auto"
              iniSet "parallel-n64-gfxplugin-accuracy" "low"
              iniSet "parallel-n64-screensize" "640x480"

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
              iniSet "parallel-n64-gfxplugin" "auto"
              iniSet "parallel-n64-gfxplugin-accuracy" "low"
              iniSet "parallel-n64-screensize" "640x480"

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
              iniSet "parallel-n64-gfxplugin" "auto"
              iniSet "parallel-n64-gfxplugin-accuracy" "low"
              iniSet "parallel-n64-screensize" "640x480"

              chown $user:$user "$core_config"


  fi

}
