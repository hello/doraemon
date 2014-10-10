#!/bin/sh
set -e
mkbindir(){
    if [ ! -d "$WORKDIR" ]; then
        mkdir "$WORKDIR" && echo "Created $WORKDIR"
    fi
}

git submodule init
git submodule update
mkbindir



