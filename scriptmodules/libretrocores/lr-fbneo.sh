

    local def=1
    isPlatform "armv6" && def=0
    addEmulator $def "$md_id" "arcade" "$md_inst/fbneo_libretro.so"
    addEmulator $def "$md_id-neocdz" "arcade" "$md_inst/fbneo_libretro.so --subsystem neocd"
    addEmulator $def "$md_id" "neogeo" "$md_inst/fbneo_libretro.so"
    addEmulator $def "$md_id-neocdz" "neocdz" "$md_inst/fbneo_libretro.so --subsystem neocd"
    addEmulator $def "$md_id" "fba" "$md_inst/fbneo_libretro.so"
    addEmulator $def "$md_id-neocdz" "fba" "$md_inst/fbneo_libretro.so --subsystem neocd"

    addEmulator 0 "$md_id-pce" "pcengine" "$md_inst/fbneo_libretro.so --subsystem pce"
    addEmulator 0 "$md_id-sgx" "pcengine" "$md_inst/fbneo_libretro.so --subsystem sgx"
    addEmulator 0 "$md_id-tg" "pcengine" "$md_inst/fbneo_libretro.so --subsystem tg"
    addEmulator 0 "$md_id-gg" "gamegear" "$md_inst/fbneo_libretro.so --subsystem gg"
    addEmulator 0 "$md_id-sms" "mastersystem" "$md_inst/fbneo_libretro.so --subsystem sms"
    addEmulator 0 "$md_id-md" "megadrive" "$md_inst/fbneo_libretro.so --subsystem md"
    addEmulator 0 "$md_id-md" "megadrive-japan" "$md_inst/fbneo_libretro.so --subsystem md"
    addEmulator 0 "$md_id-sg1k" "sg-1000" "$md_inst/fbneo_libretro.so --subsystem sg1k"
    addEmulator 0 "$md_id-cv" "coleco" "$md_inst/fbneo_libretro.so --subsystem cv"
    addEmulator 0 "$md_id-msx" "msx" "$md_inst/fbneo_libretro.so --subsystem msx"
    addEmulator 0 "$md_id-spec" "zxspectrum" "$md_inst/fbneo_libretro.so --subsystem spec"

    addSystem "arcade"
    addSystem "neogeo"
    addSystem "fba"

    addSystem "pcengine"
    addSystem "gamegear"
    addSystem "mastersystem"
    addSystem "megadrive"
    addSystem "megadrive-japan"
    addSystem "sg-1000"
    addSystem "coleco"
    addSystem "msx"
    addSystem "zxspectrum"
    addBezel "fba"

if [ -e $md_instppa/fbneo_libretro.so ]
    then
        addEmulator 0 "$md_id-ppa" "arcade" "$md_instppa/fbneo_libretro.so"
        addEmulator 0 "$md_id-ppa-neocdz" "arcade" "$md_instppa/fbneo_libretro.so --subsystem neocd"
        addEmulator 0 "$md_id-ppa" "neogeo" "$md_instppa/fbneo_libretro.so"
        addEmulator 0 "$md_id-ppa-neocdz" "neocdz" "$md_instppa/fbneo_libretro.so --subsystem neocd"
        addEmulator 0 "$md_id-ppa" "fba" "$md_instppa/fbneo_libretro.so"
        addEmulator 0 "$md_id-ppa-neocdz" "fba" "$md_instppa/fbneo_libretro.so --subsystem neocd"

        addEmulator 0 "$md_id-ppa-pce" "pcengine" "$md_instppa/fbneo_libretro.so --subsystem pce"
        addEmulator 0 "$md_id-ppa-sgx" "pcengine" "$md_instppa/fbneo_libretro.so --subsystem sgx"
        addEmulator 0 "$md_id-ppa-tg" "pcengine" "$md_instppa/fbneo_libretro.so --subsystem tg"
        addEmulator 0 "$md_id-ppa-gg" "gamegear" "$md_instppa/fbneo_libretro.so --subsystem gg"
        addEmulator 0 "$md_id-ppa-sms" "mastersystem" "$md_instppa/fbneo_libretro.so --subsystem sms"
        addEmulator 0 "$md_id-ppa-md" "megadrive" "$md_instppa/fbneo_libretro.so --subsystem md"
        addEmulator 0 "$md_id-ppa-sg1k" "sg-1000" "$md_instppa/fbneo_libretro.so --subsystem sg1k"
        addEmulator 0 "$md_id-md" "megadrive-japan" "$md_inst/fbneo_libretro.so --subsystem md"


fi


if [  -d $raconfigdir/overlay/ArcadeBezels ]
 then
    cp /home/$user/.config/RetroPie/fba/retroarch.cfg /home/$user/.config/RetroPie/fba/retroarch.cfg.bkp
    local core_config="$configdir/fba/retroarch.cfg"
     iniConfig " = " '"' "$md_conf_root/fba/retroarch.cfg"

    iniSet "input_overlay"  "$raconfigdir/overlay/MAME-Horizontal.cfg"
    iniSet "input_overlay_opacity" "1.0"
    iniSet "fbneo-diagnostic-input" "Hold Start"
    chown $user:$user "$core_config"
fi

}
