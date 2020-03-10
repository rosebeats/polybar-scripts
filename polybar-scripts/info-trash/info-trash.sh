#!/bin/sh

case "$1" in
    --clean)
        rm -rf ~/.local/share/Trash/files
        rm -rf ~/.local/share/Trash/info
        mkdir ~/.local/share/Trash/files
        mkdir ~/.local/share/Trash/info
        ;;
    *)
        files=$(find ~/.local/share/Trash/files/ -mindepth 1 | wc -l)
        if [ $files -ne 0 ]; then
            echo  $files
        else
            echo ""
        fi
        ;;
esac
