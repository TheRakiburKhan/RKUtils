# ``RKUtils/UIKit/UIStoryboard``

Type-safe view controller instantiation from storyboards.

## Overview

`UIStoryboard` extensions eliminate the need for string-based identifiers when instantiating view controllers. This utility provides compile-time type safety and reduces runtime errors from typos in storyboard identifiers.

### Type-Safe View Controller Instantiation

Instantiate view controllers without string identifiers:

```swift
import UIKit
import RKUtils

// In Storyboard: Set the Storyboard ID of ProfileViewController to "ProfileViewController"
let storyboard = UIStoryboard(name: "Main", bundle: nil)

// Old way - error-prone:
// let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController

// New way - type-safe:
let profileVC: ProfileViewController? = storyboard.instantiate()
```

## Real-World Examples

### Navigation Flow

Push view controllers with type safety:

```swift
class HomeViewController: UIViewController {
    @IBAction func showProfile() {
        guard let profileVC: ProfileViewController = storyboard?.instantiate() else {
            print("Failed to instantiate ProfileViewController")
            return
        }

        profileVC.user = currentUser
        navigationController?.pushViewController(profileVC, animated: true)
    }

    @IBAction func showSettings() {
        guard let settingsVC: SettingsViewController = storyboard?.instantiate() else {
            return
        }

        navigationController?.pushViewController(settingsVC, animated: true)
    }
}
```

### Modal Presentation

Present modal view controllers:

```swift
@IBAction func addNewItem() {
    guard let addItemVC: AddItemViewController = storyboard?.instantiate() else {
        return
    }

    addItemVC.delegate = self

    let navController = UINavigationController(rootViewController: addItemVC)
    navController.modalPresentationStyle = .formSheet

    present(navController, animated: true)
}

@IBAction func showFilters() {
    guard let filtersVC: FiltersViewController = storyboard?.instantiate() else {
        return
    }

    filtersVC.modalPresentationStyle = .pageSheet

    if let sheet = filtersVC.sheetPresentationController {
        sheet.detents = [.medium(), .large()]
        sheet.prefersGrabberVisible = true
    }

    present(filtersVC, animated: true)
}
```

### Multi-Storyboard Architecture

Work with multiple storyboards:

```swift
extension UIStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
    static let auth = UIStoryboard(name: "Authentication", bundle: nil)
    static let settings = UIStoryboard(name: "Settings", bundle: nil)
}

class AppCoordinator {
    func showLogin() {
        guard let loginVC: LoginViewController = UIStoryboard.auth.instantiate() else {
            return
        }
        present(loginVC, animated: true)
    }

    func showSettings() {
        guard let settingsVC: SettingsViewController = UIStoryboard.settings.instantiate() else {
            return
        }
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    func showHome() {
        guard let homeVC: HomeViewController = UIStoryboard.main.instantiate() else {
            return
        }
        window?.rootViewController = homeVC
    }
}
```

### Deep Linking

Handle deep links by instantiating appropriate view controllers:

```swift
class DeepLinkHandler {
    func handle(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return
        }

        switch components.path {
        case "/profile":
            showProfile()
        case "/settings":
            showSettings()
        case "/product":
            if let productId = components.queryItems?.first(where: { $0.name == "id" })?.value {
                showProduct(id: productId)
            }
        default:
            break
        }
    }

    private func showProfile() {
        guard let profileVC: ProfileViewController = mainStoryboard.instantiate() else {
            return
        }
        navigateTo(profileVC)
    }

    private func showSettings() {
        guard let settingsVC: SettingsViewController = settingsStoryboard.instantiate() else {
            return
        }
        navigateTo(settingsVC)
    }

    private func showProduct(id: String) {
        guard let productVC: ProductDetailViewController = mainStoryboard.instantiate() else {
            return
        }
        productVC.productId = id
        navigateTo(productVC)
    }

    private func navigateTo(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.windows.first,
              let rootVC = window.rootViewController else {
            return
        }

        if let navController = rootVC as? UINavigationController {
            navController.pushViewController(viewController, animated: true)
        } else {
            rootVC.present(viewController, animated: true)
        }
    }
}
```

