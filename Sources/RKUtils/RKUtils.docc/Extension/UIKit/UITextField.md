# ``RKUtils/UIKit/UITextField``

Text field padding, password visibility toggle, and Combine publishers.

## Overview

`UITextField` extensions provide convenient methods for adding padding, implementing password visibility toggles, and creating Combine publishers for text changes. These utilities improve user experience and reduce boilerplate code for common text field configurations.

### Text Field Padding

Add internal padding to text fields:

```swift
import UIKit
import RKUtils

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add padding
        emailTextField.setLeftPaddingPoints(16)
        emailTextField.setRightPaddingPoints(16)

        passwordTextField.setLeftPaddingPoints(16)
        passwordTextField.setRightPaddingPoints(16)
    }
}
```

### Password Visibility Toggle

Add an eye icon button to toggle password visibility:

```swift
passwordTextField.setSecureTextToggleToRight(.systemBlue)
// User can tap the eye icon to show/hide password
```

### Combine Text Publisher

Create a Combine publisher for text field changes:

```swift
import Combine

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!

    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField.textPublisher()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
            .store(in: &cancellables)
    }

    func performSearch(_ query: String) {
        print("Searching for: \(query)")
    }
}
```

## Real-World Examples

### Login Form

Complete login form with styled text fields:

```swift
class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupEmailField()
        setupPasswordField()
    }

    func setupEmailField() {
        emailTextField.setLeftPaddingPoints(16)
        emailTextField.setRightPaddingPoints(16)
        emailTextField.setBorder(width: 1, color: .systemGray4)
        emailTextField.setCornerRadius(cornerRadius: 8)
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
    }

    func setupPasswordField() {
        passwordTextField.setLeftPaddingPoints(16)
        passwordTextField.setRightPaddingPoints(48)  // Extra space for eye button
        passwordTextField.setBorder(width: 1, color: .systemGray4)
        passwordTextField.setCornerRadius(cornerRadius: 8)
        passwordTextField.placeholder = "Password"

        // Add password visibility toggle
        passwordTextField.setSecureTextToggleToRight(.systemBlue)
    }

    @IBAction func loginTapped() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        performLogin(email: email, password: password)
    }
}
```

### Real-Time Search

Implement real-time search with debouncing:

```swift
import Combine

class ProductSearchViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var resultsTableView: UITableView!

    var cancellables = Set<AnyCancellable>()
    var searchResults: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchField()
        setupSearchPublisher()
    }

    func setupSearchField() {
        searchTextField.setLeftPaddingPoints(40)  // Space for search icon
        searchTextField.setRightPaddingPoints(40)  // Space for clear button
        searchTextField.setCornerRadius(cornerRadius: 10)
        searchTextField.backgroundColor = .systemGray6
        searchTextField.placeholder = "Search products..."

        // Add search icon
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .systemGray
        searchIcon.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        searchIcon.contentMode = .center
        searchTextField.leftView = searchIcon
        searchTextField.leftViewMode = .always

        // Enable clear button
        searchTextField.clearButtonMode = .whileEditing
    }

    func setupSearchPublisher() {
        searchTextField.textPublisher()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                self?.searchProducts(query: query)
            }
            .store(in: &cancellables)
    }

    func searchProducts(query: String) {
        ProductService.search(query: query) { [weak self] results in
            self?.searchResults = results
            self?.resultsTableView.reloadData()
        }
    }
}
```

### Registration Form

Password field with confirmation:

```swift
class RegistrationViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFields()
    }

    func setupFields() {
        // Email field
        emailTextField.setLeftPaddingPoints(16)
        emailTextField.setRightPaddingPoints(16)
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress

        // Password fields
        [passwordTextField, confirmPasswordTextField].forEach { textField in
            textField?.setLeftPaddingPoints(16)
            textField?.setRightPaddingPoints(48)
            textField?.setBorder(width: 1, color: .systemGray4)
            textField?.setCornerRadius(cornerRadius: 8)

            // Add visibility toggle
            textField?.setSecureTextToggleToRight(.systemBlue)
        }

        passwordTextField.placeholder = "Password"
        confirmPasswordTextField.placeholder = "Confirm Password"
    }

    @IBAction func registerTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showError("Please enter your email")
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            showError("Please enter a password")
            return
        }

        guard let confirmPassword = confirmPasswordTextField.text,
              password == confirmPassword else {
            showError("Passwords don't match")
            return
        }

        performRegistration(email: email, password: password)
    }

    func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
```

### Form Validation with Combine

Real-time validation using Combine publishers:

```swift
import Combine

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupValidation()
    }

    func setupValidation() {
        let usernamePublisher = usernameTextField.textPublisher()
            .map { $0.count >= 3 }

        let emailPublisher = emailTextField.textPublisher()
            .map { $0.contains("@") && $0.contains(".") }

        let passwordPublisher = passwordTextField.textPublisher()
            .map { $0.count >= 8 }

        // Combine all validation publishers
        Publishers.CombineLatest3(usernamePublisher, emailPublisher, passwordPublisher)
            .map { usernameValid, emailValid, passwordValid in
                return usernameValid && emailValid && passwordValid
            }
            .assign(to: \.isEnabled, on: submitButton)
            .store(in: &cancellables)
    }
}
```

### Custom Styled Input Field

Create reusable styled text field component:

```swift
class StyledTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()

        setupAppearance()
    }

    func setupAppearance() {
        // Add padding
        setLeftPaddingPoints(16)
        setRightPaddingPoints(16)

        // Style
        setBorder(width: 1, color: .systemGray5)
        setCornerRadius(cornerRadius: 12)
        backgroundColor = .systemBackground

        // Font
        font = .systemFont(ofSize: 16)
        textColor = .label
    }

    // Highlight when focused
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result {
            setBorder(width: 2, color: .systemBlue)
        }
        return result
    }

    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result {
            setBorder(width: 1, color: .systemGray5)
        }
        return result
    }
}
```

## Implementation Details

### Password Visibility Toggle

The `setSecureTextToggleToRight(_:)` method:
- Creates a button with an "eye" SF Symbol
- Positions it in the `rightView` of the text field
- Toggles `isSecureTextEntry` when tapped
- Changes icon to "eye.slash" when password is visible
- Applies the provided tint color when password is visible

### Text Publisher

The `textPublisher()` method:
- Uses `UITextField.textDidChangeNotification`
- Returns `AnyPublisher<String, Never>`
- Emits an empty string if text is `nil`
- Can be combined with Combine operators for debouncing, filtering, etc.

### Padding Implementation

Padding methods work by setting the `leftView` and `rightView` properties:
- Creates empty `UIView` with specified width
- Sets `leftViewMode` or `rightViewMode` to `.always`
- May override existing views (be careful with rightView when using password toggle)

## Platform Availability

| Platform | Available |
|----------|-----------|
| iOS | ✅ 13.0+ |
| tvOS | ✅ 13.0+ |
| visionOS | ✅ 1.0+ |
| watchOS | ❌ Not available |
| macOS | ❌ Use NSTextField |

## Topics

### Password Visibility

- ``UITextField/setSecureTextToggleToRight(_:)``

### Reactive Text

- ``UITextField/textPublisher()``

### Padding

- ``UITextField/setLeftPaddingPoints(_:)``
- ``UITextField/setRightPaddingPoints(_:)``

## See Also

- ``UITextView``
- ``UIView``
- ``String``
