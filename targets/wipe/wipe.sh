#!/bin/sh
set -e

if [ -f "$WORKDIR/wipe.jlink" ]; then
    echo "file exists"
else
    echo "w4 4001e504 2 \n w4 4001e50c 1 \n sleep 50 \n r \n q \n" > $WORKDIR/wipe.jlink
fi

$EXE $WORKDIR/wipe.jlink
