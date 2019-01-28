#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="retroarch"
rp_module_desc="RetroArch - frontend to the libretro emulator cores - required by all lr-* emulators"
rp_module_licence="GPL3 https://raw.githubusercontent.com/libretro/RetroArch/master/COPYING"
rp_module_section="core"

function depends_retroarch() {
    local depends=(libudev-dev libxkbcommon-dev libsdl2-dev libasound2-dev libusb-1.0-0-dev)
    isPlatform "rpi" && depends+=(libraspberrypi-dev)
    isPlatform "mali" && depends+=(mali-fbdev)
    isPlatform "x11" && depends+=(libx11-xcb-dev libpulse-dev libvulkan-dev)
    isPlatform "vero4k" && depends+=(vero3-userland-dev-osmc zlib1g-dev libfreetype6-dev)

    if compareVersions "$__os_debian_ver" ge 9; then
        depends+=(libavcodec-dev libavformat-dev libavdevice-dev)
    fi

    # only install nvidia-cg-toolkit if it is available (as the non-free repo may not be enabled)
    if isPlatform "x86"; then
        if [[ -n "$(apt-cache search --names-only nvidia-cg-toolkit)" ]]; then
            depends+=(nvidia-cg-toolkit)
        fi
    fi

    getDepends "${depends[@]}"

    addUdevInputRules
}

function sources_retroarch() {
    gitPullOrClone "$md_build" https://github.com/libretro/RetroArch.git v1.7.5
    applyPatch "$md_data/01_hotkey_hack.diff"
    applyPatch "$md_data/02_disable_search.diff"
    applyPatch "$md_data/03_disable_udev_sort.diff"
}

function build_retroarch() {
    local params=(--disable-sdl --enable-sdl2 --disable-oss --disable-al --disable-jack --disable-qt)
    ! isPlatform "x11" && params+=(--disable-x11 --disable-pulse)
    if compareVersions "$__os_debian_ver" lt 9; then
        params+=(--disable-ffmpeg)
    fi
    isPlatform "gles" && params+=(--enable-opengles)
    isPlatform "rpi" && params+=(--enable-dispmanx)
    isPlatform "mali" && params+=(--enable-mali_fbdev)
    isPlatform "kms" && params+=(--enable-kms)
    isPlatform "arm" && params+=(--enable-floathard)
    isPlatform "neon" && params+=(--enable-neon)
    isPlatform "x11" && params+=(--enable-vulkan)
    isPlatform "vero4k" && params+=(--enable-mali_fbdev --with-opengles_libs='-L/opt/vero3/lib')
    ./configure --prefix="$md_inst" "${params[@]}"
    make clean
    make
    md_ret_require="$md_build/retroarch"

}

function install_retroarch() {
    mkUserDir "$raconfigdir/"
    mkUserDir "$raconfigdir/assets"
    mkUserDir "$raconfigdir/shaders"
    mkUserDir "$raconfigdir/overlay"
    mkUserDir "$raconfigdir/database"
    mkUserDir "$raconfigdir/cheats"
    mkUserDir "$raconfigdir/retroarch-joypads"
    mkUserDir "$raconfigdir/downloads"
    mkUserDir "$raconfigdir/config"
    mkUserDir "$raconfigdir/cores"
    mkUserDir "$raconfigdir/screenshots"
    mkUserDir "$raconfigdir/playlists"
    mkUserDir "$raconfigdir/thumbnails"
    mkUserDir "$raconfigdir/records_config"
    mkUserDir "$raconfigdir/records"
    mkUserDir "$raconfigdir/savefiles"
    mkUserDir "$raconfigdir/savestates"
    chown -R $user:$user "$raconfigdir"
    chmod -R 775 "$raconfigdir"

    make install
    md_ret_files=(
        'retroarch.cfg'
    )
}

function update_shaders_retroarch() {
    local dir="$raconfigdir/shaders"
    local branch=""
    if isPlatform "rpi" && branch="rpi"; then
    # remove if not git repository for fresh checkout
    [[ ! -d "$dir/.git" ]] && rm -rf "$dir"
    gitPullOrClone "$dir" https://github.com/RetroPie/common-shaders.git "$branch"
    fi
   if  isPlatform "x86" ; then
     [[ ! -d "$dir/.git" ]] && rm -rf "$dir"
    gitPullOrClone "$dir" https://github.com/Johnstonevo/common-shaders.git
    fi
    chown -R $user:$user "$dir"
}

function update_overlays_retroarch() {
    local dir="$raconfigdir/overlays"
    # remove if not a git repository for fresh checkout
    [[ ! -d "$dir/.git" ]] && rm -rf "$dir"
    gitPullOrClone "$raconfigdir" https://github.com/Johnstonevo/overlays.git
    chown -R $user:$user "$dir"
}

