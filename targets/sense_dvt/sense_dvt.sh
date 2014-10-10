#!/bin/sh
SD_MAIN_IMG=s310_nrf51422_1.0.0_softdevice_main.bin
UICR_MAIN_IMG=s310_nrf51422_1.0.0_softdevice_uicr.bin
JLINK_TEMPLATE=app+bootloader.prod.in
BOOTLOADER_IMG="$(basename $(ls $TARGETDIR/bootloader*))"
APP_IMG="$(basename $(ls $TARGETDIR/morpheus*))"
CRC_IMG="$(basename $(ls $TARGETDIR/*.crc))"

cp_to_work(){
    cp -n -v $TARGETDIR/$1 $WORKDIR/$1
}

cp_to_work $SD_MAIN_IMG
cp_to_work $UICR_MAIN_IMG
cp_to_work $APP_IMG
cp_to_work $BOOTLOADER_IMG
cp_to_work $CRC_IMG
sed\
    -e "s,\$SOFTDEVICE_MAIN,$WORKDIR/$SD_MAIN_IMG,g"\
    -e "s,\$SOFTDEVICE_UICR,$WORKDIR/$UICR_MAIN_IMG,g"\
    -e "s,\$APP,$WORKDIR/$APP_IMG,g"\
    -e "s,\$BOOTLOADER,$WORKDIR/$BOOTLOADER_IMG,g"\
    -e "s,\$CRC,$WORKDIR/$CRC_IMG,g"\
    <$TARGETDIR/$JLINK_TEMPLATE > $WORKDIR/flash.jlink