### Tab Bar Setup

Create tab bar controller with storyboards:

```swift
func createTabBarController() -> UITabBarController {
    let tabBar = UITabBarController()
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

    guard let homeVC: HomeViewController = mainStoryboard.instantiate(),
          let searchVC: SearchViewController = mainStoryboard.instantiate(),
          let profileVC: ProfileViewController = mainStoryboard.instantiate() else {
        return tabBar
    }

    homeVC.tabBarItem = UITabBarItem(
        title: "Home",
        image: UIImage(systemName: "house"),
        tag: 0
    )

    searchVC.tabBarItem = UITabBarItem(
        title: "Search",
        image: UIImage(systemName: "magnifyingglass"),
        tag: 1
    )

    profileVC.tabBarItem = UITabBarItem(
        title: "Profile",
        image: UIImage(systemName: "person"),
        tag: 2
    )

    tabBar.viewControllers = [homeVC, searchVC, profileVC]

    return tabBar
}
```

### Conditional Navigation

Show different view controllers based on state:

```swift
func showAppropriateViewController(for user: User) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    if !user.hasCompletedProfile {
        guard let profileSetupVC: ProfileSetupViewController = storyboard.instantiate() else {
            return
        }
        profileSetupVC.user = user
        present(profileSetupVC, animated: true)
    } else if user.hasUnreadMessages {
        guard let messagesVC: MessagesViewController = storyboard.instantiate() else {
            return
        }
        messagesVC.user = user
        navigationController?.pushViewController(messagesVC, animated: true)
    } else {
        guard let homeVC: HomeViewController = storyboard.instantiate() else {
            return
        }
        navigationController?.pushViewController(homeVC, animated: true)
    }
}
```

### Onboarding Flow

Create multi-step onboarding:

```swift
class OnboardingCoordinator {
    let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
    weak var navigationController: UINavigationController?

    func start() {
        guard let welcomeVC: WelcomeViewController = storyboard.instantiate() else {
            return
        }
        welcomeVC.coordinator = self
        navigationController?.pushViewController(welcomeVC, animated: true)
    }

    func showFeatures() {
        guard let featuresVC: FeaturesViewController = storyboard.instantiate() else {
            return
        }
        featuresVC.coordinator = self
        navigationController?.pushViewController(featuresVC, animated: true)
    }

    func showPermissions() {
        guard let permissionsVC: PermissionsViewController = storyboard.instantiate() else {
            return
        }
        permissionsVC.coordinator = self
        navigationController?.pushViewController(permissionsVC, animated: true)
    }

    func complete() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        // Navigate to main app
    }
}
```

## Best Practices

### Storyboard ID Naming Convention

The storyboard identifier in Interface Builder must exactly match the class name:

```
Class name: ProfileViewController
Storyboard ID: ProfileViewController  ← Must match exactly
```

### Always Guard Unwrap

The method returns an optional, so always guard unwrap:

```swift
// ✅ Good - safe unwrapping
guard let viewController: MyViewController = storyboard?.instantiate() else {
    print("Failed to instantiate MyViewController")
    return
}
navigationController?.pushViewController(viewController, animated: true)

// ❌ Bad - force unwrapping
let viewController: MyViewController = storyboard!.instantiate()!
```

### Use Type Inference

Let Swift infer the type when possible:

```swift
// Both work, but explicit type is clearer
let vc1: ProfileViewController? = storyboard?.instantiate()

// Type inference
func pushProfile() {
    if let vc: ProfileViewController = storyboard?.instantiate() {
        navigationController?.pushViewController(vc, animated: true)
    }
}
```

## Platform Availability

| Platform | Available |
|----------|-----------|
| iOS | ✅ 13.0+ |
| tvOS | ✅ 13.0+ |
| visionOS | ✅ 1.0+ |
| watchOS | ❌ Not available |
| macOS | ❌ Use NSStoryboard |

## Topics

### View Controller Instantiation

- ``UIStoryboard/instantiate()``

## See Also

- ``UIView``
- ``UIViewController``
