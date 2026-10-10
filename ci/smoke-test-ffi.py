import ctypes
from pathlib import Path


libraries = list(Path("dist").rglob("libzig.so"))
if not libraries:
    libraries = list(Path("dist").rglob("zig.dll"))
if len(libraries) != 1:
    raise SystemExit(f"expected one FFI library under dist/, found {len(libraries)}")

library = ctypes.CDLL(str(libraries[0]))
zig_cli_main = library.zig_cli_main
zig_cli_main.argtypes = (ctypes.c_int, ctypes.POINTER(ctypes.c_char_p))
zig_cli_main.restype = ctypes.c_int

argv = (ctypes.c_char_p * 2)(b"zig", b"version")
result = zig_cli_main(2, argv)
raise SystemExit(result)
