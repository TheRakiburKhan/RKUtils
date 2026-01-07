# ``RKUtils/AppKit/NSTableView``

Type-safe cell registration and dequeuing for NSTableView.

## Overview

`NSTableView` extensions provide type-safe APIs for registering and dequeuing table cell views, along with convenient selection and appearance utilities. These extensions eliminate string-based identifiers and bring consistency to macOS table view development.

### Type-Safe Cell Registration and Dequeuing

Register and dequeue cells using their class types instead of string identifiers:

```swift
import AppKit
import RKUtils

class DocumentsViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!

    var documents: [Document] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register using class type
        tableView.register(cell: DocumentCellView.self)

        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension DocumentsViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return documents.count
    }
}

extension DocumentsViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // Dequeue with type safety
        guard let cell = tableView.dequeueReusableCell(
            cell: DocumentCellView.self,
            owner: self
        ) else {
            return nil
        }

        cell.configure(with: documents[row])
        return cell
    }
}
```

### NIB-Based vs Class-Based Registration

Register cells from NIB files or programmatically:

```swift
// From NIB file (default)
tableView.register(cell: DocumentCellView.self)
// Expects DocumentCellView.xib in main bundle

// From NIB in custom bundle
tableView.register(
    cell: DocumentCellView.self,
    fromNib: true,
    bundle: Bundle(for: DocumentCellView.self)
)

// Programmatic (no NIB) - Note: AppKit doesn't support class-only registration
tableView.register(cell: DocumentCellView.self, fromNib: false)
// This will not register anything - AppKit limitation
```

### Background Color Configuration

Set table view background color with Interface Builder support:

```swift
// Programmatically
tableView.backgroundViewColor = .windowBackgroundColor

// Or use @IBInspectable in Interface Builder
// The property appears as "Background View Color" in IB inspector
```

### Selection Management

Deselect all rows conveniently:

```swift
// Deselect all selected rows
tableView.deselectAllRows()

// Useful after performing actions
@IBAction func deleteItems(_ sender: Any) {
    let selectedRows = tableView.selectedRowIndexes
    // Delete items...
    tableView.deselectAllRows()
}
```

## Real-World Examples

### File Browser

Complete file browser implementation:

```swift
class FileBrowserViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!

    var files: [FileItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell
        tableView.register(cell: FileCellView.self)

        // Configure appearance
        tableView.backgroundViewColor = .controlBackgroundColor
        tableView.gridStyleMask = .solidHorizontalGridLineMask
        tableView.rowHeight = 44

        tableView.delegate = self
        tableView.dataSource = self

        loadFiles()
    }

    func loadFiles() {
        files = FileService.loadFiles()
        tableView.reloadData()
    }
}

extension FileBrowserViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return files.count
    }
}

extension FileBrowserViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.dequeueReusableCell(
            cell: FileCellView.self,
            owner: self
        ) else {
            return nil
        }

        let file = files[row]
        cell.iconImageView?.image = file.icon
        cell.nameTextField?.stringValue = file.name
        cell.sizeTextField?.stringValue = file.formattedSize

        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0 {
            let selectedFile = files[tableView.selectedRow]
            showFileDetails(selectedFile)
        }
    }
}
```

### Multi-Column Table

Table with multiple columns:

