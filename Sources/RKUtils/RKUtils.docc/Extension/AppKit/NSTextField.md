# ``RKUtils/AppKit/NSTextField``

Combine text publisher and padding utilities for NSTextField.

## Overview

`NSTextField` extensions provide Combine integration for reactive text field updates and simplified padding configuration. These utilities enable modern reactive programming patterns and consistent text field styling in macOS applications.

### Reactive Text Updates with Combine

Use ``NSTextField/textPublisher()`` to create a Combine publisher that emits text changes:

```swift
import AppKit
import Combine
import RKUtils

class SearchViewController: NSViewController {
    @IBOutlet weak var searchField: NSTextField!

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // React to text changes
        searchField.textPublisher()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.performSearch(query: searchText)
            }
            .store(in: &cancellables)
    }

    func performSearch(query: String) {
        print("Searching for: \(query)")
        // Perform search...
    }
}
```

### Adding Text Field Padding

Configure left and right padding for text fields:

```swift
import AppKit
import RKUtils

func setupTextField() {
    let textField = NSTextField()

    // Add left padding
    textField.setLeftPaddingPoints(12)

    // Add right padding
    textField.setRightPaddingPoints(12)
}
```

> Important: The padding methods (`setLeftPaddingPoints` and `setRightPaddingPoints`) provide simplified implementations. For production use, create a custom `NSTextFieldCell` subclass that overrides `titleRect(forBounds:)` to properly adjust the text drawing area. AppKit doesn't support padding in the same way as UIKit's `leftView`/`rightView`.

## Real-World Examples

### Search Field with Debouncing

Debounce search queries as user types:

```swift
class ProductSearchViewController: NSViewController {
    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet weak var resultsTableView: NSTableView!

    private var cancellables = Set<AnyCancellable>()
    private var searchResults: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchField()
        setupSearchPublisher()
    }

    func setupSearchField() {
        searchField.setLeftPaddingPoints(8)
        searchField.setRightPaddingPoints(8)
        searchField.placeholderString = "Search products..."
    }

    func setupSearchPublisher() {
        searchField.textPublisher()
            // Debounce to avoid excessive API calls
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            // Remove whitespace
            .map { $0.trimmingCharacters(in: .whitespaces) }
            // Only search if query is not empty
            .filter { !$0.isEmpty }
            // Avoid duplicate searches
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }

    func performSearch(query: String) {
        // Call API or filter local data
        ProductService.search(query: query) { [weak self] results in
            self?.searchResults = results
            self?.resultsTableView.reloadData()
        }
    }
}
```

### Form Validation with Combine

Validate form fields reactively:

```swift
class LoginViewController: NSViewController {
    @IBOutlet weak var emailField: NSTextField!
    @IBOutlet weak var passwordField: NSSecureTextField!
    @IBOutlet weak var loginButton: NSButton!

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextFields()
        setupValidation()
    }

    func setupTextFields() {
        emailField.setLeftPaddingPoints(12)
        emailField.setRightPaddingPoints(12)
        emailField.placeholderString = "email@example.com"

        passwordField.setLeftPaddingPoints(12)
        passwordField.setRightPaddingPoints(12)
        passwordField.placeholderString = "Password"

        loginButton.isEnabled = false
    }

    func setupValidation() {
        // Combine both field publishers
        let emailPublisher = emailField.textPublisher()
        let passwordPublisher = passwordField.textPublisher()

        Publishers.CombineLatest(emailPublisher, passwordPublisher)
            .map { email, password in
                // Enable login button only if both fields have text
                !email.trimmingCharacters(in: .whitespaces).isEmpty &&
                !password.isEmpty
            }
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)
    }

    @IBAction func loginClicked(_ sender: NSButton) {
        let email = emailField.stringValue
        let password = passwordField.stringValue

        authenticate(email: email, password: password)
    }
}
```

### Real-Time Character Counter

Show character count as user types:

```swift
class BioEditorViewController: NSViewController {
    @IBOutlet weak var bioTextField: NSTextField!
    @IBOutlet weak var characterCountLabel: NSTextField!

    private var cancellables = Set<AnyCancellable>()
    private let maxLength = 160

    override func viewDidLoad() {
        super.viewDidLoad()

        bioTextField.setLeftPaddingPoints(8)
        bioTextField.setRightPaddingPoints(8)

        bioTextField.textPublisher()
            .sink { [weak self] text in
                self?.updateCharacterCount(text: text)
            }
            .store(in: &cancellables)
    }

    func updateCharacterCount(text: String) {
        let count = text.count
        characterCountLabel.stringValue = "\(count)/\(maxLength)"

        // Visual feedback when approaching limit
        if count > maxLength {
            characterCountLabel.textColor = .systemRed
        } else if count > maxLength - 10 {
            characterCountLabel.textColor = .systemOrange
        } else {
            characterCountLabel.textColor = .secondaryLabelColor
        }
    }
}
```

