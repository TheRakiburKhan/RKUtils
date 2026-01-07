//
//  UITextFieldExtensionsTests.swift
//  RKUtils
//
//  Created by Rakibur Khan on 8/12/24.
//

#if canImport(UIKit) && !os(watchOS)
import Testing
import UIKit
import Combine
@testable import RKUtils

@MainActor
@Suite("UITextField Extensions")
struct UITextFieldExtensionsTests {

    @Test("setLeftPaddingPoints adds left padding view")
    func setLeftPaddingPoints() {
        let textField = UITextField()
        textField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)

        textField.setLeftPaddingPoints(16)

        #expect(textField.leftView != nil)
        #expect(textField.leftViewMode == .always)
        #expect(textField.leftView?.frame.width == 16)
    }

    @Test("setRightPaddingPoints adds right padding view")
    func setRightPaddingPoints() {
        let textField = UITextField()
        textField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)

        textField.setRightPaddingPoints(20)

        #expect(textField.rightView != nil)
        #expect(textField.rightViewMode == .always)
        #expect(textField.rightView?.frame.width == 20)
    }

    @Test("textPublisher emits text changes")
    func textPublisher() async {
        let textField = UITextField()
        var receivedTexts: [String] = []
        var cancellables = Set<AnyCancellable>()

        textField.textPublisher()
            .sink { text in
                receivedTexts.append(text)
            }
            .store(in: &cancellables)

        // Simulate text change
        textField.text = "Hello"
        NotificationCenter.default.post(
            name: UITextField.textDidChangeNotification,
            object: textField
        )

        // Give publisher time to process
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        #expect(receivedTexts.count > 0)
        #expect(receivedTexts.contains("Hello"))

        cancellables.removeAll()
    }

    @Test("textPublisher handles empty text")
    func textPublisherEmptyText() async {
        let textField = UITextField()
        var receivedTexts: [String] = []
        var cancellables = Set<AnyCancellable>()

        textField.textPublisher()
            .sink { text in
                receivedTexts.append(text)
            }
            .store(in: &cancellables)

        // Simulate text change with nil text
        textField.text = nil
        NotificationCenter.default.post(
            name: UITextField.textDidChangeNotification,
            object: textField
        )

        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(receivedTexts.count > 0)
        #expect(receivedTexts.contains(""))

        cancellables.removeAll()
    }
}
#endif
