#!/bin/bash

destDir="$1"
shift

distributeFile() {
    local srcDir="$1"
    local destDir="$2"
    local modifier="$3"

    mkdir -p "$destDir"
    for file in "$srcDir/"*"$modifier".png ; do
        basename=`basename $file`
        mv "$file" "$destDir/${basename/$modifier/}"
    done
}

generateForASketch() {
    local srcFile="$1"

    local destDirForASketch="$destDir/$srcFile"

    mkdir -p "$destDirForASketch"
    sketchtool export slices "$srcFile" --output="$destDirForASketch"

    distributeFile "$destDirForASketch" "$destDir/android/xxhdpi" "@3x"
    distributeFile "$destDirForASketch" "$destDir/android/xhdpi" "@2x"
    distributeFile "$destDirForASketch" "$destDir/android/hdpi" "@1.5x"
    distributeFile "$destDirForASketch" "$destDir/android/mdpi" ""

    (cd $destDir/android; zip android.zip -r *dpi)
}

generateForASketch icons.sketch
