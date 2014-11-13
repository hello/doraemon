#!/bin/sh
set -e
echo "Encrypting"
openssl rsautl -encrypt -in $1 -pubin -inkey $3 -out $2
