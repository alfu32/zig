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

QEMU_DIR="$HOME/deps/qemu-linux-x86_64-10.0.2/bin"
QEMU_BIN="$(command -v qemu-x86_64 || command -v qemu-x86_64-static || true)"
if [ -z "$QEMU_BIN" ]; then
  echo "qemu-user-static did not install qemu-x86_64-static" >&2
  exit 1
fi
mkdir -p "$QEMU_DIR"
ln -sf "$QEMU_BIN" "$QEMU_DIR/qemu-x86_64"

"$WASMTIME_DIR/wasmtime" --version
"$QEMU_DIR/qemu-x86_64" --version
