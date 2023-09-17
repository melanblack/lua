#!/usr/bin/env bash

# Package the built binaries into a zip file
VERSION=$(cat VERSION)

export PACKAGE_NAME="lua${VERSION}.zip"

# Remove the old package
if [ -f "$PACKAGE_NAME" ]; then
	rm -f "$PACKAGE_NAME"
fi

# Create a new package
zip -rq "$PACKAGE_NAME" src/lua.exe src/luac.exe src/lua54.dll src/liblua.a src/lua.h src/lua.hpp LICENSE

