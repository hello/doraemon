#!/bin/sh
set -e
mkbindir(){
    if [ ! -d "$BINDIR" ]; then
        mkdir "$BINDIR" && echo "Created $BINDIR"
    fi
}

mkbindir()



