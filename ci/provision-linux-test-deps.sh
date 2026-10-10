#!/bin/sh

# Install the Linux test runners used by the x86_64 CI scripts.
set -eu

WASMTIME_VERSION=29.0.0
WASMTIME_ARCHIVE="wasmtime-v${WASMTIME_VERSION}-x86_64-linux.tar.xz"
WASMTIME_DIR="$HOME/deps/wasmtime-v${WASMTIME_VERSION}-x86_64-linux"
WASMTIME_URL="https://github.com/bytecodealliance/wasmtime/releases/download/v${WASMTIME_VERSION}/${WASMTIME_ARCHIVE}"

sudo apt-get update
sudo apt-get install --yes qemu-user-static

mkdir -p "$HOME/deps"
if [ ! -x "$WASMTIME_DIR/wasmtime" ]; then
  archive="$(mktemp)"
  trap 'rm -f "$archive"' EXIT HUP INT TERM
  curl --fail --location --retry 3 "$WASMTIME_URL" --output "$archive"
  tar -xJf "$archive" -C "$HOME/deps"
fi

"$WASMTIME_DIR/wasmtime" --version
qemu-x86_64 --version
