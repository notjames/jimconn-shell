!#/usr/bin/bash

addr=$(hcitool scan | grep 'Microsoft Sculpt Comfort Mouse' | awk '{print $1}')

if [ -n "$addr" ]
then
    bluez-simple-agent hci0 $addr
    bluez-test-device trusted $addr
    bluez-test-input connect $addr
fi
