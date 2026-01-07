# ``RKUtils/UIKit/UICollectionView``

Type-safe cell registration and dequeuing for UICollectionView.

## Overview

`UICollectionView` extensions provide type-safe APIs for registering and dequeuing collection view cells and supplementary views. These extensions eliminate string-based identifiers and bring consistency to iOS collection view development.

### Type-Safe Cell Registration and Dequeuing

Register and dequeue cells using their class types instead of string identifiers:

```swift
import UIKit
import RKUtils

class PhotoGalleryViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var photos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register using class type
        collectionView.register(cell: PhotoCell.self)
        collectionView.registerSupplementaryView(
            resuableView: SectionHeaderView.self,
            isHeader: true
        )
    }
}

extension PhotoGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue with type safety
        guard let cell = collectionView.dequeueReusableCell(
            cell: PhotoCell.self,
            indexPath: indexPath
        ) else {
            return UICollectionViewCell()
        }

        cell.configure(with: photos[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            cell: SectionHeaderView.self,
            kind: kind,
            indexPath: indexPath
        ) else {
            return UICollectionReusableView()
        }

        header.configure(with: "Photos")
        return header
    }
}
```

### XIB-Based vs Class-Based Registration

Register cells from XIB files or programmatically:

```swift
// From XIB file (default)
collectionView.register(cell: PhotoCell.self)
// Expects PhotoCell.xib in main bundle

// From XIB in custom bundle
collectionView.register(
    cell: PhotoCell.self,
    fromNib: true,
    bundle: Bundle(for: PhotoCell.self)
)

// Programmatic (no XIB)
collectionView.register(cell: PhotoCell.self, fromNib: false)
```

### Supplementary Views

Register and dequeue headers and footers:

```swift
// Register header
collectionView.registerSupplementaryView(
    resuableView: AlbumHeaderView.self,
    isHeader: true
)

// Register footer
collectionView.registerSupplementaryView(
    resuableView: AlbumFooterView.self,
    isHeader: false
)

// Dequeue header using isHeader parameter
func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            cell: AlbumHeaderView.self,
            isHeader: true,
            indexPath: indexPath
        ) else {
            return UICollectionReusableView()
        }
        return header
    }

    // Handle footer...
    return UICollectionReusableView()
}

// Dequeue using custom kind string
func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(
        cell: AlbumHeaderView.self,
        kind: kind,
        indexPath: indexPath
    ) else {
        return UICollectionReusableView()
    }
    return header
}
```

### Visible Item Tracking

Get the first visible cell's index path:

```swift
if let firstVisibleIndexPath = collectionView.visibleCurrentCellIndexPath {
    print("First visible cell at section \(firstVisibleIndexPath.section), item \(firstVisibleIndexPath.item)")

    // Scroll to first visible item
    collectionView.scrollToItem(
        at: firstVisibleIndexPath,
        at: .centeredVertically,
        animated: true
    )
}
```

## Real-World Examples

### Photo Grid

Complete photo grid implementation:

```swift
class PhotoGridViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var albums: [Album] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cells
        collectionView.register(cell: PhotoCell.self)
        collectionView.registerSupplementaryView(
            resuableView: AlbumHeaderView.self,
            isHeader: true
        )

        // Setup layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.headerReferenceSize = CGSize(width: 0, height: 44)
        collectionView.collectionViewLayout = layout

        loadPhotos()
    }

    func loadPhotos() {
        albums = PhotoService.loadAlbums()
        collectionView.reloadData()
    }
}

extension PhotoGridViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return albums.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums[section].photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            cell: PhotoCell.self,
            indexPath: indexPath
        ) else {
            return UICollectionViewCell()
        }

        let photo = albums[indexPath.section].photos[indexPath.item]
        cell.imageView?.image = UIImage(named: photo.imageName)
        cell.titleLabel?.text = photo.title
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                  cell: AlbumHeaderView.self,
                  isHeader: true,
                  indexPath: indexPath
              ) else {
            return UICollectionReusableView()
        }

        header.titleLabel.text = albums[indexPath.section].name
        header.subtitleLabel.text = "\(albums[indexPath.section].photos.count) photos"
        return header
    }
}
```

### Compositional Layout

Use modern compositional layouts:

```swift
func createLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.5),
        heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

    let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(200)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

    // Add header
    let headerSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(44)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerSize,
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top
    )
    section.boundarySupplementaryItems = [header]

    return UICollectionViewCompositionalLayout(section: section)
}
```

### Multiple Cell Types

Handle different cell types in one collection view:

```swift
enum MediaType {
    case photo, video
}

class MediaItem {
    let type: MediaType
    // ...
}

extension MediaGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let media = mediaItems[indexPath.item]

        switch media.type {
        case .photo:
            guard let cell = collectionView.dequeueReusableCell(
                cell: PhotoCell.self,
                indexPath: indexPath
            ) else {
                return UICollectionViewCell()
            }
            cell.configure(with: media)
            return cell

        case .video:
            guard let cell = collectionView.dequeueReusableCell(
                cell: VideoCell.self,
                indexPath: indexPath
            ) else {
                return UICollectionViewCell()
            }
            cell.configure(with: media)
            return cell
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register both types
        collectionView.register(cell: PhotoCell.self)
        collectionView.register(cell: VideoCell.self)
    }
}
```

## Best Practices

### Always Use Type-Safe APIs

Instead of string identifiers:

```swift
// ❌ Old way - error-prone
let identifier = "PhotoCell"
collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: identifier)
let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCell

// ✅ New way - type-safe
collectionView.register(cell: PhotoCell.self)
let cell = collectionView.dequeueReusableCell(cell: PhotoCell.self, indexPath: indexPath)
```

### XIB Naming Convention

When using XIB files, ensure the XIB filename matches the class name exactly:

```
PhotoCell.swift  ← Class name
PhotoCell.xib    ← XIB name must match
```

### Guard Unwrapping

Always guard unwrap dequeued cells:

```swift
guard let cell = collectionView.dequeueReusableCell(
    cell: PhotoCell.self,
    indexPath: indexPath
) else {
    return UICollectionViewCell()  // Fallback
}
```

## Platform Availability

| Platform | Available |
|----------|-----------|
| iOS | ✅ 13.0+ |
| tvOS | ✅ 13.0+ |
| visionOS | ✅ 1.0+ |
| macOS | ❌ Use NSCollectionView |
| watchOS | ❌ Not available |

## Topics

### Visible Items

- ``UICollectionView/visibleCurrentCellIndexPath``

### Cell Registration

- ``UICollectionView/register(cell:fromNib:bundle:)``
- ``UICollectionView/registerSupplementaryView(resuableView:isHeader:fromNib:bundle:)``

### Cell Dequeuing

- ``UICollectionView/dequeueReusableCell(cell:indexPath:)``
- ``UICollectionView/dequeueReusableSupplementaryView(cell:kind:indexPath:)``
- ``UICollectionView/dequeueReusableSupplementaryView(cell:isHeader:indexPath:)``

## See Also

- ``UITableView``
- ``UIView``