function update_assets_retroarch() {
    local dir="$raconfigdir/assets"
    # remove if not a git repository for fresh checkout
    [[ ! -d "$dir/.git" ]] && rm -rf "$dir"
    gitPullOrClone "$dir" https://github.com/libretro/retroarch-assets.git
    chown -R $user:$user "$dir"
}



#function update_database_retroarch() {
#     if  isPlatform "x86" ; then
#    mkUserDir "$raconfigdir/database"
#    local dir="$raconfigdir/database"
#    # remove if not a git repository for fresh checkout
#    [[ ! -d "$dir/.git" ]] && rm -rf "$dir"
#    gitPullOrClone "$md_build/libretro-super" https://github.com/libretro/libretro-super.git
#    cd "$md_build/libretro-super"
#   ./libretro-fetch.sh retroarch
#   ./libretro-build-database.sh
#    cd "$md_build/libretro-super/retroarch/media/libretrodb/rdb"
#    cp -R "$md_build/libretro-super/retroarch/media/libretrodb/rdb" "$dir"
#    chown -R $user:$user "$dir"
#    fi
#}

function install_xmb_monochrome_assets_retroarch() {
    if  isPlatform "x86" ; then
    local dir="$raconfigdir/assets"
    [[ -d "$dir/.git" ]] && return
    [[ ! -d "$dir" ]] && mkUserDir "$dir"
    downloadAndExtract "$__archive_url/retroarch-xmb-monochrome.tar.gz" "$dir"
    chown -R $user:$user "$dir"
    fi
}

function _package_xmb_monochrome_assets_retroarch() {
    if  isPlatform "x86" ; then
    gitPullOrClone "$md_build/assets" https://github.com/libretro/retroarch-assets.git
    mkdir -p "$__tmpdir/archives"
    local archive="$__tmpdir/archives/retroarch-xmb-monochrome.tar.gz"
    rm -f "$archive"
    tar cvzf "$archive" -C "$md_build/assets" xmb/monochrome
    chown -R $user:$user "$dir"
    fi
}