```swift
class SpreadsheetViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!

    struct DataRow {
        let name: String
        let value: Double
        let date: Date
        let status: String
    }

    var data: [DataRow] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cells for different column types
        tableView.register(cell: TextCellView.self)
        tableView.register(cell: NumberCellView.self)
        tableView.register(cell: DateCellView.self)
        tableView.register(cell: StatusCellView.self)

        tableView.backgroundViewColor = .white
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let rowData = data[row]

        switch tableColumn?.identifier.rawValue {
        case "NameColumn":
            guard let cell = tableView.dequeueReusableCell(
                cell: TextCellView.self,
                owner: self
            ) else { return nil }
            cell.textField?.stringValue = rowData.name
            return cell

        case "ValueColumn":
            guard let cell = tableView.dequeueReusableCell(
                cell: NumberCellView.self,
                owner: self
            ) else { return nil }
            cell.numberField?.doubleValue = rowData.value
            return cell

        case "DateColumn":
            guard let cell = tableView.dequeueReusableCell(
                cell: DateCellView.self,
                owner: self
            ) else { return nil }
            cell.dateField?.stringValue = formatDate(rowData.date)
            return cell

        case "StatusColumn":
            guard let cell = tableView.dequeueReusableCell(
                cell: StatusCellView.self,
                owner: self
            ) else { return nil }
            cell.configure(status: rowData.status)
            return cell

        default:
            return nil
        }
    }
}
```

### Context Menu Actions

Table with context menu and selection handling:

```swift
class TasksViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!

    var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cell: TaskCellView.self)
        tableView.backgroundViewColor = .controlBackgroundColor

        updateButtonStates()
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        updateButtonStates()
    }

    func updateButtonStates() {
        let hasSelection = tableView.selectedRow >= 0
        deleteButton.isEnabled = hasSelection
    }

    @IBAction func deleteSelectedTasks(_ sender: Any) {
        let selectedRows = tableView.selectedRowIndexes
        guard !selectedRows.isEmpty else { return }

        // Remove from data source (reverse order to maintain indices)
        selectedRows.reversed().forEach { row in
            tasks.remove(at: row)
        }

        // Remove from table
        tableView.removeRows(at: selectedRows, withAnimation: .slideUp)
        tableView.deselectAllRows()

        updateButtonStates()
    }

    @IBAction func clearSelection(_ sender: Any) {
        tableView.deselectAllRows()
    }
}

extension TasksViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.dequeueReusableCell(
            cell: TaskCellView.self,
            owner: self
        ) else {
            return nil
        }

        cell.configure(with: tasks[row])
        return cell
    }
}
```

### Searchable Table

Table with search filtering:

```swift
class SearchableTableViewController: NSViewController {
    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var tableView: NSTableView!

    var allItems: [Item] = []
    var filteredItems: [Item] = []
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cell: ItemCellView.self)
        tableView.backgroundViewColor = .controlBackgroundColor

        searchField.target = self
        searchField.action = #selector(searchChanged)

        loadData()
    }

    @objc func searchChanged() {
        let query = searchField.stringValue.lowercased()

        if query.isEmpty {
            isSearching = false
            filteredItems = []
        } else {
            isSearching = true
            filteredItems = allItems.filter { item in
                item.name.lowercased().contains(query)
            }
        }

        tableView.deselectAllRows()
        tableView.reloadData()
    }

    var displayedItems: [Item] {
        return isSearching ? filteredItems : allItems
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return displayedItems.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.dequeueReusableCell(
            cell: ItemCellView.self,
            owner: self
        ) else {
            return nil
        }

        cell.configure(with: displayedItems[row])
        return cell
    }
}
```

### Drag and Drop Reordering

Reorder rows with drag and drop:

```swift
class ReorderableTableViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!

    var items: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cell: DraggableCellView.self)
        tableView.registerForDraggedTypes([.string])

        items = ["Item 1", "Item 2", "Item 3", "Item 4"]
    }
}

extension ReorderableTableViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        let item = NSPasteboardItem()
        item.setString(String(row), forType: .string)
        return item
    }

    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        if dropOperation == .above {
            return .move
        }
        return []
    }

    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        guard let pasteboardItem = info.draggingPasteboard.pasteboardItems?.first,
              let rowString = pasteboardItem.string(forType: .string),
              let sourceRow = Int(rowString) else {
            return false
        }

        let item = items.remove(at: sourceRow)
        let destinationRow = sourceRow < row ? row - 1 : row
        items.insert(item, at: destinationRow)

        tableView.moveRow(at: sourceRow, to: destinationRow)
        tableView.deselectAllRows()

        return true
    }
}

extension ReorderableTableViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.dequeueReusableCell(
            cell: DraggableCellView.self,
            owner: self
        ) else {
            return nil
        }

        cell.textField?.stringValue = items[row]
        return cell
    }
}
```

