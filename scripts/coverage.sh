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

# Try to compile test binary for coverage analysis
echo "📦 Compiling test binary..."
if ! zig test src/base62.zig --test-no-exec 2>/dev/null; then
    echo "⚠️  Direct test binary compilation not supported in this Zig version"
    echo "🧪 Running tests with kcov wrapper..."

    # Alternative approach: run kcov with zig test directly
    kcov --exclude-pattern=/usr,/opt,/tmp,/System coverage/html zig test src/base62.zig
else
    # Find the test binary (this path may vary by Zig version)
    TEST_BINARY=$(find . -name "*test*" -type f -executable 2>/dev/null | head -1)

    if [ -z "$TEST_BINARY" ]; then
        echo "⚠️  Could not find test binary, using direct kcov approach..."
        kcov --exclude-pattern=/usr,/opt,/tmp,/System coverage/html zig test src/base62.zig
    else
        echo "🧪 Running tests with coverage on binary: $TEST_BINARY"
        kcov --exclude-pattern=/usr,/opt,/tmp,/System coverage/html "$TEST_BINARY"
    fi
fi

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