#!/bin/sh
set -e
JLINKDIR=JLinkOSX
PROG=$JLINKDIR/JLinkExe
BINDIR="$PWD/temp"

announce(){
    echo "======================================"
    echo "$1"
    echo "======================================"
}

. announce "Setup" && ./common/setup.sh
. announce "Load Target" && ./targets/$1 || echo "Please supply a valid target!"