### Custom Cell with Interface Builder

Custom cell view designed in Interface Builder:

```swift
// DraggableCellView.swift
class DocumentCellView: NSTableCellView {
    @IBOutlet weak var iconImageView: NSImageView!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var subtitleTextField: NSTextField!
    @IBOutlet weak var statusIndicator: NSView!

    func configure(with document: Document) {
        iconImageView.image = document.icon
        titleTextField.stringValue = document.title
        subtitleTextField.stringValue = document.subtitle

        // Status indicator color
        statusIndicator.wantsLayer = true
        statusIndicator.layer?.backgroundColor = document.statusColor.cgColor
        statusIndicator.layer?.cornerRadius = statusIndicator.frame.width / 2
    }
}

// In view controller
override func viewDidLoad() {
    super.viewDidLoad()

    // Register cell from NIB
    tableView.register(cell: DocumentCellView.self)
    // Expects DocumentCellView.xib in bundle
}

func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    guard let cell = tableView.dequeueReusableCell(
        cell: DocumentCellView.self,
        owner: self
    ) else {
        return nil
    }

    cell.configure(with: documents[row])
    return cell
}
```

## Implementation Details

### Type-Safe Identifier System

The extensions use the class name as the reuse identifier:

```swift
// Internal implementation
let identifier = NSUserInterfaceItemIdentifier(String(describing: T.self))

// For DocumentCellView, this creates:
// NSUserInterfaceItemIdentifier("DocumentCellView")
```

### NIB Loading

When `fromNib: true`, the NIB filename must match the class name exactly:

```
DocumentCellView.swift  ← Class name
DocumentCellView.xib    ← NIB name must match
```

### AppKit Limitations

Unlike UIKit, AppKit's `NSTableView` doesn't support registering classes directly without NIBs. The `fromNib: false` parameter exists for API consistency but won't register anything.

## Best Practices

### Always Use Type-Safe APIs

Instead of string identifiers:

```swift
// ❌ Old way - error-prone
let identifier = NSUserInterfaceItemIdentifier("DocumentCellView")
tableView.register(NSNib(nibNamed: "DocumentCellView", bundle: nil), forIdentifier: identifier)
let view = tableView.makeView(withIdentifier: identifier, owner: self)

// ✅ New way - type-safe
tableView.register(cell: DocumentCellView.self)
let cell = tableView.dequeueReusableCell(cell: DocumentCellView.self, owner: self)
```

### NIB Naming Convention

Ensure the NIB filename matches the class name exactly:

```
✅ DocumentCellView.swift + DocumentCellView.xib
❌ DocumentCellView.swift + DocumentCell.xib
```

### Guard Unwrapping

Always guard unwrap dequeued cells:

```swift
guard let cell = tableView.dequeueReusableCell(
    cell: DocumentCellView.self,
    owner: self
) else {
    return nil  // Fallback
}
```

### Background Color in Interface Builder

Use `backgroundViewColor` for IB compatibility:

```swift
// Appears in IB inspector
tableView.backgroundViewColor = .windowBackgroundColor

// Standard property still works
tableView.backgroundColor = .windowBackgroundColor
```

## Platform Availability

| Platform | Available |
|----------|-----------|
| macOS | ✅ 11.0+ |
| iOS | ❌ Use UITableView |

## Topics

### Cell Management

- ``NSTableView/register(cell:fromNib:bundle:)``
- ``NSTableView/dequeueReusableCell(cell:owner:)``

### Appearance

- ``NSTableView/backgroundViewColor``

### Selection

- ``NSTableView/deselectAllRows()``

## See Also

- ``NSCollectionView``
- ``NSView``
