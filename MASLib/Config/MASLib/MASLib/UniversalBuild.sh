#!/bin/sh

#  UniversalBuild.sh
#  MASLib
#
#  Created by Federico Gasperini on 20/03/18.
#  Copyright © 2018 Accenture - MAS. All rights reserved.

# define output folder environment variable
UNIVERSAL_OUTPUTFOLDER_DEBUG=${CLIENT_PRJ_FOLDER}/MASLib/Debug
UNIVERSAL_OUTPUTFOLDER_RELEASE=${CLIENT_PRJ_FOLDER}/MASLib/Release
UNIVERSAL_OUTPUTFOLDER_HEADER=${CLIENT_PRJ_FOLDER}/MASLib

echo "${UNIVERSAL_OUTPUTFOLDER_DEBUG}"
echo "${UNIVERSAL_OUTPUTFOLDER_RELEASE}"
echo "${UNIVERSAL_OUTPUTFOLDER_HEADER}"

mkdir -p "${UNIVERSAL_OUTPUTFOLDER_DEBUG}"
mkdir -p "${UNIVERSAL_OUTPUTFOLDER_RELEASE}"
mkdir -p "${UNIVERSAL_OUTPUTFOLDER_HEADER}"

# Step 1. Build Device and Simulator versions
xcodebuild -target MASLib ONLY_ACTIVE_ARCH=NO -configuration Debug -sdk iphoneos BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"
xcodebuild -target MASLib -configuration Debug -sdk iphonesimulator -arch x86_64 BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"

# Step 2. Create universal binary file using lipo
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER_DEBUG}/lib${TARGET_NAME}.a" "${BUILD_DIR}/Debug-iphoneos/libMASLib.a" "${BUILD_DIR}/Debug-iphonesimulator/libMASLib.a"

# Step 1. Build Device and Simulator versions
xcodebuild -target MASLib ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphoneos BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"
xcodebuild -target MASLib -configuration Release -sdk iphonesimulator -arch x86_64 BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"

# Step 2. Create universal binary file using lipo
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER_RELEASE}/lib${TARGET_NAME}.a" "${BUILD_DIR}/Release-iphoneos/libMASLib.a" "${BUILD_DIR}/Release-iphonesimulator/libMASLib.a"

# Last touch. copy the header files. Just for convenience
cp -R "${BUILD_DIR}/Release-iphoneos/include" "${UNIVERSAL_OUTPUTFOLDER_HEADER}"
