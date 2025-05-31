# mavlink-c header Zig Build Integration

Zig build system integration for [mavlink](https://github.com/mavlink/c_library_v2/) 

## Quick Start

1. Add to your project:
```bash
zig fetch --save git+https://github.com/neelsani/mavlink-c
```
2. Add to you build.zig

```zig
const mavlink_c_dep = b.dependency("mavlink_c", .{
    .target = target,
    .optimize = optimize,
});
const lib = mavlink_c_dep.artifact("mavlink");

//then link it to your exe

exe.linkLibrary(lib);
```