# ``RKUtils/AppKit/NSCollectionView``

Type-safe item registration and dequeuing for NSCollectionView.

## Overview

`NSCollectionView` extensions provide type-safe APIs for registering and dequeuing collection view items and supplementary views. These utilities eliminate the need for string-based identifiers and bring consistency to macOS collection view development.

### Type-Safe Registration and Dequeuing

Register and dequeue items using their class types instead of string identifiers:

```swift
import AppKit
import RKUtils

class PhotoGalleryViewController: NSViewController {
    @IBOutlet weak var collectionView: NSCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register using class type
        collectionView.register(cell: PhotoItem.self)
        collectionView.registerSupplementaryView(
            reusableView: SectionHeaderView.self,
            kind: .sectionHeader
        )
    }
}

extension PhotoGalleryViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        // Dequeue with type safety
        guard let item = collectionView.dequeueReusableItem(
            cell: PhotoItem.self,
            indexPath: indexPath
        ) else {
            return NSCollectionViewItem()
        }

        item.configure(with: photos[indexPath.item])
        return item
    }

    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            cell: SectionHeaderView.self,
            kind: kind,
            indexPath: indexPath
        ) else {
            return NSView()
        }

        header.configure(with: sectionTitles[indexPath.section])
        return header
    }
}
```

### NIB-Based vs Class-Based Registration

Register items from NIB files or programmatically:

```swift
// From NIB file (default)
collectionView.register(cell: PhotoItem.self)
// Expects PhotoItem.xib in main bundle

// From NIB in custom bundle
collectionView.register(
    cell: PhotoItem.self,
    fromNib: true,
    bundle: Bundle(for: PhotoItem.self)
)

// Programmatic (no NIB)
collectionView.register(cell: PhotoItem.self, fromNib: false)
```

### Supplementary Views

Register and dequeue headers, footers, and custom supplementary views:

```swift
// Register header
collectionView.registerSupplementaryView(
    reusableView: AlbumHeaderView.self,
    kind: .sectionHeader
)

// Register footer
collectionView.registerSupplementaryView(
    reusableView: AlbumFooterView.self,
    kind: .sectionFooter
)

// Dequeue header
func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
    if kind == .sectionHeader {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            cell: AlbumHeaderView.self,
            kind: kind,
            indexPath: indexPath
        ) else {
            return NSView()
        }
        return header
    }

    // Handle footer...
    return NSView()
}
```

### Visible Item Tracking

Get the first visible item's index path:

```swift
if let firstVisibleIndexPath = collectionView.visibleCurrentCellIndexPath {
    print("First visible item at section \(firstVisibleIndexPath.section), item \(firstVisibleIndexPath.item)")

    // Scroll to first visible item
    collectionView.scrollToItems(
        at: [firstVisibleIndexPath],
        scrollPosition: .centeredVertically
    )
}
```

## Real-World Examples

### Photo Gallery

Complete photo gallery implementation:

```swift
class PhotoGalleryViewController: NSViewController {
    @IBOutlet weak var collectionView: NSCollectionView!

    var albums: [Album] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register items
        collectionView.register(cell: PhotoItem.self)
        collectionView.registerSupplementaryView(
            reusableView: AlbumHeaderView.self,
            kind: .sectionHeader
        )

        // Setup layout
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 120, height: 120)
        flowLayout.sectionInset = NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.headerReferenceSize = NSSize(width: 0, height: 44)
        collectionView.collectionViewLayout = flowLayout

        loadPhotos()
    }

    func loadPhotos() {
        // Load data...
        albums = PhotoService.loadAlbums()
        collectionView.reloadData()
    }
}

extension PhotoGalleryViewController: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return albums.count
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums[section].photos.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.dequeueReusableItem(
            cell: PhotoItem.self,
            indexPath: indexPath
        ) else {
            return NSCollectionViewItem()
        }

        let photo = albums[indexPath.section].photos[indexPath.item]
        item.imageView?.image = NSImage(contentsOf: photo.url)
        item.textField?.stringValue = photo.title
        return item
    }

    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        guard kind == .sectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                  cell: AlbumHeaderView.self,
                  kind: kind,
                  indexPath: indexPath
              ) else {
            return NSView()
        }

        header.titleLabel.stringValue = albums[indexPath.section].name
        header.subtitleLabel.stringValue = "\(albums[indexPath.section].photos.count) photos"
        return header
    }
}
```

