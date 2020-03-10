#!/bin/sh

devices=$(lsblk -Jplno NAME,TYPE,RM,SIZE,MOUNTPOINT,VENDOR,LABEL,MODEL)

case "$1" in
    --mount)
        for mount in $(echo "$devices" | jq -r '.blockdevices[]  | select(.type == "part") | select(.rm == true) | select(.mountpoint == null) | .name'); do
            udisksctl mount --no-user-interaction -b "$mount"

            # mountpoint=$(udisksctl mount --no-user-interaction -b $mount)
            # mountpoint=$(echo $mountpoint | cut -d " " -f 4 | tr -d ".")
            # terminal -e "bash -lc 'filemanager $mountpoint'" &
        done
        ;;
    --unmount)
        for unmount in $(echo "$devices" | jq -r '.blockdevices[]  | select(.type == "part") | select(.rm == true) | select(.mountpoint != null) | .name'); do
            udisksctl unmount --no-user-interaction -b "$unmount"
            udisksctl power-off --no-user-interaction -b "$unmount"
        done
        ;;
    *)
        output=""
        counter=0

        for unmounted in $(echo "$devices" | jq -r '.blockdevices[]  | select(.type == "part") | select(.rm == true) | select(.mountpoint == null) | .name'); do
            unmounted1=$(echo "$devices" | jq -r '.blockdevices[]  | select(.name == "'"$unmounted"'") | .label')
	    if [ $unmounted1 = 'null' ]
            then
                unmounted=$(echo "$unmounted" | tr -d "[:digit:]")
                unmounted1=$(echo "$devices" | jq -r '.blockdevices[]  | select(.name == "'"$unmounted"'") | .model')
	    fi
            unmounted=$(echo "$unmounted1" | tr -d ' ')

            if [ $counter -eq 0 ]; then
                space=""
            else
                space="   "
            fi
            counter=$((counter + 1))

            output="$output$space  $unmounted"
        done

        for mounted in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint != null) | .size'); do
            if [ $counter -eq 0 ]; then
                space=""
            else
                space="   "
            fi
            counter=$((counter + 1))

            output="$output$spaceﱮ $mounted"
        done

        echo "$output"
        ;;
esac
