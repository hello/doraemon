#!/bin/sh
set -e
mkbindir(){
    if [ ! -d "$WORKDIR" ]; then
        mkdir "$WORKDIR" && echo "Created $WORKDIR"
    fi
}
mkregdir(){
    if [ ! -d "$REGISTRATIONDIR" ]; then
        mkdir "$REGISTRATIONDIR" && echo "Created $REGISTRATIONDIR"
    fi
}

git submodule init
git submodule update
mkbindir
mkregdir


