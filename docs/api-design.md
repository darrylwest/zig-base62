# Base62 Library API Design

## Core Functions

### Encoding Functions

```zig
// Encode a u64 integer to base62 string
pub fn encodeInt(value: u64, allocator: std.mem.Allocator) ![]u8

// Encode a byte array to base62 string
pub fn encodeBytes(data: []const u8, allocator: std.mem.Allocator) ![]u8
```

### Decoding Functions

```zig
// Decode base62 string to u64 integer
pub fn decodeInt(encoded: []const u8) !u64

// Decode base62 string to byte array
pub fn decodeBytes(encoded: []const u8, allocator: std.mem.Allocator) ![]u8
```

## Configuration Support

### Custom Alphabet

```zig
pub const Base62Config = struct {
    alphabet: []const u8 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",

    pub fn validate(self: Base62Config) !void {
        // Validate alphabet is exactly 62 unique characters
    }
};

// Encode with custom alphabet
pub fn encodeIntWithConfig(value: u64, config: Base62Config, allocator: std.mem.Allocator) ![]u8
pub fn encodeBytesWithConfig(data: []const u8, config: Base62Config, allocator: std.mem.Allocator) ![]u8

// Decode with custom alphabet
pub fn decodeIntWithConfig(encoded: []const u8, config: Base62Config) !u64
pub fn decodeBytesWithConfig(encoded: []const u8, config: Base62Config, allocator: std.mem.Allocator) ![]u8
```

## Error Handling

```zig
pub const Base62Error = error{
    InvalidCharacter,
    InvalidAlphabet,
    Overflow,
    OutOfMemory,
};
```

## Usage Examples

```zig
const std = @import("std");
const base62 = @import("base62");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Basic encoding/decoding
    const value: u64 = 123456;
    const encoded = try base62.encodeInt(value, allocator);
    defer allocator.free(encoded);

    const decoded = try base62.decodeInt(encoded);
    // decoded == 123456

    // Custom alphabet
    const config = base62.Base62Config{
        .alphabet = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    };

    const custom_encoded = try base62.encodeIntWithConfig(value, config, allocator);
    defer allocator.free(custom_encoded);
}
```

## Key Design Decisions

1. **Memory Management**: All functions that return strings require an allocator and caller owns the memory
2. **Error Handling**: Uses Zig's error unions for robust error handling
3. **Flexibility**: Support both integer and byte array encoding/decoding
4. **Configuration**: Optional custom alphabet support while defaulting to standard base62
5. **Performance**: Direct integer encoding for common use cases, byte array support for arbitrary data