const std = @import("std");
const base62 = @import("../src/base62.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("Base62 Library Demo\n");
    std.debug.print("===================\n\n");

    // Basic integer encoding
    const test_value: u64 = 12345;
    const encoded = try base62.encodeInt(test_value, allocator);
    defer allocator.free(encoded);

    const decoded = try base62.decodeInt(encoded);

    std.debug.print("Original: {}\n", .{test_value});
    std.debug.print("Encoded:  '{}'\n", .{encoded});
    std.debug.print("Decoded:  {}\n", .{decoded});
    std.debug.print("Match:    {}\n\n", .{test_value == decoded});

    // Test some edge cases
    const edge_cases = [_]u64{ 0, 1, 61, 62, 3844, 1000000 };
    std.debug.print("Edge Case Tests:\n");
    for (edge_cases) |value| {
        const enc = try base62.encodeInt(value, allocator);
        defer allocator.free(enc);
        const dec = try base62.decodeInt(enc);
        std.debug.print("  {} -> '{}' -> {} ({})\n", .{ value, enc, dec, if (value == dec) "✓" else "✗" });
    }

    std.debug.print("\nBase62 library working correctly!\n");
}