### Email Validation

Validate email format in real-time:

```swift
class RegistrationViewController: NSViewController {
    @IBOutlet weak var emailField: NSTextField!
    @IBOutlet weak var validationIcon: NSImageView!
    @IBOutlet weak var validationLabel: NSTextField!

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.setLeftPaddingPoints(12)
        emailField.setRightPaddingPoints(40) // Space for validation icon

        emailField.textPublisher()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] email in
                self?.validateEmail(email)
            }
            .store(in: &cancellables)
    }

    func validateEmail(_ email: String) {
        let trimmed = email.trimmingCharacters(in: .whitespaces)

        guard !trimmed.isEmpty else {
            validationIcon.isHidden = true
            validationLabel.stringValue = ""
            return
        }

        // Simple email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValid = emailPredicate.evaluate(with: trimmed)

        if isValid {
            validationIcon.image = NSImage(systemSymbolName: "checkmark.circle.fill", accessibilityDescription: nil)
            validationIcon.contentTintColor = .systemGreen
            validationLabel.stringValue = "Valid email"
            validationLabel.textColor = .systemGreen
        } else {
            validationIcon.image = NSImage(systemSymbolName: "xmark.circle.fill", accessibilityDescription: nil)
            validationIcon.contentTintColor = .systemRed
            validationLabel.stringValue = "Invalid email format"
            validationLabel.textColor = .systemRed
        }

        validationIcon.isHidden = false
    }
}
```

### Auto-Save with Combine

Auto-save user input with debouncing:

```swift
class NotesViewController: NSViewController {
    @IBOutlet weak var titleField: NSTextField!
    @IBOutlet weak var saveStatusLabel: NSTextField!

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.setLeftPaddingPoints(8)
        titleField.setRightPaddingPoints(8)

        titleField.textPublisher()
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .sink { [weak self] title in
                self?.saveNote(title: title)
            }
            .store(in: &cancellables)
    }

    func saveNote(title: String) {
        saveStatusLabel.stringValue = "Saving..."

        // Save to UserDefaults, CoreData, or API
        UserDefaults.standard.set(title, forKey: "noteTitle")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.saveStatusLabel.stringValue = "Saved ✓"
        }
    }
}
```

### Filter Table View Content

Filter table rows as user types:

```swift
class FilterableTableViewController: NSViewController {
    @IBOutlet weak var filterField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!

    private var cancellables = Set<AnyCancellable>()
    private var allItems: [String] = []
    private var filteredItems: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        allItems = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
        filteredItems = allItems

        filterField.setLeftPaddingPoints(8)
        filterField.setRightPaddingPoints(8)
        filterField.placeholderString = "Type to filter..."

        filterField.textPublisher()
            .map { [weak self] query -> [String] in
                guard let self = self else { return [] }

                if query.isEmpty {
                    return self.allItems
                } else {
                    return self.allItems.filter { item in
                        item.localizedCaseInsensitiveContains(query)
                    }
                }
            }
            .sink { [weak self] filtered in
                self?.filteredItems = filtered
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return filteredItems.count
    }
}
```

### Combine Multiple Fields

Create computed properties from multiple text fields:

```swift
class CalculatorViewController: NSViewController {
    @IBOutlet weak var priceField: NSTextField!
    @IBOutlet weak var quantityField: NSTextField!
    @IBOutlet weak var totalLabel: NSTextField!

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        priceField.setLeftPaddingPoints(8)
        quantityField.setLeftPaddingPoints(8)

        let pricePublisher = priceField.textPublisher()
            .compactMap { Double($0) }

        let quantityPublisher = quantityField.textPublisher()
            .compactMap { Int($0) }

        Publishers.CombineLatest(pricePublisher, quantityPublisher)
            .map { price, quantity in
                let total = price * Double(quantity)
                return String(format: "$%.2f", total)
            }
            .assign(to: \.stringValue, on: totalLabel)
            .store(in: &cancellables)
    }
}
```

### Password Strength Indicator

Show password strength as user types:

```swift
class PasswordViewController: NSViewController {
    @IBOutlet weak var passwordField: NSSecureTextField!
    @IBOutlet weak var strengthLabel: NSTextField!
    @IBOutlet weak var strengthIndicator: NSProgressIndicator!

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.setLeftPaddingPoints(12)
        passwordField.setRightPaddingPoints(12)

        passwordField.textPublisher()
            .map { password -> (String, Double) in
                let strength = self.calculatePasswordStrength(password)
                let description: String

                switch strength {
                case 0..<0.3: description = "Weak"
                case 0.3..<0.6: description = "Medium"
                case 0.6..<0.8: description = "Strong"
                default: description = "Very Strong"
                }

                return (description, strength)
            }
            .sink { [weak self] description, strength in
                self?.strengthLabel.stringValue = description
                self?.strengthIndicator.doubleValue = strength * 100

                // Color coding
                if strength < 0.3 {
                    self?.strengthLabel.textColor = .systemRed
                } else if strength < 0.6 {
                    self?.strengthLabel.textColor = .systemOrange
                } else {
                    self?.strengthLabel.textColor = .systemGreen
                }
            }
            .store(in: &cancellables)
    }

    func calculatePasswordStrength(_ password: String) -> Double {
        var strength: Double = 0

        if password.count >= 8 { strength += 0.25 }
        if password.contains(where: { $0.isUppercase }) { strength += 0.25 }
        if password.contains(where: { $0.isNumber }) { strength += 0.25 }
        if password.contains(where: { "!@#$%^&*()".contains($0) }) { strength += 0.25 }

        return strength
    }
}
```

## Implementation Details

### Combine Publisher

The `textPublisher()` method uses `NSControl.textDidChangeNotification` to create a publisher:

```swift
// Internal implementation
NotificationCenter.default
    .publisher(for: NSControl.textDidChangeNotification, object: self)
    .map { ($0.object as? NSTextField)?.stringValue ?? "" }
    .eraseToAnyPublisher()
```

This works for both `NSTextField` and `NSSecureTextField` (which is a subclass of `NSTextField`).

### Padding Limitations

The padding methods (`setLeftPaddingPoints` and `setRightPaddingPoints`) provide simplified implementations. For production use:

1. **Create a custom NSTextFieldCell subclass:**

```swift
class PaddedTextFieldCell: NSTextFieldCell {
    var leftPadding: CGFloat = 0
    var rightPadding: CGFloat = 0

    override func titleRect(forBounds rect: NSRect) -> NSRect {
        var newRect = super.titleRect(forBounds: rect)
        newRect.origin.x += leftPadding
        newRect.size.width -= (leftPadding + rightPadding)
        return newRect
    }

    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        let paddedRect = titleRect(forBounds: cellFrame)
        super.drawInterior(withFrame: paddedRect, in: controlView)
    }
}
```

2. **Apply the custom cell to your text field:**

```swift
let textField = NSTextField()
let cell = PaddedTextFieldCell()
cell.leftPadding = 12
cell.rightPadding = 12
textField.cell = cell
```

Unlike UIKit's `UITextField` which has `leftView` and `rightView` properties, AppKit's `NSTextField` requires cell customization or layout constraints for padding.

## Best Practices

### Memory Management with Combine

Always store cancellables to prevent publisher cancellation:

```swift
class MyViewController: NSViewController {
    private var cancellables = Set<AnyCancellable>()  // ✅ Correct

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.textPublisher()
            .sink { text in
                print(text)
            }
            .store(in: &cancellables)  // Store reference
    }
}
```

### Debouncing for Performance

Use debouncing for expensive operations like API calls:

```swift
// ✅ Good - debounced
searchField.textPublisher()
    .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
    .sink { query in
        performSearch(query)  // Won't fire on every keystroke
    }
    .store(in: &cancellables)

// ❌ Bad - fires on every keystroke
searchField.textPublisher()
    .sink { query in
        performSearch(query)  // Too many API calls!
    }
    .store(in: &cancellables)
```

### Weak Self in Closures

Avoid retain cycles by using `[weak self]`:

```swift
textField.textPublisher()
    .sink { [weak self] text in
        self?.updateUI(with: text)
    }
    .store(in: &cancellables)
```

### NSSecureTextField Compatibility

The `textPublisher()` works with both `NSTextField` and `NSSecureTextField`:

```swift
let passwordField = NSSecureTextField()

passwordField.textPublisher()  // ✅ Works - NSSecureTextField is subclass
    .sink { password in
        validatePassword(password)
    }
    .store(in: &cancellables)
```

## Platform Availability

| Platform | Available | Notes |
|----------|-----------|-------|
| macOS | ✅ 11.0+ | Combine framework required |
| iOS | ❌ | Use UITextField extensions |

## Topics

### Reactive Text Updates

- ``NSTextField/textPublisher()``

### Text Field Padding

- ``NSTextField/setLeftPaddingPoints(_:)``
- ``NSTextField/setRightPaddingPoints(_:)``

## See Also

- ``NSSecureTextField``
- ``NSView``
- [Combine Framework Documentation](https://developer.apple.com/documentation/combine)