function configure_retroarch() {
    [[ "$md_mode" == "remove" ]] && return

    # move / symlink the retroarch configuration
    mkUserDir "$raconfigdir/"
    mkUserDir "$raconfigdir/assets"
    mkUserDir "$raconfigdir/shaders"
    mkUserDir "$raconfigdir/overlay"
    mkUserDir "$raconfigdir/database"
    mkUserDir "$raconfigdir/cheats"
    mkUserDir "$raconfigdir/retroarch-joypads"
    mkUserDir "$raconfigdir/downloads"
    mkUserDir "$raconfigdir/config"
    mkUserDir "$raconfigdir/cores"
    mkUserDir "$raconfigdir/screenshots"
    mkUserDir "$raconfigdir/playlists"
    mkUserDir "$raconfigdir/thumbnails"
    mkUserDir "$raconfigdir/records_config"
    mkUserDir "$raconfigdir/records"
    mkUserDir "$raconfigdir/savefiles"
    mkUserDir "$raconfigdir/savestates"
    chown -R $user:$user "$raconfigdir"
    chmod -R 775 "$raconfigdir"

    #moveConfigDir "$raconfigdir" "$raconfigdir"

    # move / symlink our old retroarch-joypads folder
     moveConfigDir "$raconfigdir/retroarch-joypads" "$raconfigdir/autoconfig"

    # move / symlink old assets / overlays and shader folder
    #moveConfigDir "$md_inst/assets" "$raconfigdir/assets"
    #moveConfigDir "$md_inst/overlays" "$raconfigdir/overlays"
    #moveConfigDir "$md_inst/shader" "$raconfigdir/shaders"

    # install shaders by default
    update_shaders_retroarch
    update_assets_retroarch
    # install assets
    install_xmb_monochrome_assets_retroarch
    _package_xmb_monochrome_assets_retroarch
    #install databases
    update_database_retroarch

    local config="$(mktemp)"

    cp "$md_inst/retroarch.cfg" "$raconfig"

    # query ES A/B key swap configuration
    local es_swap="false"
    getAutoConf "es_swap_a_b" && es_swap="true"

    # configure default options
    iniConfig " = " '"' "$config"
    iniSet "cache_directory" "/tmp/retroarch"
    iniSet "system_directory" "$biosdir"
    iniSet "config_save_on_exit" "false"
    iniSet "video_aspect_ratio_auto" "true"
    iniSet "video_smooth" "false"

    if ! isPlatform "x86"; then
        iniSet "video_threaded" "true"
    fi

    iniSet "video_font_size" "20"
    iniSet "core_options_path" "$raconfigdir/config/retroarch-core-options.cfg"
    isPlatform "x11" && iniSet "video_fullscreen" "true"

    # set default render resolution to 640x480 for rpi1
    if isPlatform "rpi1"; then
        iniSet "video_fullscreen_x" "640"
        iniSet "video_fullscreen_y" "480"
    fi

    # enable hotkey ("select" button)
    iniSet "input_enable_hotkey" "nul"
    iniSet "input_exit_emulator" "escape"

    # enable and configure rewind feature
    iniSet "rewind_enable" "false"
    iniSet "rewind_buffer_size" "10"
    iniSet "rewind_granularity" "2"S
    iniSet "input_rewind" "r"

    # enable gpu screenshots
    iniSet "video_gpu_screenshot" "true"

    # enable and configure shaders
    iniSet "input_shader_next" "m"
    iniSet "input_shader_prev" "n"

    # configure keyboard mappings
    iniSet "input_player1_a" "x"
    iniSet "input_player1_b" "z"
    iniSet "input_player1_y" "a"
    iniSet "input_player1_x" "s"
    iniSet "input_player1_start" "enter"
    iniSet "input_player1_select" "rshift"
    iniSet "input_player1_l" "q"
    iniSet "input_player1_r" "w"
    iniSet "input_player1_left" "left"
    iniSet "input_player1_right" "right"
    iniSet "input_player1_up" "up"
    iniSet "input_player1_down" "down"

    # input settings
    iniSet "input_autodetect_enable" "true"
    iniSet "auto_remaps_enable" "true"
    iniSet "input_joypad_driver" "udev"
    iniSet "all_users_control_menu" "true"

    # rgui by default
    iniSet "menu_driver" "rgui"

    # hide online updater menu options
    iniSet "menu_show_core_updater" "false"
    iniSet "menu_show_online_updater" "false"

    # disable unnecessary xmb menu tabs
    iniSet "xmb_show_add" "false"
    iniSet "xmb_show_history" "false"
    iniSet "xmb_show_images" "false"
    iniSet "xmb_show_music" "false"

    # disable xmb menu driver icon shadows
    iniSet "xmb_shadows_enable" "false"

    # swap A/B buttons based on ES configuration
    iniSet "menu_swap_ok_cancel_buttons" "$es_swap"
    #configure my main settings
    iniSet "assets_directory" "$raconfigdir/assets"
    iniSet "video_shader_dir" "$raconfigdir/shaders"
    iniSet "overlay_directory " "$raconfigdir/overlays/"
    iniSet "input_player1_analog_dpad_mode " "1"
    iniSet "input_player2_analog_dpad_mode " "1"
    iniSet "input_player3_analog_dpad_mode " "1"
    iniSet "input_player4_analog_dpad_mode " "1"
    iniSet "input_player5_analog_dpad_mode " "1"
    iniSet "input_player6_analog_dpad_mode " "1"
    iniSet "input_player7_analog_dpad_mode " "1"
    iniSet "input_player8_analog_dpad_mode " "1"
    # Add inputs for Afterglow.  Poss Xbox
    iniSet "input_player1_select_btn" "6"
    iniSet "input_player1_start_btn" "7"
    iniSet "input_remap_binds_enable" "true"
    iniSet "input_remapping_directory" "/home/$user/.config/retroarch/config/remaps"
    iniSet "input_player1_up_btn" "h0up"
    iniSet "input_player1_down_btn" "h0down"
    iniSet "input_player1_left_btn" "h0left"
    iniSet "input_player1_right_btn" "h0right"
    iniSet "input_player1_a_btn" "1"
    iniSet "input_player1_b_btn" "0"
    iniSet "input_player1_x_btn" "3"
    iniSet "input_player1_y_btn" "2"
    iniSet "input_player1_l_btn" "4"
    iniSet "input_player1_r_btn" "5"
    iniSet "input_player1_l2_axis" "+2"
    iniSet "input_player1_r2_axis" "+5"
    iniSet "input_player1_l3_btn" "9"
    iniSet "input_player1_r3_btn" "10"
    iniSet "input_player1_l_x_minus_axis" "-0"
    iniSet "input_player1_l_x_plus_axis" "+0"
    iniSet "input_player1_l_y_minus_axis" "-1"
    iniSet "input_player1_l_y_plus_axis" "+1"
    iniSet "input_player1_r_x_minus_axis" "-3"
    iniSet "input_player1_r_x_plus_axis" "+3"
    iniSet "input_player1_r_y_minus_axis" "-4"
    iniSet "input_player1_r_y_plus_axis" "+4"
    iniSet "input_enable_hotkey_btn" "6"
    iniSet "input_exit_emulator_btn" "7"
    iniSet "input_save_state_btn" "5"
    iniSet "input_load_state_btn" "4"
    iniSet "input_state_slot_increase_btn" "h0right"
    iniSet "input_state_slot_decrease_btn" "h0left"
    iniSet "input_menu_toggle_btn" "3"
    iniSet "input_reset_btn" "0"


#add cheevos retroachievments
    iniSet "cheevos_username" "yourusername"
    iniSet "cheevos_password" "yourpassword"
    iniSet "cheevos_enable" " true"
    iniSet "cheevos_hardcore_mode_enable" "false"
    iniSet "cheevos_verbose_enable" "true"
    iniSet "cheevos_leaderboards_enable" "true"

    #Game Saves
    iniSet "savefile_directory "  "$raconfigdir/savefiles"
    iniSet "savestate_directory" "$raconfigdir/savestates"
    #Cheat Path
    iniSet "content_database_path" "$raconfigdir/database/rdb"
    iniSet "cheat_database_path" "$raconfigdir/cheats"
    iniSet "cheat_settings_path" "$raconfigdir/cheats/xml"


    copyDefaultConfig "$config" "$raconfigdir/retroarch.cfg"
    rm "$config"

    # if no menu_driver is set, force RGUI, as the default has now changed to XMB.
    iniConfig " = " '"' "$raconfigdir/retroarch.cfg"
    iniGet "menu_driver"
    [[ -z "$ini_value" ]] && iniSet "menu_driver" "rgui"

    # if no menu_unified_controls is set, force it on so that keyboard player 1 can control
    # the RGUI menu which is important for arcade sticks etc that map to keyboard inputs
    iniGet "menu_unified_controls"
    [[ -z "$ini_value" ]] && iniSet "menu_unified_controls" "true"

    # remapping hack for old 8bitdo firmware
    addAutoConf "8bitdo_hack" 0
}