### Custom Item Sizing

Dynamically size items based on content:

```swift
extension PhotoGalleryViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        let photo = albums[indexPath.section].photos[indexPath.item]

        // Maintain aspect ratio
        let maxWidth: CGFloat = 200
        let aspectRatio = photo.size.height / photo.size.width
        let height = maxWidth * aspectRatio

        return NSSize(width: maxWidth, height: height)
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 50)
    }
}
```

### Multiple Item Types

Handle different item types in one collection view:

```swift
enum MediaType {
    case photo, video
}

class MediaItem {
    let type: MediaType
    // ...
}

extension MediaGalleryViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let media = mediaItems[indexPath.item]

        switch media.type {
        case .photo:
            guard let item = collectionView.dequeueReusableItem(
                cell: PhotoItem.self,
                indexPath: indexPath
            ) else {
                return NSCollectionViewItem()
            }
            item.configure(with: media)
            return item

        case .video:
            guard let item = collectionView.dequeueReusableItem(
                cell: VideoItem.self,
                indexPath: indexPath
            ) else {
                return NSCollectionViewItem()
            }
            item.configure(with: media)
            return item
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register both types
        collectionView.register(cell: PhotoItem.self)
        collectionView.register(cell: VideoItem.self)
    }
}
```

### Grid Layout Variations

Switch between different layouts:

```swift
class LayoutViewController: NSViewController {
    @IBOutlet weak var collectionView: NSCollectionView!

    enum LayoutStyle {
        case grid, list
    }

    var currentLayout: LayoutStyle = .grid

    func applyGridLayout() {
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 150, height: 150)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        collectionView.collectionViewLayout = layout
    }

    func applyListLayout() {
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(
            width: collectionView.bounds.width - 20,
            height: 60
        )
        layout.minimumLineSpacing = 5
        layout.sectionInset = NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        collectionView.collectionViewLayout = layout
    }

    @IBAction func toggleLayout(_ sender: NSSegmentedControl) {
        currentLayout = sender.selectedSegment == 0 ? .grid : .list

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25

            if currentLayout == .grid {
                applyGridLayout()
            } else {
                applyListLayout()
            }

            collectionView.animator().collectionViewLayout?.invalidateLayout()
        }
    }
}
```

## Best Practices

### Always Use Type-Safe APIs

Instead of string identifiers:

```swift
// ❌ Old way - error-prone
let identifier = NSUserInterfaceItemIdentifier("PhotoItem")
collectionView.register(NSNib(nibNamed: "PhotoItem", bundle: nil), forItemWithIdentifier: identifier)
let item = collectionView.makeItem(withIdentifier: identifier, for: indexPath)

// ✅ New way - type-safe
collectionView.register(cell: PhotoItem.self)
let item = collectionView.dequeueReusableItem(cell: PhotoItem.self, indexPath: indexPath)
```

### NIB Naming Convention

When using NIB files, ensure the NIB filename matches the class name exactly:

```
PhotoItem.swift  ← Class name
PhotoItem.xib    ← NIB name must match
```

### Guard Unwrapping

Always guard unwrap dequeued items:

```swift
guard let item = collectionView.dequeueReusableItem(
    cell: PhotoItem.self,
    indexPath: indexPath
) else {
    return NSCollectionViewItem()  // Fallback
}
```

## Platform Availability

| Platform | Available |
|----------|-----------|
| macOS | ✅ 11.0+ |
| iOS | ❌ Use UICollectionView |

## Topics

### Visible Items

- ``NSCollectionView/visibleCurrentCellIndexPath``

### Item Registration

- ``NSCollectionView/register(cell:fromNib:bundle:)``
- ``NSCollectionView/registerSupplementaryView(reusableView:kind:fromNib:bundle:)``

### Item Dequeuing

- ``NSCollectionView/dequeueReusableItem(cell:indexPath:)``
- ``NSCollectionView/dequeueReusableSupplementaryView(cell:kind:indexPath:)``

## See Also

- ``NSTableView``
- ``NSView``
