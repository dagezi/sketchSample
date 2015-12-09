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

generateIndex() {
    cat > index.html <<EOF
<html><head><title>Icons</title>
<style>
img { margin: 4px; }
</style>
</head>
<body>
<a href="android.zip">zipped file</a>

<h1>Icons</h1>
EOF

    find . -name '*.png' | sed 's,.*,<img title="&" src="&" >,' >> index.html

    cat >> index.html <<EOF
</body></html>
EOF
}


generateForASketch icons.sketch
generateIndex
