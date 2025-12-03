# Contributing to RKUtils

First off, thank you for considering contributing to RKUtils! 🎉

It's people like you that make RKUtils such a great tool for the Swift community. We welcome contributions from everyone, whether you're fixing a typo, adding documentation, reporting a bug, or implementing a new feature.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Guidelines](#coding-guidelines)
- [Testing Guidelines](#testing-guidelines)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Community](#community)

---

## 📜 Code of Conduct

This project and everyone participating in it is governed by our commitment to providing a welcoming and inspiring community for all. By participating, you are expected to uphold high standards of respect and professionalism.

### Our Standards

- ✅ Using welcoming and inclusive language
- ✅ Being respectful of differing viewpoints and experiences
- ✅ Gracefully accepting constructive criticism
- ✅ Focusing on what is best for the community
- ✅ Showing empathy towards other community members

### Unacceptable Behavior

- ❌ Trolling, insulting/derogatory comments, and personal or political attacks
- ❌ Public or private harassment
- ❌ Publishing others' private information without explicit permission
- ❌ Other conduct which could reasonably be considered inappropriate in a professional setting

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have:

- macOS 13.0 or later
- Xcode 16.0 or later
- Swift 6.0 or later
- Git installed and configured

### Fork and Clone

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/RKUtils.git
   cd RKUtils
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/TheRakiburKhan/RKUtils.git
   ```

---

## 🤝 How Can I Contribute?

### 🐛 Reporting Bugs

Found a bug? Help us fix it!

**Before submitting a bug report:**

- Check if the bug has already been reported in [Issues](https://github.com/TheRakiburKhan/RKUtils/issues)
- Make sure you're using the latest version
- Collect information about the bug:
  - Stack trace or error message
  - Steps to reproduce
  - Expected vs actual behavior
  - Environment details (iOS version, Xcode version, etc.)

**Submitting a bug report:**

Create an issue with the following information:

```markdown
**Description**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:

1. Import RKUtils
2. Call method '...'
3. See error

**Expected Behavior**
What you expected to happen.

**Actual Behavior**
What actually happened.

**Environment**

- RKUtils Version: [e.g., 1.0.0]
- Platform: [e.g., iOS 16.0, macOS 13.0]
- Xcode Version: [e.g., 16.0]
- Swift Version: [e.g., 6.0]

**Additional Context**
Add any other context, screenshots, or code snippets.
```

### 💡 Suggesting Enhancements

Have an idea to make RKUtils better?

**Before submitting an enhancement:**

- Check if the enhancement has already been suggested
- Make sure it aligns with the project's goals (cross-platform utilities)
- Consider if it would be useful to most users

**Submitting an enhancement:**

Create an issue with:

- Clear title and description
- Use case and benefits
- Example API/usage (if applicable)
- Platform considerations (iOS, macOS, etc.)

### 📝 Improving Documentation

Documentation improvements are always welcome!

- Fix typos or clarify existing docs
- Add missing documentation for public APIs
- Create examples or tutorials
- Improve README or guides

### 🔨 Contributing Code

Want to add a feature or fix a bug?

1. **Check existing issues/PRs** to avoid duplicate work
2. **Create an issue first** for major changes (discuss before implementing)
3. **Follow our coding guidelines** (see below)
4. **Write tests** for your changes
5. **Update documentation** as needed

---

## 🛠️ Development Setup

### Building the Project

```bash
# Open in Xcode
open Package.swift

# Or build from command line
swift build
```

### Running Tests

```bash
# Run all tests
swift test

# Run tests for a specific target
swift test --filter RKUtilsTests
swift test --filter RKUtilsUITests
swift test --filter RKUtilsMacOSTests
```

### Project Structure

```
RKUtils/
├── Sources/
│   ├── RKUtils/              # Cross-platform utilities
│   ├── RKUtilsUI/            # UIKit extensions (iOS/tvOS/visionOS)
│   └── RKUtilsMacOSUI/       # AppKit extensions (macOS)
├── Tests/
│   ├── RKUtilsTests/         # Cross-platform tests
│   ├── RKUtilsUITests/       # UIKit tests
│   └── RKUtilsMacOSTests/    # AppKit tests
├── Package.swift             # SPM manifest
├── README.md
├── CHANGELOG.md
├── CONTRIBUTING.md
└── LICENSE
```

---

## 📐 Coding Guidelines

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).

#### General Principles

1. **Clarity at the point of use** is your most important goal
2. **Clarity is more important than brevity**
3. **Write a documentation comment** for every public declaration

#### Naming

```swift
// ✅ Good - Clear and descriptive
func setCornerRadius(cornerRadius: CGFloat)
func roundedCorner(corners: CACornerMask, radius: CGFloat, clips: Bool)

// ❌ Bad - Ambiguous or unclear
func set(cr: CGFloat)
func round(c: Int, r: Double, cl: Bool)
```

#### Code Organization

- Use `// MARK: -` to organize code into logical sections
- Group related functionality together
- Place extensions in separate files when appropriate

```swift
// MARK: - Corner Radius

public extension UIView {
    func setCornerRadius(cornerRadius: CGFloat) {
        // Implementation
    }
}

// MARK: - Border

public extension UIView {
    func setBorder(width: CGFloat, color: UIColor?) {
        // Implementation
    }
}
```

#### Documentation Comments

All public APIs must have documentation comments:

````swift
/// Sets the corner radius of the view's layer.
///
/// This method automatically enables layer-backing for NSView on macOS.
///
/// - Parameter cornerRadius: The radius to use when drawing rounded corners.
///
/// # Example
/// ```swift
/// view.setCornerRadius(cornerRadius: 10)
/// ```
public func setCornerRadius(cornerRadius: CGFloat) {
    // Implementation
}
````

#### Platform-Specific Code

Use conditional compilation for platform-specific code:

```swift
#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UIView {
    // UIKit-specific implementation
}
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension NSView {
    // AppKit-specific implementation
}
#endif
```

#### Error Handling

- Use Swift's error handling (`throw`, `try`, `catch`)
- Avoid force unwrapping (`!`) - use guard or if-let instead
- Document thrown errors in comments

```swift
// ✅ Good
guard let color = UIColor(hexString: hex) else {
    return nil
}

// ❌ Bad
let color = UIColor(hexString: hex)!
```

---

## 🧪 Testing Guidelines

### Writing Tests

We use the **Swift Testing** framework (not XCTest).

#### Test Structure

```swift
import Testing
import Foundation
@testable import RKUtils

@MainActor  // For UI tests
@Suite("Feature Name")
struct FeatureTests {

    @Test("Test description")
    func testSomething() {
        // Arrange
        let view = UIView()

        // Act
        view.setCornerRadius(cornerRadius: 10)

        // Assert
        #expect(view.layer.cornerRadius == 10)
    }
}
```

#### Parameterized Tests

```swift
@Test("Hex color initialization", arguments: [
    ("#FF0000", 255, 0, 0),
    ("#00FF00", 0, 255, 0),
    ("#0000FF", 0, 0, 255)
])
func hexColorInit(hex: String, red: Int, green: Int, blue: Int) {
    let color = UIColor(hexString: hex)
    // Test assertions
}
```

#### Test Coverage

- Write tests for all new features
- Aim for high code coverage (>80%)
- Test edge cases and error conditions
- Test on multiple platforms when applicable

#### Platform-Specific Tests

```swift
#if canImport(UIKit) && !os(watchOS)
@MainActor
@Suite("UIView Extensions")
struct UIViewTests {
    // UIKit tests
}
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
@MainActor
@Suite("NSView Extensions")
struct NSViewTests {
    // AppKit tests
}
#endif
```

---

## 📝 Commit Guidelines

### Commit Message Format

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Code style changes (formatting, missing semi-colons, etc.)
- `refactor`: Code refactoring (neither fixes a bug nor adds a feature)
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (build, CI, dependencies, etc.)

#### Examples

```bash
# Feature
feat(UIView): add gradient background support

# Bug fix
fix(NSColor): correct hex string parsing for short format

# Documentation
docs(README): update installation instructions

# Test
test(Double): add tests for currency formatting

# Refactor
refactor(String): simplify email validation logic
```

#### Commit Message Guidelines

- Use the imperative mood ("add feature" not "added feature")
- Don't capitalize the first letter
- No period (.) at the end
- Keep the subject line under 50 characters
- Separate subject from body with a blank line
- Wrap the body at 72 characters
- Explain what and why, not how

---

## 🔄 Pull Request Process

### Before Submitting

1. **Update your fork**:

   ```bash
   git fetch upstream
   git checkout main
   git merge upstream/main
   ```

2. **Create a feature branch**:

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes** following the guidelines above

4. **Run tests**:

   ```bash
   swift test
   ```

5. **Update documentation** (README, inline docs, CHANGELOG)

6. **Commit your changes** with a clear message

7. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

### Submitting the PR

1. Go to the [RKUtils repository](https://github.com/TheRakiburKhan/RKUtils)
2. Click "New Pull Request"
3. Select your fork and branch
4. Fill out the PR template:

```markdown
## Description

Brief description of what this PR does.

## Motivation and Context

Why is this change needed? What problem does it solve?

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## How Has This Been Tested?

Describe the tests you ran and/or added.

## Checklist

- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published

## Screenshots (if applicable)

Add screenshots to help explain your changes.
```

### PR Review Process

1. **Automated checks** will run (tests, linting)
2. **Maintainers will review** your code
3. **Address feedback** by pushing new commits
4. Once approved, a **maintainer will merge** your PR

### After Your PR is Merged

1. **Delete your branch**:

   ```bash
   git branch -d feature/your-feature-name
   git push origin --delete feature/your-feature-name
   ```

2. **Update your fork**:
   ```bash
   git checkout main
   git pull upstream main
   git push origin main
   ```

---

## 🎯 What Should I Work On?

Looking for something to contribute? Check out:

- [Good First Issues](https://github.com/TheRakiburKhan/RKUtils/labels/good%20first%20issue) - Perfect for newcomers
- [Help Wanted](https://github.com/TheRakiburKhan/RKUtils/labels/help%20wanted) - Issues that need attention
- [Documentation](https://github.com/TheRakiburKhan/RKUtils/labels/documentation) - Improve our docs
- [Enhancement](https://github.com/TheRakiburKhan/RKUtils/labels/enhancement) - New features to implement

---

## 💬 Community

### Getting Help

- 💬 **Discussions**: Use [GitHub Discussions](https://github.com/TheRakiburKhan/RKUtils/discussions) for questions
- 🐛 **Issues**: Report bugs via [GitHub Issues](https://github.com/TheRakiburKhan/RKUtils/issues)
- 📧 **Email**: Contact the maintainer at [your.email@example.com](mailto:your.email@example.com)

### Recognition

Contributors will be:

- Listed in our [Contributors](https://github.com/TheRakiburKhan/RKUtils/graphs/contributors) page
- Mentioned in release notes for significant contributions
- Celebrated in our community

---

## 📚 Additional Resources

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Swift Style Guide](https://google.github.io/swift/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)
- [Swift Testing Documentation](https://developer.apple.com/documentation/testing)

---

## 🙏 Thank You

Your contributions, no matter how small, are incredibly valuable to us. Thank you for taking the time to contribute to RKUtils!

---

<p align="center">
  <strong>Happy Coding! 🚀</strong>
</p>

<p align="center">
  Made with ❤️ by the RKUtils community
</p>
