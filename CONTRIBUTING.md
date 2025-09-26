# Contributing to Zig Base62

Thank you for your interest in contributing to the Zig Base62 library! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites

- **Zig 0.15.0 or later** (tested with Zig 0.15.1)
- **Git** for version control
- **Optional**: `kcov` for coverage reports

### Development Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/yourusername/zig-base62.git
   cd zig-base62
   ```
3. Verify the setup:
   ```bash
   zig build test
   ```

## 🔄 Development Workflow

### Before Making Changes

1. Create a new branch for your feature/fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make sure all tests pass:
   ```bash
   zig build test
   zig build coverage
   ```

### Making Changes

1. **Code Style**: Follow Zig conventions and use `zig fmt`:
   ```bash
   zig fmt src/
   ```

2. **Testing**: Add tests for new functionality:
   - All public functions must have tests
   - Error conditions must be tested
   - Edge cases should be covered

3. **Documentation**: Update documentation for API changes:
   - Update `README.md` for user-facing changes
   - Update inline documentation for functions
   - Update relevant files in `docs/` if needed

### Testing Your Changes

```bash
# Run all tests
zig build test

# Run coverage analysis
zig build coverage

# Check formatting
zig fmt --check src/

# Cross-platform testing (if available)
zig build test-coverage
```

## 🧪 Testing Guidelines

### Test Categories

1. **Basic Functionality**: Core encode/decode operations
2. **Error Conditions**: Invalid inputs and error handling
3. **Edge Cases**: Boundary values and special cases
4. **Configuration**: Custom alphabet support
5. **Performance**: Large value handling

### Writing Tests

Tests should be comprehensive and follow this pattern:

```zig
test "descriptive test name" {
    const allocator = std.testing.allocator;

    // Setup
    const input = "test data";

    // Action
    const result = try someFunction(input, allocator);
    defer allocator.free(result);

    // Assertion
    try std.testing.expectEqualStrings("expected", result);
}
```

### Test Requirements

- **Memory Safety**: All allocations must be paired with deallocations
- **Error Testing**: Use `expectError` for error condition tests
- **Comprehensive**: Test happy path, edge cases, and error conditions
- **Documentation**: Clear test names that describe what is being tested

## 📝 Code Guidelines

### Code Style

- Follow Zig standard formatting (`zig fmt`)
- Use meaningful variable and function names
- Add inline documentation for public functions
- Keep functions focused and reasonably sized

### Error Handling

- Use Zig error unions properly
- Provide meaningful error types
- Handle all possible error conditions
- Test all error paths

### Memory Management

- Use provided allocators consistently
- Ensure memory cleanup in error paths
- Prefer stack allocation where appropriate
- Document memory ownership clearly

### Performance

- Consider algorithmic complexity
- Use efficient data structures
- Minimize allocations where possible
- Profile performance-critical sections

## 🔍 Pull Request Process

### Before Submitting

1. **All tests pass**:
   ```bash
   zig build test
   ```

2. **Code is formatted**:
   ```bash
   zig fmt src/
   ```

3. **Coverage is maintained**:
   ```bash
   zig build coverage
   ```

4. **Documentation is updated** for API changes

### Pull Request Template

When creating a pull request, include:

- **Description**: Clear description of changes
- **Testing**: How the changes were tested
- **Coverage**: Impact on test coverage
- **Breaking Changes**: Any API breaking changes
- **Documentation**: Documentation updates made

### Review Process

1. **Automated Checks**: CI must pass
2. **Code Review**: Maintainer review
3. **Testing**: Verify test coverage
4. **Documentation**: Check documentation updates
5. **Merge**: Squash and merge after approval

## 🐛 Bug Reports

### Before Reporting

1. Check existing issues
2. Verify with latest version
3. Create minimal reproduction case

### Bug Report Template

```markdown
## Bug Description
Brief description of the bug

## Reproduction Steps
1. Step one
2. Step two
3. Expected vs actual behavior

## Environment
- Zig version:
- OS:
- Library version:

## Additional Context
Any additional information
```

## ✨ Feature Requests

### Guidelines

- Check existing issues first
- Explain the use case clearly
- Consider backwards compatibility
- Discuss implementation approach

### Feature Request Template

```markdown
## Feature Description
Clear description of the requested feature

## Use Case
Why is this feature needed?

## Implementation Ideas
Possible approaches to implementation

## Alternatives Considered
Other solutions considered
```

## 🏆 Recognition

Contributors will be:
- Listed in release notes
- Credited in documentation
- Added to contributor list

## 📞 Getting Help

- **Issues**: GitHub issues for bugs and features
- **Questions**: GitHub discussions for questions
- **Security**: Email for security-related issues

## 📋 Checklist for Contributors

Before submitting a contribution:

- [ ] Code follows Zig conventions
- [ ] All tests pass (`zig build test`)
- [ ] Code is properly formatted (`zig fmt src/`)
- [ ] New features have tests
- [ ] Documentation is updated
- [ ] No security vulnerabilities introduced
- [ ] Memory management is correct
- [ ] Error handling is comprehensive

## 🙏 Thank You

Your contributions make this project better for everyone. Whether it's code, documentation, bug reports, or feature suggestions, every contribution is valuable and appreciated!

---

*For questions about contributing, please open an issue or start a discussion.*