#!/bin/bash

#  Build.sh
#  restkit-bind
#
#  Created by Federico Gasperini on 25/01/16.
#  Copyright © 2016 Accenture. All rights reserved.

echo $(pwd)
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null
echo $(SCRIPTPATH)

if [ -z "$PROJECT_DIR" ]; then
   echo "No PROJECT_DIR setting to $(pwd)"
   PROJECT_DIR="$(pwd)"
fi

if [ $# -eq 0 ]; then
#   FILES="${PROJECT_DIR}/restkit-bind/def*"
    FILES=$(find . -type f -name "def-*")
fi

echo $PROJECT_DIR
echo $FILES

HEADER="${PROJECT_DIR}"/common/IKCommon.h
rm "$HEADER"
echo "#ifndef __ALL_HEADERS__" > "$HEADER"
echo "#define __ALL_HEADERS__" >> "$HEADER"
echo "@import MobileCoreServices;" >> "$HEADER"
echo "@import SystemConfiguration;" >> "$HEADER"
echo "#import <MRBackEnd/IKEnvironment.h>" >> "$HEADER"
echo "#import <MRRestKit/IKObjectManager.h>" >> "$HEADER"

OIFS="$IFS"
IFS=$'\n'

pids=()

cp -R "${PROJECT_DIR}"/restkit-bind.xcodeproj "${PROJECT_DIR}"/restkit-bind-tmp.xcodeproj

for conf in $FILES
do
   basename=${conf##*/}
   name=${basename%.*}
   groupName=${name##*-}
   "$SCRIPTPATH"/rest_builder -o "$groupName" -p "${PROJECT_DIR}"/restkit-bind-tmp.xcodeproj -T restkit-bind-lib "$conf" &
   pids+=("$!")
   echo "#import \"IKCommon-${groupName}.h\"" >> "$HEADER"
   echo "#import \"IKRequest+${groupName}.h\"" >> "$HEADER"
   sleep 1
done
IFS="$OIFS"

echo "#endif" >> "$HEADER"

for pid in ${pids[*]};
do
   wait $pid;
done

cp "${PROJECT_DIR}"/restkit-bind-tmp.xcodeproj/project.pbxproj "${PROJECT_DIR}"/restkit-bind.xcodeproj/project.pbxproj
rm -rf "${PROJECT_DIR}"/restkit-bind-tmp.xcodeproj

echo "DONE"
