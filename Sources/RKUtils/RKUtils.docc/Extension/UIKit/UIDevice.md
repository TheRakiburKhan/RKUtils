# ``RKUtils/UIKit/UIDevice``

Human-readable device model name detection.

## Overview

`UIDevice` extensions provide a convenient way to get the human-readable device model name. This utility detects the specific device model and returns user-friendly names like "iPhone 14 Pro" or "iPad Pro (12.9-inch) (5th generation)" instead of internal identifiers.

### Device Model Detection

Access the device model name:

```swift
import UIKit
import RKUtils

let deviceModel = UIDevice.modelName
print(deviceModel)
// Output examples:
// "iPhone 14 Pro" on an iPhone 14 Pro
// "iPad Pro (11-inch) (3rd generation)" on that iPad
// "Simulator iPhone 14 Pro" when running in Simulator
```

## Real-World Examples

### Analytics and Crash Reporting

Include device info in analytics:

```swift
func setupAnalytics() {
    let deviceInfo: [String: Any] = [
        "model": UIDevice.modelName,
        "systemName": UIDevice.current.systemName,
        "systemVersion": UIDevice.current.systemVersion
    ]

    Analytics.setUserProperties(deviceInfo)
}

func logError(_ error: Error) {
    let logMessage = """
    Error: \(error.localizedDescription)
    Device: \(UIDevice.modelName)
    iOS: \(UIDevice.current.systemVersion)
    """

    print(logMessage)
    CrashReporting.log(logMessage)
}
```

### Debug Information Display

Show device info in debug builds:

```swift
#if DEBUG
class DebugInfoViewController: UIViewController {
    @IBOutlet weak var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let info = """
        Device Model: \(UIDevice.modelName)
        System: \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)
        Name: \(UIDevice.current.name)
        Identifier: \(UIDevice.current.identifierForVendor?.uuidString ?? "Unknown")
        """

        infoLabel.text = info
    }
}
#endif
```

### Feature Detection Workarounds

Use model name for device-specific workarounds:

```swift
func applyDeviceSpecificWorkarounds() {
    let model = UIDevice.modelName

    // Example: Apply workaround for specific devices
    if model.contains("iPhone SE") {
        // Small screen adjustments
        applySmallScreenLayout()
    } else if model.contains("iPad Pro") {
        // Large screen optimizations
        applyLargeScreenLayout()
    }
}
```

### Support Ticket Information

Include device details in support requests:

```swift
func generateSupportInfo() -> String {
    return """
    Device Information:
    Model: \(UIDevice.modelName)
    OS Version: \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)
    App Version: \(Bundle.main.appVersion)

    Please describe your issue below:
    """
}

@IBAction func contactSupport() {
    let supportVC = SupportViewController()
    supportVC.prefillInfo = generateSupportInfo()
    present(supportVC, animated: true)
}
```

### App Store Screenshots

Detect simulator for screenshot automation:

```swift
func isRunningInSimulator() -> Bool {
    return UIDevice.modelName.hasPrefix("Simulator")
}

func prepareForScreenshots() {
    if isRunningInSimulator() {
        // Load demo data for clean screenshots
        loadDemoData()

        // Hide UI elements not needed in screenshots
        debugPanel.isHidden = true
    }
}
```

### Device-Specific Testing

Log device info during testing:

```swift
class DeviceTestReporter {
    func reportTestResults(_ results: TestResults) {
        let report = TestReport(
            device: UIDevice.modelName,
            systemVersion: UIDevice.current.systemVersion,
            results: results,
            timestamp: Date()
        )

        sendToTestServer(report)
    }
}
```

### Settings Screen

Display device info to users:

```swift
class AboutViewController: UIViewController {
    @IBOutlet weak var deviceModelLabel: UILabel!
    @IBOutlet weak var osVersionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        deviceModelLabel.text = UIDevice.modelName
        osVersionLabel.text = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    }
}
```

## Implementation Details

The extension uses the `uname` system call to retrieve the device identifier (e.g., "iPhone15,2") and maps it to human-readable names through an extensive lookup table covering:

- iPhone models (iPhone 4 through iPhone 14 series)
- iPad models (all generations of iPad, iPad Air, iPad mini, iPad Pro)
- iPod touch models
- Apple TV models
- HomePod models

When running in the iOS Simulator, the extension prepends "Simulator" to the model name and attempts to read the `SIMULATOR_MODEL_IDENTIFIER` environment variable to determine the simulated device.

For unrecognized devices (newer models not yet in the lookup table), the extension returns the internal identifier string (e.g., "iPhone15,2").

## Platform Availability

| Platform | Available | Notes |
|----------|-----------|-------|
| iOS | ✅ 13.0+ | Full device detection |
| tvOS | ✅ 13.0+ | Apple TV detection |
| visionOS | ✅ 1.0+ | Returns identifier |
| watchOS | ❌ | Not available |
| macOS | ❌ | Not available |

## Topics

### Device Model

- ``UIDevice/modelName``

## See Also

- ``UIScreen``
- ``UIView``
