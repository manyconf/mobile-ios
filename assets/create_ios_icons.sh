#!/bin/sh

orig="../../assets/apps/logo/logo_white_on_blue.png"
new="manyconf_"

# Taken from Xcode
app_icons="120 152 76"
app_store_icons="512 1024"
launch_icons="640x1136 640x960 320x480 1536x2008 768x1004"
spotlight_icons="80 40"

for i in $app_icons $app_store_icons $spotlight_icons; do
    echo "Resizing to $i x $i"
    convert -resize $i $orig ${new}${i}.png
done

echo "Done"
