# ``RKUtils/Foundation/ProcessInfo``

Runtime environment detection for SwiftUI previews and development workflows.

## Overview

ProcessInfo extensions provide utilities for detecting the runtime environment, particularly useful for SwiftUI preview detection. This allows you to provide mock data or adjust behavior specifically for Xcode previews without affecting production code.

### SwiftUI Preview Detection

Check if code is running in a SwiftUI preview:

```swift
if ProcessInfo.processInfo.isPreview {
    // Use mock data for preview
    return sampleUsers
} else {
    // Load real data from API
    return await fetchUsers()
}
```

### Preview-Specific Data Loading

Provide sample data for previews:

```swift
class UserViewModel: ObservableObject {
    @Published var users: [User] = []

    func loadUsers() async {
        if ProcessInfo.processInfo.isPreview {
            // Load sample data instantly for previews
            users = [
                User(name: "Alice", email: "alice@example.com"),
                User(name: "Bob", email: "bob@example.com")
            ]
            return
        }

        // Production: fetch from API
        do {
            users = try await apiClient.fetchUsers()
        } catch {
            print("Error loading users: \(error)")
        }
    }
}
```

### Preview Image Loading

Skip network requests in previews:

```swift
struct ProfileImageView: View {
    let imageURL: URL

    @State private var image: UIImage?

    var body: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
        } else {
            ProgressView()
                .onAppear {
                    loadImage()
                }
        }
    }

    func loadImage() {
        if ProcessInfo.processInfo.isPreview {
            // Use placeholder in preview
            image = UIImage(systemName: "person.circle.fill")
            return
        }

        // Production: download from URL
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            if let data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    image = downloadedImage
                }
            }
        }.resume()
    }
}
```

### Conditional Analytics

Disable analytics in previews:

```swift
class AnalyticsManager {
    static let shared = AnalyticsManager()

    func trackEvent(_ event: String, parameters: [String: Any] = [:]) {
        // Skip tracking in previews
        guard !ProcessInfo.processInfo.isPreview else {
            print("[Preview] Skipping analytics: \(event)")
            return
        }

        // Production: send to analytics service
        Analytics.logEvent(event, parameters: parameters)
    }
}
```

### Database Initialization

Use in-memory storage for previews:

```swift
class DatabaseManager {
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "MyApp")

        if ProcessInfo.processInfo.isPreview {
            // Use in-memory store for previews
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]

            // Load sample data
            loadSampleData()
        } else {
            // Production: use persistent SQLite store
            container.loadPersistentStores { description, error in
                if let error {
                    fatalError("Database error: \(error)")
                }
            }
        }
    }

    private func loadSampleData() {
        // Populate preview database with sample data
    }
}
```

### Preview Provider Pattern

Combine with SwiftUI previews:

```swift
struct UserListView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        List(viewModel.users) { user in
            UserRow(user: user)
        }
        .onAppear {
            Task {
                await viewModel.loadUsers()
            }
        }
    }
}

#Preview {
    // ProcessInfo.isPreview will be true here
    UserListView()
}

#Preview("Empty State") {
    // Also true in this preview
    UserListView()
}
```

## Topics

### Environment Detection

Check if running in SwiftUI preview environment.

- ``ProcessInfo/isPreview``

## See Also

- ``RKUtils/Foundation/Bundle``
- ``RKUtils/Swift/String``
