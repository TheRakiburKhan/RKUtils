# ``RKUtils/UIKit/UITextView``

Keyboard accessory utilities for text views.

## Overview

`UITextView` extensions add a convenient "Done" button above the keyboard, allowing users to easily dismiss the keyboard for multi-line text entry. This is particularly useful since text views don't have a built-in return key to dismiss the keyboard.

### Add Done Button

Add a "Done" button toolbar above the keyboard:

```swift
import UIKit
import RKUtils

class NoteViewController: UIViewController {
    @IBOutlet weak var notesTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add Done button to dismiss keyboard
        notesTextView.addDoneButtonOnKeyboard()
    }
}
```

## Real-World Examples

### Note Taking App

Complete note editor with Done button:

```swift
class NoteEditorViewController: UIViewController {
    @IBOutlet weak var notesTextView: UITextView!

    var note: Note?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextView()
        loadNote()
    }

    func setupTextView() {
        // Add Done button
        notesTextView.addDoneButtonOnKeyboard()

        // Style text view
        notesTextView.font = .systemFont(ofSize: 17)
        notesTextView.textColor = .label
        notesTextView.backgroundColor = .systemBackground

        // Add padding via text container insets
        notesTextView.textContainerInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)

        // Delegate for auto-save
        notesTextView.delegate = self
    }

    func loadNote() {
        if let note = note {
            notesTextView.text = note.content
        }
    }
}

extension NoteEditorViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        autoSaveNote()
    }

    func autoSaveNote() {
        guard let content = notesTextView.text, !content.isEmpty else {
            return
        }

        if let note = note {
            note.content = content
            note.updatedAt = Date()
        } else {
            let newNote = Note(content: content)
            self.note = newNote
        }

        saveNote()
    }
}
```

### Comment Input

Multi-line comment field with Done button:

```swift
class CommentViewController: UIViewController {
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var characterCountLabel: UILabel!

    let maxCharacters = 500

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCommentField()
    }

    func setupCommentField() {
        // Add Done button
        commentTextView.addDoneButtonOnKeyboard()

        // Style
        commentTextView.font = .systemFont(ofSize: 16)
        commentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.systemGray4.cgColor
        commentTextView.layer.cornerRadius = 8

        // Placeholder effect
        if commentTextView.text.isEmpty {
            commentTextView.text = "Write your comment..."
            commentTextView.textColor = .placeholderText
        }

        commentTextView.delegate = self
        updateCharacterCount()
    }

    func updateCharacterCount() {
        let count = commentTextView.text.count
        characterCountLabel.text = "\(count)/\(maxCharacters)"

        // Visual feedback
        if count >= maxCharacters {
            characterCountLabel.textColor = .systemRed
        } else if count >= maxCharacters - 50 {
            characterCountLabel.textColor = .systemOrange
        } else {
            characterCountLabel.textColor = .secondaryLabel
        }

        submitButton.isEnabled = count > 0 && count <= maxCharacters
    }

    @IBAction func submitComment() {
        guard let comment = commentTextView.text, !comment.isEmpty else {
            return
        }

        postComment(comment)
    }

    func postComment(_ text: String) {
        // Submit comment to server
    }
}

extension CommentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write your comment..."
            textView.textColor = .placeholderText
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= maxCharacters
    }

    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount()
    }
}
```

### Feedback Form

Multi-line feedback input:

```swift
class FeedbackViewController: UIViewController {
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFeedbackField()
    }

    func setupFeedbackField() {
        // Add Done button for easy keyboard dismissal
        feedbackTextView.addDoneButtonOnKeyboard()

        // Style
        feedbackTextView.font = .systemFont(ofSize: 16)
        feedbackTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        feedbackTextView.backgroundColor = .systemGray6
        feedbackTextView.layer.cornerRadius = 12

        feedbackTextView.delegate = self
    }

    @IBAction func sendFeedback() {
        guard let feedback = feedbackTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !feedback.isEmpty else {
            showAlert(message: "Please enter your feedback")
            return
        }

        submitFeedback(feedback)
    }

    func submitFeedback(_ text: String) {
        FeedbackService.submit(text) { [weak self] result in
            switch result {
            case .success:
                self?.showSuccessAndDismiss()
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Feedback",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func showSuccessAndDismiss() {
        let alert = UIAlertController(
            title: "Thank You!",
            message: "Your feedback has been submitted.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}

extension FeedbackViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let hasText = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        sendButton.isEnabled = hasText
    }
}
```

### Bio Editor with Auto-Sizing

Text view that grows with content:

```swift
class BioEditorViewController: UIViewController {
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!

    let maxCharacters = 150

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBioField()
    }

    func setupBioField() {
        // Add Done button
        bioTextView.addDoneButtonOnKeyboard()

        // Disable scrolling for auto-sizing
        bioTextView.isScrollEnabled = false

        // Style
        bioTextView.font = .systemFont(ofSize: 16)
        bioTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        bioTextView.layer.borderWidth = 1
        bioTextView.layer.borderColor = UIColor.systemGray4.cgColor
        bioTextView.layer.cornerRadius = 8

        bioTextView.delegate = self
    }

    func updateHeight() {
        // Calculate content size
        let size = bioTextView.sizeThatFits(CGSize(
            width: bioTextView.frame.width,
            height: .infinity
        ))

        // Constrain between min and max
        let newHeight = min(max(size.height, 100), 200)

        textViewHeightConstraint.constant = newHeight

        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func save() {
        guard let bio = bioTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !bio.isEmpty else {
            return
        }

        saveBio(bio)
    }

    func saveBio(_ text: String) {
        UserService.updateBio(text) { [weak self] result in
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self?.showError(error.localizedDescription)
            }
        }
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

extension BioEditorViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateHeight()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= maxCharacters
    }
}
```

## Implementation Details

The `addDoneButtonOnKeyboard()` method:
- Creates a `UIToolbar` with a flexible space and "Done" bar button item
- Sets the toolbar as the text view's `inputAccessoryView`
- The "Done" button calls `resignFirstResponder()` to dismiss the keyboard
- Toolbar spans the full width of the screen
- Uses `.done` system button style for native appearance

## Best Practices

### Always Add for Multi-Line Input

Text views don't have a built-in keyboard dismiss button like text fields:

```swift
// ✅ Good - users can easily dismiss keyboard
textView.addDoneButtonOnKeyboard()

// ❌ Bad - users must tap outside to dismiss
// (no keyboard toolbar)
```

### Combine with Text View Delegate

Use delegate methods for validation and auto-save:

```swift
textView.addDoneButtonOnKeyboard()
textView.delegate = self

func textViewDidChange(_ textView: UITextView) {
    // Auto-save, validation, character counting, etc.
}
```

### Consider Placeholder Text

UITextView doesn't have native placeholder support:

```swift
func setupPlaceholder() {
    if textView.text.isEmpty {
        textView.text = "Enter your notes here..."
        textView.textColor = .placeholderText
    }
}

func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == .placeholderText {
        textView.text = nil
        textView.textColor = .label
    }
}
```

## Platform Availability

| Platform | Available | Notes |
|----------|-----------|-------|
| iOS | ✅ 13.0+ | Full support |
| tvOS | ❌ | Not available |
| visionOS | ❌ | Not available |
| watchOS | ❌ | Not available |
| macOS | ❌ | Use NSTextView |

**Note:** Not available on tvOS or visionOS as those platforms don't use the standard iOS keyboard.

## Topics

### Keyboard Management

- ``UITextView/addDoneButtonOnKeyboard()``

## See Also

- ``UITextField``
- ``UIView``
- ``String``
