const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Configuration options
    const mavlink_dialect = b.option([]const u8, "dialect", "MAVLink dialect (default: common)") orelse "common";
    const mavlink_version = b.option([]const u8, "version", "MAVLink wire protocol version (default: 2.0)") orelse "2.0";
    _ = mavlink_dialect;
    // Create the library
    const mavlink = b.addStaticLibrary(.{
        .name = "mavlink",
        .target = target,
        .optimize = optimize,
    });

    // Create a minimal C source file for the library
    const write_dummy_c = b.addWriteFile("mavlink_dummy.c",
        \\// Minimal source file for MAVLink library
        \\// MAVLink is primarily header-only
        \\void mavlink_dummy_function(void) {
        \\    // This function exists only to create a valid object file
        \\}
        \\
    );

    // Add the dummy source file
    mavlink.addCSourceFile(.{
        .file = write_dummy_c.getDirectory().path(b, "mavlink_dummy.c"),
        .flags = &.{},
    });

    if (std.mem.eql(u8, mavlink_version, "1.0")) {
        if (b.lazyDependency("mavlink-v1", .{})) |dep| {
            mavlink.installHeadersDirectory(dep.path(""), "mavlink", .{});
        }
    } else {
        if (b.lazyDependency("mavlink-v2", .{})) |dep| {
            mavlink.installHeadersDirectory(dep.path(""), "mavlink", .{});
        }
    }
    b.installArtifact(mavlink);
}
