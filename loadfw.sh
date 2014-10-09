#!/bin/sh
set -e
JLINKDIR=JLinkOSX
PROG=$JLINKDIR/JLinkExe
BINDIR="$PWD/temp"
COMMONDIR="$PWD/common"

announce(){
    echo "======================================"
    echo "$1"
    echo "======================================"
}

announce "Setup" && . $COMMONDIR/setup.sh
announce "Load Target" && ./targets/$1 || echo "Please supply a valid target!"
announce "Finished"
