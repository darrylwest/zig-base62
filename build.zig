const std = @import("std");

pub fn build(b: *std.Build) void {
    // Module for use in other projects
    _ = b.addModule("base62", .{
        .root_source_file = b.path("src/base62.zig"),
    });

    // Tests - simplified for compatibility
    const test_step = b.step("test", "Run unit tests");
    const test_cmd = b.addSystemCommand(&[_][]const u8{ "zig", "test", "src/base62.zig" });
    test_step.dependOn(&test_cmd.step);
}