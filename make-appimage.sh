#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q gram-bin | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/app.liten.Gram.svg
export DESKTOP=/usr/share/applications/app.liten.Gram.desktop
export DEPLOY_VULKAN=1
export URUNTIME_PRELOAD=1
export GRAM_ALLOW_ROOT=true

# Deploy dependencies
quick-sharun /opt/gram/*/*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
