#!/bin/bash

# Base62 Code Coverage Script
# Generates test coverage reports using kcov

set -e

echo "🔍 Generating Code Coverage Report"
echo "=================================="

# Create coverage directory
mkdir -p coverage

# Check if kcov is available
if ! command -v kcov &> /dev/null; then
    echo "❌ kcov not found. Please install kcov for coverage reporting."
    echo ""
    echo "Installation:"
    echo "  macOS: brew install kcov"
    echo "  Ubuntu: apt-get install kcov"
    echo "  Fedora: dnf install kcov"
    echo ""
    echo "Falling back to basic test run..."
    zig test src/base62.zig
    exit 0
fi

# Compile test binary
echo "📦 Compiling test binary..."
zig test src/base62.zig --test-no-exec -ftest-exec-dir=coverage/

# Find the test binary
TEST_BINARY=$(find coverage -name "*test*" -type f -executable | head -1)

if [ -z "$TEST_BINARY" ]; then
    echo "❌ Could not find test binary"
    exit 1
fi

echo "🧪 Running tests with coverage..."
kcov --exclude-pattern=/usr,/opt,/tmp,/System coverage/html "$TEST_BINARY"

# Generate summary
echo ""
echo "📊 Coverage Summary:"
echo "==================="

# Look for coverage data
if [ -f "coverage/html/index.html" ]; then
    echo "✅ Coverage report generated: coverage/html/index.html"

    # Try to extract coverage percentage if possible
    if command -v grep &> /dev/null && command -v sed &> /dev/null; then
        COVERAGE=$(grep -o '[0-9]*\.[0-9]*%' coverage/html/index.html | head -1 || echo "N/A")
        echo "📈 Total Coverage: $COVERAGE"
    fi

    echo ""
    echo "🌐 Open coverage/html/index.html in your browser to view the detailed report"
else
    echo "⚠️  Coverage report not generated - check kcov installation and permissions"
fi

echo ""
echo "✅ Coverage analysis complete!"