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

announce(){
    echo "======================================"
    echo "$1"
    echo "======================================"
}

announce "Setup" && . $COMMONDIR/setup.sh && echo "OK"
announce "Configure Target" && $TARGETDIR/target.sh && echo "OK"
announce "Load Target" && $EXE $WORKDIR/flash.jlink && echo "OK"
announce "Finished"
