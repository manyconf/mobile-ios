#!/bin/bash

default="whitelabel"

if [ "$1" == "" ]; then
    theme="$default"
else
    theme="$1"
fi

src_dir="../../mobile-assets/${theme}"

# Image sizes as defined by Apple
app_icon="app_icon.png"
app_icon_sizes="180 120 152 76"
spotlight_icon_sizes="29 58"
settings_icon_sizes="40 80 120"
app_store_icons="512 1024"
launch_icons="640x1136 640x960 320x480 1536x2008 768x1004"
spotlight_icons="80 40"

for i in $app_icon_sizes $settings_icon_sizes $spotlight_icon_sizes; do
    echo "Resizing $app_icon to $i x $i"
    convert -resize $i $src_dir/$app_icon app_icon_${i}.png
done

#for i in $app_icons $app_store_icons $spotlight_icons; do
#    echo "Resizing to $i x $i"
#    convert -resize $i $orig ${new}${i}.png
#done

echo "Done"
