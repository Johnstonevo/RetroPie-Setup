#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="solarus"
rp_module_desc="solarus - A lightweight, free and open-source game engine for Action-RPGs"
rp_module_help="Copy your Solarus quests (games) to $romdir/solarus"
rp_module_licence="GPL3 https://gitlab.com/solarus-games/solarus/raw/dev/license.txt"
rp_module_section="opt"
rp_module_flags="!aarch64"

function _options_cfg_file_solarus() {
    echo "$md_conf_root/solarus/options.cfg"
}

function depends_solarus() {
    # ref: https://gitlab.com/solarus-games/solarus/blob/dev/compilation.md
    local depends=(
        cmake pkg-config
        libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev
        libopenal-dev libvorbis-dev libogg-dev
        libmodplug-dev libphysfs-dev
        libluajit-5.1-dev
    )
    getDepends "${depends[@]}"
}

function sources_solarus() {
    gitPullOrClone "$md_build" https://gitlab.com/solarus-games/solarus.git
}

function build_solarus() {
    local params=(
        -DSOLARUS_GUI=OFF -DSOLARUS_TESTS=OFF -DSOLARUS_FILE_LOGGING=OFF
        -DSOLARUS_LIBRARY_INSTALL_DESTINATION="$md_inst/lib"
        -DCMAKE_INSTALL_PREFIX="$md_inst"
        -DCMAKE_INSTALL_RPATH="$md_inst/lib"
        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
    )
    isPlatform "gles" && params+=(-DSOLARUS_GL_ES=ON)
    rm -rf build
    mkdir build
    cd build
    cmake "${params[@]}" ..
    make
}

function install_solarus() {
    cd build
    make install/strip
}


function configure_solarus() {
    mkRomDir "solarus"
    addEmulator 1 "$md_id" "solarus" "$md_inst/solarus.sh %ROM%"
    addSystem "solarus"
      moveConfigDir "$home/.solarus" "$md_conf_root/solarus"
    [[ "$mode" == "remove" ]] && return


    # create launcher for Solarus that disables JACK driver in OpenAL,
    # disables mouse cursor, starts in fullscreen mode and configures
    # the joypad deadzone and buttons combo for quitting options
    cat > "$md_inst/solarus.sh" << _EOF_
#!/usr/bin/env bash
export ALSOFT_DRIVERS="-jack,"
ARGS=("-cursor-visible=no" "-fullscreen=yes")
[[ -f "$(_options_cfg_file_solarus)" ]] && source "$(_options_cfg_file_solarus)"
[[ -n "\$JOYPAD_DEADZONE" ]] && ARGS+=("-joypad-deadzone=\$JOYPAD_DEADZONE")
[[ -n "\$QUIT_COMBO" ]] && ARGS+=("-quit-combo=\$QUIT_COMBO")
"$md_inst"/bin/solarus-run "\${ARGS[@]}" "\$@"
_EOF_
    chmod +x "$md_inst/solarus.sh"
}