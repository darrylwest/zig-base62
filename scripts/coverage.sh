#!/bin/bash

# Base62 Code Coverage Script
# Generates test coverage reports using Zig-native analysis

set -e

echo "🔍 Base62 Coverage Analysis"
echo "=========================="
echo ""

# Create coverage directory
mkdir -p coverage

# First, run all tests to ensure they pass
echo "🧪 Running comprehensive test suite..."
if ! zig test src/base62.zig; then
    echo "❌ Tests failed! Cannot generate coverage report."
    exit 1
fi

echo ""
echo "✅ All tests passed! Generating coverage analysis..."
echo ""

# Run our Zig-native coverage analyzer
if [ -f "scripts/zig-coverage.zig" ]; then
    cd scripts && zig run zig-coverage.zig && cd ..
else
    echo "❌ Coverage analyzer not found at scripts/zig-coverage.zig"
    exit 1
fi

# Check if kcov is available for additional analysis
if command -v kcov &> /dev/null; then
    echo ""
    echo "🔧 kcov detected - Running additional binary analysis..."

    # Run kcov for binary coverage (may show 0% for Zig but creates directory structure)
    kcov --exclude-pattern=/usr,/opt,/tmp,/System coverage/kcov zig test src/base62.zig >/dev/null 2>&1 || true

    echo "📁 kcov report: coverage/kcov/index.html (may show 0% due to Zig binary format)"
else
    echo ""
    echo "💡 Install kcov for additional binary coverage analysis:"
    echo "   macOS: brew install kcov"
    echo "   Ubuntu: apt-get install kcov"
fi

echo ""
echo "🎯 Coverage Analysis Complete!"
echo "==============================="
echo "📄 Main Report: coverage/index.html"
echo "🌐 View with: open coverage/index.html"
echo ""