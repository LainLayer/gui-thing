nim c --nimcache:here --define:PlatformDesktop -d:release --mm:orc -d:danger -d:lto --opt:speed --run --passC:"-march=native" demo.nim
