#!/bin/sh
set -eu

ZIG_VERSION=0.15.2
TOOL_DIR="$RUNNER_TEMP/zig-$ZIG_VERSION"
ARCHIVE="$RUNNER_TEMP/zig-$ZIG_VERSION.tar.xz"
URL="https://ziglang.org/download/$ZIG_VERSION/zig-x86_64-linux-$ZIG_VERSION.tar.xz"

mkdir -p "$TOOL_DIR"
curl --fail --location --retry 3 "$URL" --output "$ARCHIVE"
tar -xJf "$ARCHIVE" -C "$TOOL_DIR" --strip-components=1
ZIG="$TOOL_DIR/zig"
test "$("$ZIG" version)" = "$ZIG_VERSION"

"$ZIG" build install \
  -Dshared-cli \
  -Dtarget=x86_64-linux-gnu \
  -Doptimize=ReleaseFast \
  -Dforce-link-libc \
  -Dversion-string=0.15.2-ffi.0 \
  --prefix dist

test -f dist/lib/libzig.so
test -f dist/zig_cli.h
