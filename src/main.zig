const std = @import("std");
const base62 = @import("base62.zig");

const VERSION = "0.2.1";

fn printUsage() void {
    const usage =
        \\base62 - A simple base62 encoder/decoder
        \\
        \\Usage:
        \\  base62 --encode <number>    Encode a number to base62
        \\  base62 --decode <string>    Decode a base62 string to number
        \\  base62 --help               Show this help message
        \\  base62 --version            Show version information
        \\
        \\Examples:
        \\  base62 --encode 123         Encodes 123 to base62
        \\  base62 --decode 1z          Decodes '1z' to a number
        \\
    ;
    std.debug.print("{s}\n", .{usage});
}

fn printVersion() void {
    std.debug.print("base62 version {s}\n", .{VERSION});
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        printUsage();
        std.process.exit(1);
    }

    const command = args[1];

    if (std.mem.eql(u8, command, "--help") or std.mem.eql(u8, command, "-h")) {
        printUsage();
        return;
    }

    if (std.mem.eql(u8, command, "--version") or std.mem.eql(u8, command, "-v")) {
        printVersion();
        return;
    }

    if (args.len < 3) {
        std.debug.print("Error: Missing value argument\n\n", .{});
        printUsage();
        std.process.exit(1);
    }

    const value = args[2];

    if (std.mem.eql(u8, command, "--encode") or std.mem.eql(u8, command, "-e")) {
        // Parse the number and encode it
        const number = std.fmt.parseInt(u64, value, 10) catch |err| {
            std.debug.print("Error: Invalid number '{s}': {}\n", .{ value, err });
            std.process.exit(1);
        };

        const encoded = base62.encodeInt(number, allocator) catch |err| {
            std.debug.print("Error: Failed to encode: {}\n", .{err});
            std.process.exit(1);
        };
        defer allocator.free(encoded);

        std.debug.print("{s}\n", .{encoded});
    } else if (std.mem.eql(u8, command, "--decode") or std.mem.eql(u8, command, "-d")) {
        // Decode the base62 string
        const decoded = base62.decodeInt(value) catch |err| {
            std.debug.print("Error: Failed to decode '{s}': {}\n", .{ value, err });
            std.process.exit(1);
        };

        std.debug.print("{d}\n", .{decoded});
    } else {
        std.debug.print("Error: Unknown command '{s}'\n\n", .{command});
        printUsage();
        std.process.exit(1);
    }
}
