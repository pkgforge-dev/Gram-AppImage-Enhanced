#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm libmd libbsd

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
# make-aur-package

# If the application needs to be manually built that has to be done down here

LATEST_BIN=$(
	wget --retry-connrefused --tries=30 https://codeberg.org/api/v1/repos/GramEditor/gram/releases -O - \
	  | sed 's/[()",{} ]/\n/g' | grep -oi -m 1 "https.*/gram-linux-$ARCH.*.gz$"
)

wget --retry-connrefused --tries=30 "$LATEST_BIN"
tar xfv ./gram-linux*.gz
rm -f ./gram-linux*.gz

echo "$LATEST_BIN" | awk -F'/' '{print $(NF-1)}' > ~/version
