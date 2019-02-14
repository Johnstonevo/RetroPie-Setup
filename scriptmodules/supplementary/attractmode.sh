#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="attractmode"
rp_module_desc="Attract Mode emulator frontend"
rp_module_licence="GPL3 https://raw.githubusercontent.com/mickelson/attract/master/License.txt"
rp_module_section="exp"
rp_module_flags="!mali !kms frontend"

function _get_configdir_attractmode() {
    echo "$home/.attract"
}

function _add_system_attractmode() {
    local attract_dir="$(_get_configdir_attractmode)"
    [[ ! -d "$attract_dir" || ! -f /usr/bin/attract ]] && return 0
    local fullname="$1"
    local name="$2"
    local path="$3"
    local extensions="$4"
    local command="$5"
    local platform="$6"
    local theme="$7"

    # replace any / characters in fullname
    fullname="${fullname//\/ }"

    local config="$attract_dir/emulators/$fullname.cfg"
    iniConfig " " "" "$config"
    # replace %ROM% with "[romfilename]" and convert to array
    command=(${command//%ROM%/\"[romfilename]\"})
    iniSet "executable" "${command[0]}"
    iniSet "args" "${command[*]:1}"

    iniSet "rompath" "$path"
    iniSet "system" "$fullname"

    # extensions separated by semicolon
    extensions="${extensions// /;}"
    iniSet "romext" "$extensions"


    # snap path
    local snap="snap"
    [[ "$name" == "retropie" ]] && snap="icons"

    if [[  "$platform" == arcade  ]]; then
      iniSet "system" "Arcade"
      iniSet "info_source"    "./mame-config/$fullname.xml"
      iniSet "import_extras"        "./mame-config/catver.ini;./mame-config/nplayers.ini;./mame-config/category.ini;./mame-config/Catlist.ini;./mame-config/$fullname.xml"
      iniSet "artwork flyer" "$datadir/roms/arcade/flyer"
      iniSet "artwork marquee" "$datadir/roms/arcade/marquee"
      iniSet "artwork snap" "$datadir/roms/arcade/$snap"
      iniSet "artwork wheel" "$datadir/roms/arcade/wheel"
    else
      iniSet "info_source"
      iniSet "import_extras"        #"$attract_dir/xml/$fullname.xml"
      iniSet "artwork flyer" "$path/flyer"
      iniSet "artwork marquee" "$path/marquee"
      iniSet "artwork snap" "$path/$snap"
      iniSet "artwork wheel" "$path/wheel"
    fi




    chown $user:$user "$config"

    # if no gameslist, generate one
    if [[ ! -f "$attract_dir/romlists/$fullname.txt" ]]; then
        #sudo -u $user attract --build-romlist "$fullname" -o "$fullname"
        if [[ -f "$attract_dir/xml/$fullname.xml" ]]; then
          sudo -u $user attract --import-romlist "$attract_dir/xml/$fullname.xml" "$fullname"
        else
          sudo -u $user attract --build-romlist "$fullname" -o "$fullname"
        fi
    fi

    local config="$attract_dir/attract.cfg"
    local tab=$'\t'
    if [[ -f "$config" ]] && ! grep -q "display$tab$fullname" "$config"; then
        cp "$config" "$config.bak"
        if [[  "$platform" == arcade  ]]; then
          cat >>"$config" <<_EOF_
${tab}
display${tab}$fullname
${tab}layout               HP2-Arcade-Menu
${tab}romlist              $fullname
${tab}in_cycle             no
${tab}in_menu              no
${tab}global_filter
${tab}${tab}rule                    FileIsAvailable equals 1
${tab}${tab}rule                    Category not_contains Mature
${tab}${tab}rule                    Status not_equals preliminary
${tab}${tab}rule                    Category not_contains Electromechanical|Tabletop|Casino|Quiz|Mahjong|Computer|Microcomputer|Test|Portable|Console|Handheld|Device|Training Board|Synthesiser|Clock|Document Processors
${tab}${tab}rule                    Category not_equals Misc.|Quiz / Korean|Electromechanical / Reels|Casino / Cards|Casino / Reels
${tab}filter              All
${tab}${tab}rule                    Name not_contains "(Japan"|"(Brazil"|"(Asia"|Bust-A-Move
${tab}${tab}rule                    Title not_contains bootleg|prototype
${tab}${tab}rule                    Manufacturer not_contains bootleg
${tab}${tab}rule                    CloneOf not_equals .*
${tab}filter              Favourites
${tab}${tab}rule                    Favourite equals 1
${tab}filter              "Most Played Games"
${tab}${tab}sort_by              PlayedCount
${tab}${tab}reverse_order        true
${tab}${tab}rule                    PlayedCount not_contains 0
${tab}filter              Breakout
${tab}${tab}rule                    Category contains Ball & Paddle|Breakout
${tab}${tab}rule                    Title not_contains bootleg|prototype
${tab}${tab}rule                    Manufacturer not_contains bootleg
${tab}${tab}rule                    CloneOf not_equals .*
${tab}filter              Driving
${tab}${tab}rule                    Category contains Driving|Biking|Motorcycle
${tab}${tab}rule                    Title not_contains bootleg|prototype
${tab}${tab}rule                    Manufacturer not_contains bootleg
${tab}${tab}rule                    CloneOf not_equals .*
${tab}filter              Fighter
${tab}${tab}rule                    Category contains Fighter
${tab}${tab}rule                    Title not_contains bootleg|prototype
${tab}${tab}rule                    Manufacturer not_contains bootleg
${tab}${tab}rule                    CloneOf not_equals .*
${tab}filter              "Maze Games"
${tab}${tab}rule                    Category equals Maze
${tab}${tab}rule                    Title not_contains bootleg|prototype
${tab}${tab}rule                    Manufacturer not_contains bootleg
${tab}${tab}rule                    CloneOf not_equals .*
${tab}filter              Mini-Games
${tab}${tab}rule                    Category contains Mini-Games
${tab}${tab}rule                    Title not_contains bootleg|prototype
${tab}${tab}rule                    Manufacturer not_contains bootleg
${tab}${tab}rule                    CloneOf not_equals .*
${tab}filter              Pinball
${tab}${tab}rule                    Category contains Pinball
${tab}${tab}rule                    Title not_contains bootleg|prototype
${tab}${tab}rule                    Manufacturer not_contains bootleg
${tab}${tab}rule                    CloneOf not_equals .*
${tab}filter              Platform
${tab}${tab}rule                    Category contains Platform
${tab}${tab}rule                    Title not_contains bootleg|prototype
${tab}${tab}rule                    Manufacturer not_contains bootleg
${tab}${tab}rule                    CloneOf not_equals .*
${tab}filter              Puzzle
${tab}${tab}rule                    Category contains Puzzle
${tab}${tab}rule                    Title not_contains bootleg|prototype
${tab}${tab}rule                    Manufacturer not_contains bootleg
${tab}${tab}rule                    CloneOf not_equals .*
${tab}filter              Rhythm
${tab}${tab}rule                    Category contains Rhythm
${tab}${tab}rule                    Title not_contains bootleg|prototype
${tab}${tab}rule                    Manufacturer not_contains bootleg
${tab}${tab}rule                    CloneOf not_equals .*
${tab}filter              Shooter
${tab}${tab}rule                    Category contains Shooter
${tab}${tab}rule                    Title not_contains bootleg|prototype
${tab}${tab}rule                    Manufacturer not_contains bootleg
${tab}${tab}rule                    CloneOf not_equals .*
${tab}filter              Sports
${tab}${tab}rule                    Category contains Sports
${tab}${tab}rule                    Title not_contains bootleg|prototype
${tab}${tab}rule                    Manufacturer not_contains bootleg
${tab}${tab}rule                    CloneOf not_equals .*
${tab}filter              Clones
${tab}${tab}rule                    CloneOf contains .*
${tab}filter              Bootleg
${tab}${tab}rule                    Manufacturer contains bootleg
${tab}filter              Prototype
${tab}${tab}rule                    Title contains prototype
${tab}
_EOF_
          local config="$attract_dir/romlists/Arcades.txt"

    # remove extension
          path="${path/%.*}"

          if [[ ! -f "$config" ]]; then
              echo "#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons" >"$config"
          fi

          # if the entry already exists, remove it
          if grep -q "^$path;" "$config"; then
              sed -i "/^$path/d" "$config"
          fi

          echo "$fullname;$fullname;@;;;;;;;;;;;;;;" >>"$config"

      elif  [[ -e "$attract_dir/scraper/Consoles/overview/$fullname.txt" ]]; then
                  cat >>"$config" <<_EOF_
${tab}
display${tab}$fullname
${tab}layout               HP2-Systems-Menu
${tab}romlist              $fullname
${tab}in_cycle             no
${tab}in_menu              no
${tab}global_filter
${tab}${tab}rule                 FileIsAvailable equals 1
${tab}filter               All
${tab}filter               Favourites
${tab}${tab}rule                 Favourite equals 1
${tab}filter               "Most Played Games"
${tab}${tab}sort_by              PlayedCount
${tab}${tab}reverse_order        true
${tab}${tab}rule                 PlayedCount not_contains 0
${tab}
_EOF_
          local config="$attract_dir/romlists/Consoles.txt"

          # remove extension
          path="${path/%.*}"

          if [[ ! -f "$config" ]]; then
              echo "#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons" >"$config"
          fi

          # if the entry already exists, remove it
          if grep -q "^$path;" "$config"; then
              sed -i "/^$path/d" "$config"
          fi

          echo "$fullname;$fullname;@;;;;;;;;;;;;;;" >>"$config"


      elif  [[ -e "$attract_dir/scraper/Handhelds/overview/$fullname.txt" ]]; then
                  cat >>"$config" <<_EOF_
${tab}
display${tab}$fullname
${tab}layout               HP2-Systems-Menu
${tab}romlist              $fullname
${tab}in_cycle             no
${tab}in_menu              no
${tab}global_filter
${tab}${tab}rule                 FileIsAvailable equals 1
${tab}filter               All
${tab}filter               Favourites
${tab}${tab}rule                 Favourite equals 1
${tab}filter               "Most Played Games"
${tab}${tab}sort_by              PlayedCount
${tab}${tab}reverse_order        true
${tab}${tab}rule                 PlayedCount not_contains 0
${tab}
_EOF_
          local config="$attract_dir/romlists/Handhelds.txt"

          # remove extension
          path="${path/%.*}"

          if [[ ! -f "$config" ]]; then
              echo "#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons" >"$config"
          fi

          # if the entry already exists, remove it
          if grep -q "^$path;" "$config"; then
              sed -i "/^$path/d" "$config"
          fi

          echo "$fullname;$fullname;@;;;;;;;;;;;;;;" >>"$config"


        elif [[  $fullname =~ Hacks ]]; then
                  cat >>"$config" <<_EOF_
${tab}
display${tab}$fullname
${tab}layout               HP2-Systems-Menu
${tab}romlist              $fullname
${tab}in_cycle             no
${tab}in_menu              no
${tab}global_filter
${tab}${tab}rule                 FileIsAvailable equals 1
${tab}filter               All
${tab}filter               Favourites
${tab}${tab}rule                 Favourite equals 1
${tab}filter               "Most Played Games"
${tab}${tab}sort_by              PlayedCount
${tab}${tab}reverse_order        true
${tab}${tab}rule                 PlayedCount not_contains 0
${tab}
_EOF_
          local config="$attract_dir/romlists/Hacks.txt"

          # remove extension
          path="${path/%.*}"

          if [[ ! -f "$config" ]]; then
              echo "#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons" >"$config"
          fi

          # if the entry already exists, remove it
          if grep -q "^$path;" "$config"; then
              sed -i "/^$path/d" "$config"
          fi

          echo "$fullname;$fullname;@;;;;;;;;;;;;;;" >>"$config"

        elif [[ -e "$attract_dir/scraper/Computers/overview/$fullname.txt" ]]; then
                  cat >>"$config" <<_EOF_
${tab}
display${tab}$fullname
${tab}layout               HP2-Systems-Menu
${tab}romlist              $fullname
${tab}in_cycle             no
${tab}in_menu              no
${tab}global_filter
${tab}${tab}rule                 FileIsAvailable equals 1
${tab}filter               All
${tab}filter               Favourites
${tab}${tab}rule                 Favourite equals 1
${tab}filter               "Most Played Games"
${tab}${tab}sort_by              PlayedCount
${tab}${tab}reverse_order        true
${tab}${tab}rule                 PlayedCount not_contains 0
${tab}
_EOF_
            local config="$attract_dir/romlists/Computers.txt"

            # remove extension
            path="${path/%.*}"

            if [[ ! -f "$config" ]]; then
                echo "#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons" >"$config"
            fi

            # if the entry already exists, remove it
            if grep -q "^$path;" "$config"; then
                sed -i "/^$path/d" "$config"
            fi

            echo "$fullname;$fullname;@;;;;;;;;;;;;;;" >>"$config"

          elif [[ -e "$attract_dir/scraper/Handhelds/overview/$fullname.txt" ]]; then
                    cat >>"$config" <<_EOF_
${tab}
display${tab}$fullname
${tab}layout               HP2-Systems-Menu
${tab}romlist              $fullname
${tab}in_cycle             no
${tab}in_menu              no
${tab}global_filter
${tab}${tab}rule                 FileIsAvailable equals 1
${tab}filter               All
${tab}filter               Favourites
${tab}${tab}rule                 Favourite equals 1
${tab}filter               "Most Played Games"
${tab}${tab}sort_by              PlayedCount
${tab}${tab}reverse_order        true
${tab}${tab}rule                 PlayedCount not_contains 0
${tab}
_EOF_
              local config="$attract_dir/romlists/Handhelds.txt"

              # remove extension
              path="${path/%.*}"

              if [[ ! -f "$config" ]]; then
                  echo "#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons" >"$config"
              fi

              # if the entry already exists, remove it
              if grep -q "^$path;" "$config"; then
                  sed -i "/^$path/d" "$config"
              fi

              echo "$fullname;$fullname;@;;;;;;;;;;;;;;" >>"$config"

      else
          cat >>"$config" <<_EOF_
${tab}
display${tab}$fullname
${tab}layout               HP2-Systems-Menu
${tab}romlist              $fullname
${tab}in_cycle             no
${tab}in_menu              no
${tab}global_filter
${tab}${tab}rule                 FileIsAvailable equals 1
${tab}filter               All
${tab}filter               Favourites
${tab}${tab}rule                 Favourite equals 1
${tab}filter               "Most Played Games"
${tab}${tab}sort_by              PlayedCount
${tab}${tab}reverse_order        true
${tab}${tab}rule                 PlayedCount not_contains 0
${tab}
_EOF_
            local config="$attract_dir/romlists/Misc.txt"

            # remove extension
            path="${path/%.*}"

            if [[ ! -f "$config" ]]; then
                echo "#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons" >"$config"
            fi

            # if the entry already exists, remove it
            if grep -q "^$path;" "$config"; then
                sed -i "/^$path/d" "$config"
            fi

echo "$fullname;$fullname;@;;;;;;;;;;;;;;" >>"$config"

        fi
        chown $user:$user "$config"
    fi
}


function _del_system_attractmode() {
    local attract_dir="$(_get_configdir_attractmode)"
    [[ ! -d "$attract_dir" ]] && return 0
    local fullname="$1"
    local name="$2"

    rm -rf "$attract_dir/romlists/$fullname.txt"

    local tab=$'\t'
    # remove display block from "^display$tab$fullname" to next "^display" or empty line keeping the next display line
    sed -i "/^display$tab$fullname/,/^display\|^$/{/^display$tab$fullname/d;/^display\$/!d}" "$attract_dir/attract.cfg"
}

function _add_rom_attractmode() {
    local attract_dir="$(_get_configdir_attractmode)"
    [[ ! -d "$attract_dir" ]] && return 0

    local system_name="$1"
    local system_fullname="$2"
    local path="$3"
    local name="$4"
    local desc="$5"
    local image="$6"

    local config="$attract_dir/romlists/$system_fullname.txt"

    # remove extension
    path="${path/%.*}"

    if [[ ! -f "$config" ]]; then
        echo "#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons" >"$config"
    fi

    # if the entry already exists, remove it
    if grep -q "^$path;" "$config"; then
        sed -i "/^$path/d" "$config"
    fi

    echo "$path;$name;$system_fullname;;;;;;;;;;;;;;" >>"$config"
    chown $user:$user "$config"
}

function depends_attractmode() {
    local depends=(
        cmake libflac-dev libogg-dev libvorbis-dev libopenal-dev libfreetype6-dev
        libudev-dev libjpeg-dev libudev-dev libavutil-dev libavcodec-dev
        libavformat-dev libavfilter-dev libswscale-dev libavresample-dev
        libfontconfig1-dev
    )
    isPlatform "rpi" && depends+=(libraspberrypi-dev)
    isPlatform "x11" && depends+=(libsfml-dev)
    getDepends "${depends[@]}"
}

function sources_attractmode() {
    isPlatform "rpi" && gitPullOrClone "$md_build/sfml-pi" "https://github.com/mickelson/sfml-pi"
    gitPullOrClone "$md_build/attract" "https://github.com/mickelson/attract.git"
}

function build_attractmode() {
    if isPlatform "rpi"; then
        cd sfml-pi
        cmake . -DCMAKE_INSTALL_PREFIX="$md_inst/sfml" -DSFML_RPI=1 -DEGL_INCLUDE_DIR=/opt/vc/include -DEGL_LIBRARY=/opt/vc/lib/libbrcmEGL.so -DGLES_INCLUDE_DIR=/opt/vc/include -DGLES_LIBRARY=/opt/vc/lib/libbrcmGLESv2.so
        make clean
        make
        cd ..
    fi
    cd attract
    make clean
    local params=(prefix="$md_inst")
    isPlatform "rpi" && params+=(USE_GLES=1 EXTRA_CFLAGS="$CFLAGS -I$md_build/sfml-pi/include -L$md_build/sfml-pi/lib")
    make "${params[@]}"
    make install

    # remove example configs
    rm -rf "$md_build/attract/config/emulators/"*

    md_ret_require="$md_build/attract/attract"
}

function install_attractmode() {
    make -C sfml-pi install
    mkdir -p "$md_inst"/{bin,share,share/attract}
    cp -v attract/attract "$md_inst/bin/"
    cp -Rv attract/config/* "$md_inst/share/attract"
    #cd attract
    #make install
}

#function remove_attractmode() {
    #rm -f /usr/bin/attract
#}

function configure_attractmode() {

  [[ ! -d "$attract_dir/.git" ]] && rm -rf "$attract_dir"
  gitPullOrClone "$home/.attract" https://github.com/Johnstonevo/config.git
  #cp -r  "$__builddir/.attract"  /home/$user/
  chown -R $user:$user $home/.attract
    #moveConfigDir "$home/.attract" "$md_conf_root/all/attractmode"

    #[[ "$md_mode" == "remove" ]] && return

    local config="$home/.attract/attract.cfg"
    if [[ ! -f "$config" ]]; then
        echo "general" >"$config"
        echo -e "\twindow_mode          fullscreen" >>"$config"
    fi

    #mkUserDir "$md_conf_root/all/attractmode/emulators"
    cat >/usr/bin/attract <<_EOF_


#!/bin/bash
LD_LIBRARY_PATH="$md_inst/sfml/lib" "$md_inst/bin/attract" "\$@"
_EOF_
    chmod +x "/usr/bin/attract"

    local idx
    for idx in "${__mod_idx[@]}"; do
        if rp_isInstalled "$idx" && [[ -n "${__mod_section[$idx]}" ]] && ! hasFlag "${__mod_flags[$idx]}" "frontend"; then
            rp_callModule "$idx" configure
        fi
    done
}
