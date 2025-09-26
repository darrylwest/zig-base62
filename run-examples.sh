#!/bin/bash

echo "📚 Base62 Library Examples"
echo "=========================="
echo ""

echo "🔹 Running Simple Example:"
echo "--------------------------"
# Create temporary standalone version
cp src/base62.zig examples/base62_standalone.zig
cp src/config.zig examples/config.zig
cp src/errors.zig examples/errors.zig
cd examples
# Create temporary version with local import
sed 's/@import("\.\.\/src\/base62\.zig")/@import("base62_standalone.zig")/' simple.zig > simple_temp.zig
zig run simple_temp.zig
cd ..

echo ""
echo "🔹 Running Usage Example:"
echo "-------------------------"
cd examples
# Create temporary version with local import
sed 's/@import("\.\.\/src\/base62\.zig")/@import("base62_standalone.zig")/' usage.zig > usage_temp.zig
zig run usage_temp.zig
cd ..

# Clean up
rm examples/base62_standalone.zig examples/config.zig examples/errors.zig examples/simple_temp.zig examples/usage_temp.zig 2>/dev/null

echo ""
echo "✅ Examples completed!"