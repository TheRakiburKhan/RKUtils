# ``RKUtils/UIKit/UITableView``

Type-safe cell registration, dequeuing, and table view utilities.

## Overview

`UITableView` extensions provide type-safe APIs for registering and dequeuing table view cells and header/footer views, background color management, and convenient selection utilities. These extensions eliminate string-based identifiers and reduce boilerplate code.

### Type-Safe Cell Registration

Register cells using class types instead of string identifiers:

```swift
import UIKit
import RKUtils

class MessagesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell
        tableView.register(cell: MessageCell.self)

        // Register header/footer
        tableView.register(headerFooter: SectionHeaderView.self)

        // Set background color
        tableView.backgroundViewColor = .systemGroupedBackground
    }
}
```

### Type-Safe Dequeuing

Dequeue cells with automatic type inference:

```swift
extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            cell: MessageCell.self,
            indexPath: indexPath
        ) else {
            return UITableViewCell()
        }

        cell.configure(with: messages[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            view: SectionHeaderView.self
        ) else {
            return nil
        }

        header.configure(with: sectionTitles[section])
        return header
    }
}
```

## Real-World Examples

### Message List

Complete messaging interface:

```swift
class MessagesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cells
        tableView.register(cell: MessageCell.self)
        tableView.register(cell: DateSeparatorCell.self)

        // Style table view
        tableView.backgroundViewColor = .systemBackground
        tableView.separatorStyle = .none

        loadMessages()
    }

    func loadMessages() {
        fetchMessages { [weak self] messages in
            self?.messages = messages
            self?.tableView.reloadData()
        }
    }
}

extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]

        if message.isDateSeparator {
            guard let cell = tableView.dequeueReusableCell(
                cell: DateSeparatorCell.self,
                indexPath: indexPath
            ) else {
                return UITableViewCell()
            }
            cell.configure(with: message.date)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                cell: MessageCell.self,
                indexPath: indexPath
            ) else {
                return UITableViewCell()
            }
            cell.configure(with: message)
            return cell
        }
    }
}

extension MessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect after selection
        tableView.deselectRow(at: indexPath, animated: true)

        let message = messages[indexPath.row]
        showMessageDetail(message)
    }
}
```

### Settings Screen

Grouped settings interface:

```swift
class SettingsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cells
        tableView.register(cell: SettingCell.self)
        tableView.register(cell: ToggleCell.self)
        tableView.register(headerFooter: SettingsHeaderView.self)

        // Style
        tableView.backgroundViewColor = .systemGroupedBackground
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settings[indexPath.section][indexPath.row]

        if setting.hasToggle {
            guard let cell = tableView.dequeueReusableCell(
                cell: ToggleCell.self,
                indexPath: indexPath
            ) else {
                return UITableViewCell()
            }
            cell.configure(with: setting)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                cell: SettingCell.self,
                indexPath: indexPath
            ) else {
                return UITableViewCell()
            }
            cell.configure(with: setting)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            view: SettingsHeaderView.self
        ) else {
            return nil
        }

        header.titleLabel.text = sectionTitles[section]
        return header
    }
}
```

### Selection Management

Handle multi-selection and deselection:

```swift
class ItemsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectAllButton: UIBarButtonItem!

    var isEditing = false

    @IBAction func toggleEditMode() {
        isEditing.toggle()
        tableView.setEditing(isEditing, animated: true)

        if !isEditing {
            // Exit edit mode - deselect all
            tableView.deselectAllRows(animated: true)
        }

        updateSelectAllButton()
    }

    @IBAction func selectAll() {
        guard isEditing else { return }

        for row in 0..<tableView.numberOfRows(inSection: 0) {
            let indexPath = IndexPath(row: row, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }

        updateSelectAllButton()
    }

    @IBAction func deleteSelected() {
        guard let selectedRows = tableView.indexPathsForSelectedRows else {
            return
        }

        // Delete items
        let itemsToDelete = selectedRows.map { items[$0.row] }
        items.removeAll { itemsToDelete.contains($0) }

        // Update table view
        tableView.deleteRows(at: selectedRows, with: .fade)

        // Deselect all
        tableView.deselectAllRows(animated: false)

        toggleEditMode()
    }

    func updateSelectAllButton() {
        let totalRows = tableView.numberOfRows(inSection: 0)
        let selectedRows = tableView.indexPathsForSelectedRows?.count ?? 0

        if selectedRows == totalRows {
            selectAllButton.title = "Deselect All"
        } else {
            selectAllButton.title = "Select All"
        }
    }
}

extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            updateSelectAllButton()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            showItemDetail(items[indexPath.row])
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isEditing {
            updateSelectAllButton()
        }
    }
}
```

### Custom Background

Set custom background colors:

```swift
class CustomTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Solid color background
        tableView.backgroundViewColor = .systemGray6

        // Or use gradient background view
        let gradientView = UIView(frame: tableView.bounds)
        gradientView.setLinearGradientBackground(
            colors: [.systemBlue.withAlphaComponent(0.1), .systemPurple.withAlphaComponent(0.1)],
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 0, y: 1)
        )
        tableView.backgroundView = gradientView
    }
}
```

### XIB-Based vs Class-Based Registration

Register cells from XIB files or programmatically:

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    // From XIB file (default)
    tableView.register(cell: CustomCell.self)
    // Expects CustomCell.xib in main bundle

    // From XIB in custom bundle
    tableView.register(
        cell: CustomCell.self,
        fromNib: true,
        bundle: Bundle(for: CustomCell.self)
    )

    // Programmatic (no XIB)
    tableView.register(cell: CustomCell.self, fromNib: false)

    // Same for headers/footers
    tableView.register(headerFooter: CustomHeaderView.self, fromNib: false)
}
```

## Best Practices

### Always Use Type-Safe APIs

Instead of string identifiers:

```swift
// ❌ Old way - error-prone
tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell

// ✅ New way - type-safe
tableView.register(cell: MessageCell.self)
let cell = tableView.dequeueReusableCell(cell: MessageCell.self, indexPath: indexPath)
```

### XIB Naming Convention

When using XIB files, ensure the XIB filename matches the class name exactly:

```
MessageCell.swift  ← Class name
MessageCell.xib    ← XIB name must match
```

### Guard Unwrapping

Always guard unwrap dequeued cells:

```swift
guard let cell = tableView.dequeueReusableCell(
    cell: MessageCell.self,
    indexPath: indexPath
) else {
    return UITableViewCell()  // Fallback
}
```

## Platform Availability

| Platform | Available |
|----------|-----------|
| iOS | ✅ 13.0+ |
| tvOS | ✅ 13.0+ |
| visionOS | ✅ 1.0+ |
| watchOS | ❌ Not available |
| macOS | ❌ Use NSTableView |

## Topics

### Cell Registration

- ``UITableView/register(cell:fromNib:bundle:)``
- ``UITableView/register(headerFooter:fromNib:bundle:)``

### Cell Dequeuing

- ``UITableView/dequeueReusableCell(cell:indexPath:)``
- ``UITableView/dequeueReusableHeaderFooterView(view:)``

### Background

- ``UITableView/backgroundViewColor``

### Selection

- ``UITableView/deselectAllRows(animated:)``

## See Also

- ``UICollectionView``
- ``UIView``
