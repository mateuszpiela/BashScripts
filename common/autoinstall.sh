#!/bin/bash

SOURCE_DIR="$PWD/bin"
TARGET_DIR="/usr/bin"
PRIORITY=0

for exefile in  $(ls "$SOURCE_DIR"/)
do
  echo "Installing now $exefile..."
  update-alternatives --install $TARGET_DIR/$exefile $exefile $SOURCE_DIR/$exefile $PRIORITY
done
