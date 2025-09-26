const std = @import("std");
const base62 = @import("../src/base62.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("Base62 Library Usage Examples\n", .{});
    std.debug.print("==============================\n\n", .{});

    // Example 1: Basic integer encoding/decoding
    std.debug.print("1. Integer Encoding/Decoding:\n", .{});
    const values = [_]u64{ 0, 123, 456789, 18446744073709551615 }; // Last is max u64

    for (values) |value| {
        const encoded = try base62.encodeInt(value, allocator);
        defer allocator.free(encoded);

        const decoded = try base62.decodeInt(encoded);
        std.debug.print("   {} -> '{s}' -> {}\n", .{ value, encoded, decoded });
    }

    std.debug.print("\n", .{});

    // Example 2: Custom alphabet
    std.debug.print("2. Custom Alphabet:\n", .{});
    const custom_config = try base62.Base62Config.init("abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ");

    const test_value: u64 = 12345;
    const default_encoded = try base62.encodeInt(test_value, allocator);
    defer allocator.free(default_encoded);

    const custom_encoded = try base62.encodeIntWithConfig(test_value, custom_config, allocator);
    defer allocator.free(custom_encoded);

    std.debug.print("   Value: {}\n", .{test_value});
    std.debug.print("   Default alphabet: '{s}'\n", .{default_encoded});
    std.debug.print("   Custom alphabet:  '{s}'\n", .{custom_encoded});

    std.debug.print("\n", .{});

    // Example 3: Byte array encoding
    std.debug.print("3. Byte Array Encoding:\n", .{});
    const test_strings = [_][]const u8{ "Hello", "World", "Base62!" };

    for (test_strings) |test_str| {
        const encoded_bytes = try base62.encodeBytes(test_str, allocator);
        defer allocator.free(encoded_bytes);

        const decoded_bytes = try base62.decodeBytes(encoded_bytes, allocator);
        defer allocator.free(decoded_bytes);

        std.debug.print("   '{s}' -> '{s}' -> '{s}'\n", .{ test_str, encoded_bytes, decoded_bytes });
    }

    std.debug.print("\n", .{});

    // Example 4: Key generation use case
    std.debug.print("4. Key Generation Example:\n", .{});
    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();

    for (0..5) |i| {
        _ = i;
        const random_id = rand.int(u64);
        const key = try base62.encodeInt(random_id, allocator);
        defer allocator.free(key);

        std.debug.print("   Random Key: '{s}' (from {})\n", .{ key, random_id });
    }

    std.debug.print("\nBase62 library successfully demonstrated!\n", .{});
}