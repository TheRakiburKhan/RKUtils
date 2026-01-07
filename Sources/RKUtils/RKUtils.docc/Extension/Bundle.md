# ``RKUtils/Foundation/Bundle``

Quick access to app version information, display names, and environment detection.

## Overview

Bundle extensions provide convenient properties to access application metadata like version numbers and display names. These utilities are essential for about screens, API headers, debug logging, and environment-specific behavior.

### Version Information

Access version and build numbers from Info.plist:

```swift
// Get release version
let version = Bundle.main.releaseVersionNumber
// "2.1.1"

// Get build number
let build = Bundle.main.buildVersionNumber
// "42"

// Get pretty-formatted version
let prettyVersion = Bundle.main.releaseVersionNumberPretty
// "v2.1.1"
```

### Display Name

Get the app's display name:

```swift
let appName = Bundle.main.bundleDisplayName
// "My App"
```

### Environment Detection

Check if running on simulator:

```swift
if Bundle.main.isSimulator {
    print("Running on simulator")
    // Enable debug features
} else {
    print("Running on physical device")
    // Production behavior
}
```

### About Screen Example

Display version information in settings:

```swift
class AboutViewController: UIViewController {
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        appNameLabel.text = Bundle.main.bundleDisplayName

        if let version = Bundle.main.releaseVersionNumber,
           let build = Bundle.main.buildVersionNumber {
            versionLabel.text = "Version \(version) (\(build))"
            // "Version 2.1.1 (42)"
        }
    }
}
```

### API Headers

Send version information with network requests:

```swift
func createAPIRequest(url: URL) -> URLRequest {
    var request = URLRequest(url: url)

    if let version = Bundle.main.releaseVersionNumber {
        request.setValue(version, forHTTPHeaderField: "App-Version")
    }

    if let build = Bundle.main.buildVersionNumber {
        request.setValue(build, forHTTPHeaderField: "Build-Number")
    }

    return request
}

// Headers:
// App-Version: 2.1.1
// Build-Number: 42
```

### Debug Logging

Include version info in crash reports and logs:

```swift
func logError(_ error: Error) {
    let version = Bundle.main.releaseVersionNumber ?? "unknown"
    let build = Bundle.main.buildVersionNumber ?? "unknown"
    let device = Bundle.main.isSimulator ? "Simulator" : "Device"

    let logMessage = """
    [ERROR] \(error.localizedDescription)
    App: \(Bundle.main.bundleDisplayName)
    Version: \(version) (\(build))
    Device: \(device)
    """

    print(logMessage)
    sendToAnalytics(logMessage)
}
```

### Update Prompts

Check version for update notifications:

```swift
func checkForUpdates() {
    guard let currentVersion = Bundle.main.releaseVersionNumber else {
        return
    }

    fetchLatestVersion { latestVersion in
        if latestVersion > currentVersion {
            showUpdateAlert(
                current: currentVersion,
                latest: latestVersion
            )
        }
    }
}
```

### Environment-Specific Configuration

Adjust behavior based on simulator vs device:

```swift
class NetworkManager {
    static let shared = NetworkManager()

    var baseURL: String {
        if Bundle.main.isSimulator {
            // Use local server for simulator testing
            return "http://localhost:8080"
        } else {
            // Use production API on device
            return "https://api.example.com"
        }
    }

    var enableVerboseLogging: Bool {
        return Bundle.main.isSimulator
    }
}
```

## Topics

### Version Information

Retrieve version and build numbers from Info.plist.

- ``Bundle/releaseVersionNumber``
- ``Bundle/buildVersionNumber``
- ``Bundle/releaseVersionNumberPretty``

### App Information

Access application display name.

- ``Bundle/bundleDisplayName``

### Environment Detection

Determine the runtime environment.

- ``Bundle/isSimulator``

## See Also

- ``RKUtils/Foundation/ProcessInfo``
- ``RKUtils/Swift/String``
