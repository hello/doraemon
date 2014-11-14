#!/bin/sh
set -e
JLINKDIR=JLinkOSX
PROG=$JLINKDIR/JLinkExe.command
PROGOPTS="-device nrf51422 -if swd -speed 4000"
COMMONDIR="$PWD/common"

export WORKDIR="$PWD/temp"
export SOFTDEVICEDIR="$PWD/SoftDevice"
export EXE="$PROG $PROGOPTS"
export TARGETDIR="$PWD/targets/$1"
export REGISTRATIONROOT="$PWD/devices"
export REGISTRATIONDIR="$REGISTRATIONROOT/$1"
export DEVICE_INFO_IMG="$WORKDIR/device.info"

announce(){
    echo "======================================"
    echo "            $1                  "
    echo "======================================"
}
fail(){
    echo "======================================"
    echo "======================================"
    echo "=                                    ="
    echo "=                                    ="
    echo "=              FAIL                  ="
    echo "=                                    ="
    echo "=                                    ="
    echo "=                                    ="
    echo "======================================"
    echo "======================================"
    return 1
}

pass(){
    echo "======================================"
    echo "======================================"
    echo "=                                    ="
    echo "=                                    ="
    echo "=              PASS                  ="
    echo "=                                    ="
    echo "=                                    ="
    echo "=                                    ="
    echo "======================================"
    echo "======================================"
    return 0
}


clear
(announce "Setup" && . $COMMONDIR/setup.sh && announce "OK") || fail
clear
(announce "Configure Target" && $TARGETDIR/target.sh && announce "OK") || fail
clear
(announce "Load Target" && $EXE $WORKDIR/flash.jlink && announce "OK")
clear
(announce "Post Load Script" && $COMMONDIR/register.sh && pass) || fail
