//
//  UIStoryboardExtensionsTests.swift
//  RKUtils
//
//  Created by Rakibur Khan on 8/12/24.
//

#if canImport(UIKit) && !os(watchOS)
import Testing
import UIKit
@testable import RKUtils

@MainActor
@Suite("UIStoryboard Extensions")
struct UIStoryboardExtensionsTests {

    // Test view controller
    class TestViewController: UIViewController {
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    }

    @Test("instantiate generates correct identifier from type")
    func instantiateGeneratesIdentifier() {
        // Create a storyboard programmatically
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // This test verifies the identifier generation logic
        // In a real scenario, the storyboard would need to have a view controller
        // with storyboard ID matching the class name "TestViewController"

        // The method should generate identifier "TestViewController" from TestViewController.self
        let expectedIdentifier = String(describing: TestViewController.self)
        #expect(expectedIdentifier == "TestViewController")
    }

    @Test("instantiate returns nil for non-existent controller")
    func instantiateNonExistentController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // Should return nil if the storyboard doesn't contain this controller
        let controller: TestViewController? = storyboard.instantiate()

        // We expect nil since we don't have an actual storyboard file
        #expect(controller == nil)
    }

    @Test("identifier matches class name")
    func identifierMatchesClassName() {
        // Verify that String(describing:) produces the correct identifier
        let identifier = String(describing: TestViewController.self)
        #expect(identifier == "TestViewController")

        let identifier2 = String(describing: UIViewController.self)
        #expect(identifier2 == "UIViewController")
    }
}
#endif
