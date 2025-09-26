# Zig Base62 Encode/Decode

[![CI](https://github.com/darrylwest/zig-base62/workflows/CI/badge.svg)](https://github.com/USERNAME/zig-base62/actions)
[![Security](https://github.com/darrylwest/zig-base62/workflows/Security/badge.svg)](https://github.com/USERNAME/zig-base62/actions)
[![Documentation](https://github.com/darrylwest/zig-base62/workflows/Documentation/badge.svg)](https://github.com/USERNAME/zig-base62/actions)

A high-performance Base62 encoding/decoding library written in Zig. Perfect for generating short, URL-safe identifiers and keys.

## Features

- **Fast integer encoding/decoding** using optimized algorithms
- **Byte array support** for arbitrary data encoding
- **Custom alphabet support** for different character sets
- **Memory safe** with proper error handling
- **Zero dependencies** - uses only Zig standard library
- **Comprehensive tests** with 100% function coverage (12 test cases)

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

# Run comprehensive coverage analysis
zig build coverage

# Run simple coverage analysis (no external tools)
zig build test-coverage
```

## Running Examples

The library includes comprehensive examples demonstrating all features:

```bash
# Run all examples (recommended)
./run-examples.sh

# Or get example instructions
zig build example

# View example files
ls examples/
# simple.zig  - Basic encoding/decoding demonstration
# usage.zig   - Comprehensive feature showcase
```

### Example Output

The simple example demonstrates basic functionality:

```
Base62 Library Demo
===================

Original: 12345
Encoded:  '3D7'
Decoded:  12345
Match:    true

Edge Case Tests:
  0 -> '0' -> 0 (✓)
  1 -> '1' -> 1 (✓)
  61 -> 'z' -> 61 (✓)
  62 -> '10' -> 62 (✓)
  3844 -> '100' -> 3844 (✓)
  1000000 -> '4C92' -> 1000000 (✓)

Base62 library working correctly!
```

The usage example showcases:
- Integer encoding with various values
- Custom alphabet configuration
- Byte array encoding
- Random key generation

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

## Test Coverage

The library includes comprehensive test coverage:

- **100% Function Coverage** - All 14 public functions tested
- **100% Error Path Coverage** - All error conditions validated
- **Edge Case Testing** - Boundary values and overflow protection
- **Performance Testing** - Large value handling verification
- **Configuration Testing** - Custom alphabet validation

View detailed coverage reports:

```bash
zig build coverage  # Generates coverage/index.html
```

## Project Structure

```
base62/
├── .github/
│   └── workflows/    # GitHub Actions CI/CD pipelines
├── src/              # Core library source code
│   ├── base62.zig    # Main library module
│   ├── config.zig    # Configuration and validation
│   └── errors.zig    # Error definitions
├── tests/            # Test directory
├── examples/         # Usage examples
│   ├── usage.zig     # Comprehensive usage examples
│   └── simple.zig    # Simple demonstration
├── docs/             # Documentation
│   ├── api-design.md # API specification
│   ├── test-coverage.md # Coverage analysis
│   └── github-actions.md # CI/CD documentation
├── scripts/          # Build and coverage scripts
├── CONTRIBUTING.md   # Contributor guidelines
└── build.zig         # Zig build configuration
```

## Documentation

Complete documentation available in the `docs/` directory:

- `api-design.md` - Comprehensive API documentation
- `implementation-plan.md` - Development approach and architecture
- `test-coverage.md` - Detailed coverage analysis
- `deployment-plan.md` - Distribution and maintenance strategy
- `github-actions.md` - CI/CD workflows and automation

## Requirements

- **Zig 0.15.0 or later** (tested with Zig 0.15.1)
- **No external dependencies** - uses only Zig standard library
- **No external dependencies for coverage** - uses Zig-native coverage analysis

## License

Apache 2.0

###### dpw | 2025.09.26
