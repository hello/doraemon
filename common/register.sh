#!/bin/sh
set -e
echo "Uploading factory file"
key="nordic_key_public.pem"
get_id(){
    xxd -s 0x60 -l 8 -g 8 -u -ps $1
}
chmod 600 $DEVICE_INFO_IMG
if [ -s $DEVICE_INFO_IMG ]; then
    fname=$(get_id $DEVICE_INFO_IMG)
    encfname="$REGISTRATIONDIR/${fname}.encrypted"
    $COMMONDIR/encrypt.sh "$DEVICE_INFO_IMG" "$encfname" "$COMMONDIR/$key" \
        && rm -f "$DEVICE_INFO_IMG"
else
    echo "Removing empty info"
    rm -f $DEVICE_INFO_IMG
    return 1
fi
