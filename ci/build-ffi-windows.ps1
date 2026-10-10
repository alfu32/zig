$ErrorActionPreference = "Stop"
$zigVersion = "0.15.2"
$toolDir = Join-Path $env:RUNNER_TEMP "zig-$zigVersion"
$archive = Join-Path $env:RUNNER_TEMP "zig-$zigVersion.zip"
$url = "https://ziglang.org/download/$zigVersion/zig-x86_64-windows-$zigVersion.zip"

Invoke-WebRequest -Uri $url -OutFile $archive
Expand-Archive -Path $archive -DestinationPath $toolDir -Force
$zig = (Get-ChildItem -Path $toolDir -Filter "zig.exe" -Recurse | Select-Object -First 1).FullName
if (!$zig) { throw "Zig bootstrap compiler was not found in the downloaded archive" }
if ((& $zig version) -ne $zigVersion) { throw "Unexpected Zig bootstrap compiler version" }

& $zig build install `
  -Dshared-cli `
  -Dtarget=x86_64-windows-gnu `
  -Doptimize=ReleaseFast `
  -Dforce-link-libc `
  -Dversion-string=0.15.2-ffi.0 `
  --prefix dist
if ($LASTEXITCODE -ne 0) { throw "Zig FFI build failed with exit code $LASTEXITCODE" }

$dll = Get-ChildItem -Path dist -Filter "zig.dll" -Recurse | Select-Object -First 1
if (!$dll) { throw "FFI DLL was not produced" }
if (!(Test-Path "dist\zig_cli.h")) { throw "FFI header was not installed" }
