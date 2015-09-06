#!/usr/bin/env bash

deviceid="DC033DFD-A918-4A18-B390-3C1822E37498"


basedir="/tmp/JPSimulatorHacksDiff"
olddir=$(ls -1dt $basedir/* | head -n1)
newdir="$basedir/$(date +%s)"
mkdir -p $newdir

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for plist in $(find ~/Library/Developer/CoreSimulator/Devices/$deviceid -name "*.plist"); do
    dirname=$(dirname $plist)
    mkdir -p $newdir/$dirname
    plutil -convert xml1 -o - $plist | xmllint -format - > $newdir/$plist.xml
    if [ $? -ne 0 ]; then
        echo "Processing $plist failed"
    fi
done

IFS=$SAVEIFS

diff -Nuarbwr $olddir $newdir
