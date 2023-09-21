#!/usr/bin/env bash
# -*- coding: utf-8 -*-

function make_pkg () {
	PLATFORM=$1
	VERSION=$2
	NAME="lua${VERSION}.${PLATFORM}.zip"
	rm -rf dist
	# Create a new package
	mkdir dist
	cp -r bin/"${PLATFORM}"/* dist
	cd dist
	zip -rq "$NAME" . "src/lua.h" "src/lua.hpp" "LICENSE" "README.MD" || exit 1
	cd ..
	mv dist/"$NAME" .
}


PLATFORMS=$(cat PLATFORMS)
VERSION=$(cat VERSION)

# clean
make clean
rm -rf bin dist

# build for each platform
export COMP=""
for PLATFORM in $PLATFORMS; do
	if [[ "${PLATFORM}" == "mingw" ]]; then
		make clean
		COMP=$(which x86_64-w64-mingw32-gcc)
		make mingw -j || exit 1
		mkdir -p bin/mingw
		cp src/lua.exe src/luac.exe src/lua54.dll src/liblua.a bin/mingw
		make_pkg mingw "$VERSION"
		echo "mingw done"
	elif [[ "${PLATFORM}" == "linux" ]]; then
		make clean
		COMP=$(which gcc)
		make -j || exit 1
		mkdir -p bin/linux
		cp src/lua src/luac src/liblua.a bin/linux
		make_pkg linux "$VERSION"
		echo "linux done"
	elif [[ "${PLATFORM}" == "macos" ]]; then
		make clean
		COMP=$(which clang)
		make macos -j || exit 1
		mkdir -p bin/macos
		cp src/lua src/luac src/liblua.a bin/macos
		make_pkg macos "$VERSION"
		echo "macos done"
	else
		echo "Unknown platform: ${PLATFORM}"
		exit 1
	fi
done
