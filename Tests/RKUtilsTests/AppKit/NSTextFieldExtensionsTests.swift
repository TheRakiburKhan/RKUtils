//
//  NSTextFieldExtensionsTests.swift
//  RKUtils
//
//  Created by Rakibur Khan on 8/12/24.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import Testing
import AppKit
import Combine
@testable import RKUtils

@MainActor
@Suite("NSTextField Extensions")
struct NSTextFieldExtensionsTests {

    @Test("textPublisher emits text changes")
    func textPublisher() async {
        let textField = NSTextField()
        var receivedTexts: [String] = []
        var cancellables = Set<AnyCancellable>()

        textField.textPublisher()
            .sink { text in
                receivedTexts.append(text)
            }
            .store(in: &cancellables)

        // Simulate text change
        textField.stringValue = "Hello macOS"
        NotificationCenter.default.post(
            name: NSControl.textDidChangeNotification,
            object: textField
        )

        // Give publisher time to process
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        #expect(receivedTexts.count > 0)
        #expect(receivedTexts.contains("Hello macOS"))

        cancellables.removeAll()
    }

    @Test("textPublisher handles empty text")
    func textPublisherEmptyText() async {
        let textField = NSTextField()
        var receivedTexts: [String] = []
        var cancellables = Set<AnyCancellable>()

        textField.textPublisher()
            .sink { text in
                receivedTexts.append(text)
            }
            .store(in: &cancellables)

        // Simulate text change with empty string
        textField.stringValue = ""
        NotificationCenter.default.post(
            name: NSControl.textDidChangeNotification,
            object: textField
        )

        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(receivedTexts.count > 0)
        #expect(receivedTexts.contains(""))

        cancellables.removeAll()
    }

    @Test("textPublisher works with NSSecureTextField")
    func textPublisherWithSecureTextField() async {
        let secureField = NSSecureTextField()
        var receivedTexts: [String] = []
        var cancellables = Set<AnyCancellable>()

        secureField.textPublisher()
            .sink { text in
                receivedTexts.append(text)
            }
            .store(in: &cancellables)

        // Simulate text change
        secureField.stringValue = "password123"
        NotificationCenter.default.post(
            name: NSControl.textDidChangeNotification,
            object: secureField
        )

        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(receivedTexts.count > 0)
        #expect(receivedTexts.contains("password123"))

        cancellables.removeAll()
    }

    @Test("setLeftPaddingPoints exists and doesn't crash")
    func setLeftPaddingPoints() {
        let textField = NSTextField()

        // The method exists but is a placeholder in current implementation
        // Just verify it doesn't crash
        textField.setLeftPaddingPoints(16)

        #expect(textField.cell != nil)
    }

    @Test("setRightPaddingPoints exists and doesn't crash")
    func setRightPaddingPoints() {
        let textField = NSTextField()

        // The method exists but is a placeholder in current implementation
        // Just verify it doesn't crash
        textField.setRightPaddingPoints(20)

        #expect(textField.cell != nil)
    }
}
#endif
