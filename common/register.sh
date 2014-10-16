#!/bin/sh
set -e
echo "Uploading factory file"
get_id(){
    xxd -s 0x60 -l 8 -g 8 -u -ps $1
}
chmod 600 $DEVICE_INFO_IMG
if [ -s $DEVICE_INFO_IMG ]; then
    mv -f $DEVICE_INFO_IMG $REGISTRATIONDIR/$(get_id $DEVICE_INFO_IMG)
else
    echo "Removing empty info"
    rm -f $DEVICE_INFO_IMG
    return 1
fi
