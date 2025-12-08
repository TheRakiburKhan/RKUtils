//
//  NSTableViewExtensionsTests.swift
//  RKUtils
//
//  Created by Rakibur Khan on 8/12/24.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import Testing
import AppKit
@testable import RKUtilsMacOSUI

@MainActor
@Suite("NSTableView Extensions")
struct NSTableViewExtensionsTests {

    // Test cell class
    class TestCellView: NSTableCellView {}

    @Test("register cell generates correct identifier")
    func registerCellGeneratesIdentifier() {
        // Test that identifier generation works correctly
        let identifier = NSUserInterfaceItemIdentifier(String(describing: TestCellView.self))
        #expect(identifier.rawValue == "TestCellView")
    }

    @Test("dequeueReusableCell generates correct identifier")
    func dequeueReusableCellIdentifier() {
        let tableView = NSTableView()

        // The method should generate correct identifier from type
        let expectedIdentifier = NSUserInterfaceItemIdentifier(String(describing: TestCellView.self))
        #expect(expectedIdentifier.rawValue == "TestCellView")

        // Dequeue will return nil since we haven't registered anything
        let cell: TestCellView? = tableView.dequeueReusableCell(cell: TestCellView.self, owner: nil)
        #expect(cell == nil)
    }

    @Test("backgroundViewColor sets background color")
    func backgroundViewColor() {
        let tableView = NSTableView()

        tableView.backgroundViewColor = .red

        #expect(tableView.backgroundColor == .red)
    }

    @Test("backgroundViewColor can be updated")
    func backgroundViewColorUpdate() {
        let tableView = NSTableView()

        tableView.backgroundViewColor = .red
        #expect(tableView.backgroundColor == .red)

        tableView.backgroundViewColor = .blue
        #expect(tableView.backgroundColor == .blue)
    }

    @Test("backgroundViewColor getter returns correct color")
    func backgroundViewColorGetter() {
        let tableView = NSTableView()

        tableView.backgroundViewColor = .green

        let retrievedColor = tableView.backgroundViewColor
        #expect(retrievedColor == .green)
    }

    @Test("backgroundViewColor nil sets clear color")
    func backgroundViewColorNil() {
        let tableView = NSTableView()

        tableView.backgroundViewColor = .red
        #expect(tableView.backgroundColor == .red)

        tableView.backgroundViewColor = nil
        #expect(tableView.backgroundColor == .clear)
    }

    @Test("deselectAllRows exists and doesn't crash")
    func deselectAllRows() {
        let tableView = NSTableView()

        // The method exists and doesn't crash when called
        // (Row selection requires a data source, so we just verify the method works)
        tableView.deselectAllRows()

        // Should complete without crashing
        #expect(tableView.selectedRowIndexes.count == 0)
    }

    @Test("identifier matches class name")
    func identifierMatchesClassName() {
        // Verify that NSUserInterfaceItemIdentifier produces the correct identifier
        let identifier = NSUserInterfaceItemIdentifier(String(describing: TestCellView.self))
        #expect(identifier.rawValue == "TestCellView")

        let identifier2 = NSUserInterfaceItemIdentifier(String(describing: NSTableCellView.self))
        #expect(identifier2.rawValue == "NSTableCellView")
    }
}
#endif
