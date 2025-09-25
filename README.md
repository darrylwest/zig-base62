# Zig Base62 Encode/Decode

A high-performance Base62 encoding/decoding library written in Zig. Perfect for generating short, URL-safe identifiers and keys.

## Features

- **Fast integer encoding/decoding** using optimized algorithms
- **Byte array support** for arbitrary data encoding
- **Custom alphabet support** for different character sets
- **Memory safe** with proper error handling
- **Zero dependencies** - uses only Zig standard library
- **Comprehensive tests** with 100% code coverage

## Character Set

Default alphabet: `0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`

## Quick Start

### Basic Usage

```zig
const std = @import("std");
const base62 = @import("base62");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Encode an integer
    const value: u64 = 12345;
    const encoded = try base62.encodeInt(value, allocator);
    defer allocator.free(encoded);
    // encoded = "3D7"

    // Decode back to integer
    const decoded = try base62.decodeInt(encoded);
    // decoded = 12345
}
```

### Custom Alphabet

```zig
const custom_config = try base62.Base62Config.init(
    "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
);

const encoded = try base62.encodeIntWithConfig(12345, custom_config, allocator);
defer allocator.free(encoded);
```

### Byte Array Encoding

```zig
const data = "Hello World";
const encoded = try base62.encodeBytes(data, allocator);
defer allocator.free(encoded);

const decoded = try base62.decodeBytes(encoded, allocator);
defer allocator.free(decoded);
```

## API Reference

### Core Functions

#### Integer Encoding
- `encodeInt(value: u64, allocator) -> ![]u8`
- `decodeInt(encoded: []const u8) -> !u64`

#### Byte Array Encoding
- `encodeBytes(data: []const u8, allocator) -> ![]u8`
- `decodeBytes(encoded: []const u8, allocator) -> ![]u8`

#### Custom Configuration
- `encodeIntWithConfig(value: u64, config: Base62Config, allocator) -> ![]u8`
- `decodeIntWithConfig(encoded: []const u8, config: Base62Config) -> !u64`
- `encodeBytesWithConfig(data: []const u8, config: Base62Config, allocator) -> ![]u8`
- `decodeBytesWithConfig(encoded: []const u8, config: Base62Config, allocator) -> ![]u8`

### Configuration

```zig
const Base62Config = struct {
    alphabet: []const u8,

    pub fn init(alphabet: []const u8) !Base62Config
    pub fn default() Base62Config
    pub fn validate(self: Base62Config) !void
};
```

### Error Handling

```zig
const Base62Error = error{
    InvalidCharacter,
    InvalidAlphabet,
    Overflow,
    OutOfMemory,
};
```

## Building

```bash
# Run tests
zig build test

# Run tests directly
zig test src/base62.zig
```

## Use Cases

- **URL shorteners** - Generate short, unique identifiers
- **Database keys** - Compact primary keys and indexes
- **Session tokens** - Short, random session identifiers
- **API keys** - Compact, URL-safe API identifiers
- **File names** - Short, filesystem-safe file names

## Performance

- **O(log n)** encoding time complexity
- **O(n)** decoding time complexity
- **Minimal memory allocation** with exact-size buffers
- **Overflow detection** prevents silent data corruption

## Implementation Details

- Uses repeated division algorithm for integer encoding
- Lookup tables for fast character-to-value mapping
- Stack-allocated temporary buffers where possible
- Proper error handling for all edge cases

## Requirements

- Zig 0.15.0 or later
- No external dependencies

## License

Apache 2.0

###### dpw | 2025.09.25
