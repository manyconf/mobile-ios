#!/bin/bash

default="whitelabel"

if [ "$1" == "" ]; then
    theme="$default"
else
    theme="$1"
fi

src_dir="../mobile-assets/${theme}"
icon_target_dir="CN/Images.xcassets/AppIcon.appiconset"

if [ ! -d "$src_dir" ]; then
    echo "Can't find directory $src_dir" >&2
    exit 1
fi

# Image sizes as defined by Apple
app_icon="app_icon.png"
app_icon_sizes="180 120"     # For iPad, add "152 76"
spotlight_icon_sizes="58"    # For iPad 2, add "29"
settings_icon_sizes="80"
app_store_icons="512 1024"
launch_icons="640x1136 640x960 320x480 1536x2008 768x1004"
spotlight_icons="80 40"

if [ ! -f "$src_dir/$app_icon" ]; then
    echo "Can't find file $src_dir/$app_icon" >&2
    exit 1
fi

for i in $app_icon_sizes $settings_icon_sizes $spotlight_icon_sizes; do
    echo "Resizing $app_icon to $i x $i"
    target="${icon_target_dir}/app_icon_${i}.png"
    if [ ! -f "$target" ]; then
        echo "Can't find file $target" >&2
        exit 1
    fi
    convert -resize "$i" "$src_dir/$app_icon" "${target}"
done

theme_src="$src_dir/theme.json"
theme_target="CN/CNTheme.json"
if [ -f "$theme_src" ]; then
    echo "Copying theme JSON"
    cp "$theme_src" "$theme_target"
else
    echo "Can't find file $theme_src" >&2
    exit 1
fi

#for i in $app_icons $app_store_icons $spotlight_icons; do
#    echo "Resizing to $i x $i"
#    convert -resize $i $orig ${new}${i}.png
#done