function keyboard_retroarch() {
    if [[ ! -f "$raconfigdir/retroarch.cfg" ]]; then
        printMsgs "dialog" "No RetroArch configuration file found at $raconfigdir/retroarch.cfg"
        return
    fi
    local input
    local options

    local i=1
    local key=()
    while read input; do
        local parts=($input)
        key+=("${parts[0]}")
        options+=("${parts[0]}" $i 2 "${parts[*]:2}" $i 26 16 0)
        ((i++))
    done < <(grep "^[[:space:]]*input_player[0-9]_[a-z]*" "$raconfigdir/retroarch.cfg")
    local cmd=(dialog --backtitle "$__backtitle" --form "RetroArch keyboard configuration" 22 48 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [[ -n "$choice" ]]; then
        local value
        local values
        readarray -t values <<<"$choice"
        iniConfig " = " "" "$raconfigdir/retroarch.cfg"
        i=0
        for value in "${values[@]}"; do
            iniSet "${key[$i]}" "$value" >/dev/null
            ((i++))
        done
    fi
}

function hotkey_retroarch() {
    iniConfig " = " '"' "$raconfigdir/retroarch.cfg"
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose the desired hotkey behaviour." 22 76 16)
    local options=(1 "Hotkeys enabled. (default)"
             2 "Press ALT to enable hotkeys."
             3 "Hotkeys disabled. Press ESCAPE to open RGUI.")
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [[ -n "$choice" ]]; then
        case "$choice" in
            1)
                iniSet "input_enable_hotkey" "nul"
                iniSet "input_exit_emulator" "escape"
                iniSet "input_menu_toggle" "F1"
                ;;
            2)
                iniSet "input_enable_hotkey" "alt"
                iniSet "input_exit_emulator" "escape"
                iniSet "input_menu_toggle" "F1"
                ;;
            3)
                iniSet "input_enable_hotkey" "escape"
                iniSet "input_exit_emulator" "nul"
                iniSet "input_menu_toggle" "escape"
                ;;
        esac
    fi
}

function gui_retroarch() {
    while true; do
        local names=(shaders overlays assets database)
        local dirs=(shaders overlays assets database)
        local options=()
        local name
        local dir
        local i=1
        for name in "${names[@]}"; do
            if [[ -d "$raconfigdir/${dirs[i-1]}/.git" ]]; then
                options+=("$i" "Manage $name (installed)")
            else
                options+=("$i" "Manage $name (not installed)")
            fi
            ((i++))
        done
        options+=(
            4 "Configure keyboard for use with RetroArch"
            5 "Configure keyboard hotkey behaviour for RetroArch"
        )
        local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        case "$choice" in
            1|2|3)
                name="${names[choice-1]}"
                dir="${dirs[choice-1]}"
                options=(1 "Install/Update $name" 2 "Uninstall $name" )
                cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option for $dir" 12 40 06)
                choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

                case "$choice" in
                    1)
                        "update_${name}_retroarch"
                        ;;
                    2)
                        rm -rf "$raconfigdir/$dir"
                        [[ "$dir" == "assets" ]] && install_xmb_monochrome_assets_retroarch
                        ;;
                    *)
                        continue
                        ;;

                esac
                ;;
            4)
                keyboard_retroarch
                ;;
            5)
                hotkey_retroarch
                ;;
            *)
                break
                ;;
        esac

    done
}
