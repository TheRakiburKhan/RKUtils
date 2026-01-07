//
//  UITableViewExtensionsTests.swift
//  RKUtils
//
//  Created by Rakibur Khan on 8/12/24.
//

#if canImport(UIKit) && !os(watchOS)
import Testing
import UIKit
@testable import RKUtils

@MainActor
@Suite("UITableView Extensions")
struct UITableViewExtensionsTests {

    // Test cell classes
    class TestCell: UITableViewCell {}
    class AnotherTestCell: UITableViewCell {}

    // Test header/footer class
    class TestHeaderFooter: UITableViewHeaderFooterView {}

    @Test("register cell with type generates correct identifier")
    func registerCellWithType() {
        let tableView = UITableView()

        tableView.register(cell: TestCell.self, fromNib: false)

        // Verify registration by dequeuing
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        #expect(cell is TestCell)
    }

    @Test("register multiple cell types")
    func registerMultipleCellTypes() {
        let tableView = UITableView()

        tableView.register(cell: TestCell.self, fromNib: false)
        tableView.register(cell: AnotherTestCell.self, fromNib: false)

        let indexPath = IndexPath(row: 0, section: 0)

        let cell1 = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        #expect(cell1 is TestCell)

        let cell2 = tableView.dequeueReusableCell(withIdentifier: "AnotherTestCell", for: indexPath)
        #expect(cell2 is AnotherTestCell)
    }

    @Test("dequeueReusableCell with type-safe method")
    func dequeueReusableCellTypeSafe() {
        let tableView = UITableView()
        tableView.register(cell: TestCell.self, fromNib: false)

        let indexPath = IndexPath(row: 0, section: 0)
        let cell: TestCell? = tableView.dequeueReusableCell(cell: TestCell.self, indexPath: indexPath)

        #expect(cell != nil)
        #expect(cell is TestCell)
    }

    @Test("register header/footer with type")
    func registerHeaderFooterWithType() {
        let tableView = UITableView()

        tableView.register(headerFooter: TestHeaderFooter.self, fromNib: false)

        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TestHeaderFooter")
        #expect(view is TestHeaderFooter)
    }

    @Test("dequeueReusableHeaderFooterView with type-safe method")
    func dequeueHeaderFooterTypeSafe() {
        let tableView = UITableView()
        tableView.register(headerFooter: TestHeaderFooter.self, fromNib: false)

        let view: TestHeaderFooter? = tableView.dequeueReusableHeaderFooterView(view: TestHeaderFooter.self)

        #expect(view != nil)
        #expect(view is TestHeaderFooter)
    }

    @Test("backgroundViewColor sets background view")
    func backgroundViewColor() {
        let tableView = UITableView()

        tableView.backgroundViewColor = .red

        #expect(tableView.backgroundView != nil)
        #expect(tableView.backgroundView?.backgroundColor == .red)
    }

    @Test("backgroundViewColor can be updated")
    func backgroundViewColorUpdate() {
        let tableView = UITableView()

        tableView.backgroundViewColor = .red
        #expect(tableView.backgroundView?.backgroundColor == .red)

        tableView.backgroundViewColor = .blue
        #expect(tableView.backgroundView?.backgroundColor == .blue)
    }

    @Test("backgroundViewColor getter returns correct color")
    func backgroundViewColorGetter() {
        let tableView = UITableView()

        tableView.backgroundViewColor = .green

        let retrievedColor = tableView.backgroundViewColor
        #expect(retrievedColor == .green)
    }

    @Test("deselectAllRows deselects all selected rows")
    func deselectAllRows() {
        let tableView = UITableView()
        tableView.register(cell: TestCell.self, fromNib: false)

        // Create a data source to enable row selection
        class TestDataSource: NSObject, UITableViewDataSource {
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return 5
            }

            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                return tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
            }
        }

        let dataSource = TestDataSource()
        tableView.dataSource = dataSource
        tableView.reloadData()

        // Select multiple rows
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        tableView.selectRow(at: IndexPath(row: 1, section: 0), animated: false, scrollPosition: .none)
        tableView.selectRow(at: IndexPath(row: 2, section: 0), animated: false, scrollPosition: .none)

        #expect(tableView.indexPathsForSelectedRows?.count == 3)

        // Deselect all
        tableView.deselectAllRows(animated: false)

        #expect(tableView.indexPathsForSelectedRows == nil || tableView.indexPathsForSelectedRows?.count == 0)
    }
}
#endif
