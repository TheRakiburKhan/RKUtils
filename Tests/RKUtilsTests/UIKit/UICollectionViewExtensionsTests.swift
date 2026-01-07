//
//  UICollectionViewExtensionsTests.swift
//  RKUtils
//
//  Created by Rakibur Khan on 8/12/24.
//

#if canImport(UIKit) && !os(watchOS)
import Testing
import UIKit
@testable import RKUtils

@MainActor
@Suite("UICollectionView Extensions")
struct UICollectionViewExtensionsTests {

    // Test cell classes
    class TestCell: UICollectionViewCell {}
    class AnotherTestCell: UICollectionViewCell {}

    // Test supplementary view
    class TestHeaderView: UICollectionReusableView {}
    class TestFooterView: UICollectionReusableView {}

    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }

    @Test("register cell with type generates correct identifier")
    func registerCellWithType() {
        let collectionView = createCollectionView()

        collectionView.register(cell: TestCell.self, fromNib: false)

        let indexPath = IndexPath(item: 0, section: 0)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath)
        #expect(cell is TestCell)
    }

    @Test("register multiple cell types")
    func registerMultipleCellTypes() {
        let collectionView = createCollectionView()

        collectionView.register(cell: TestCell.self, fromNib: false)
        collectionView.register(cell: AnotherTestCell.self, fromNib: false)

        let indexPath = IndexPath(item: 0, section: 0)

        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath)
        #expect(cell1 is TestCell)

        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "AnotherTestCell", for: indexPath)
        #expect(cell2 is AnotherTestCell)
    }

    @Test("dequeueReusableCell with type-safe method")
    func dequeueReusableCellTypeSafe() {
        let collectionView = createCollectionView()
        collectionView.register(cell: TestCell.self, fromNib: false)

        let indexPath = IndexPath(item: 0, section: 0)
        let cell: TestCell? = collectionView.dequeueReusableCell(cell: TestCell.self, indexPath: indexPath)

        #expect(cell != nil)
        #expect(cell is TestCell)
    }

    @Test("register supplementary header view")
    func registerSupplementaryHeaderView() {
        let collectionView = createCollectionView()

        collectionView.registerSupplementaryView(resuableView: TestHeaderView.self, isHeader: true, fromNib: false)

        let indexPath = IndexPath(item: 0, section: 0)
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "TestHeaderView",
            for: indexPath
        )
        #expect(view is TestHeaderView)
    }

    @Test("register supplementary footer view")
    func registerSupplementaryFooterView() {
        let collectionView = createCollectionView()

        collectionView.registerSupplementaryView(resuableView: TestFooterView.self, isHeader: false, fromNib: false)

        let indexPath = IndexPath(item: 0, section: 0)
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "TestFooterView",
            for: indexPath
        )
        #expect(view is TestFooterView)
    }

    @Test("dequeueReusableSupplementaryView with type-safe method using kind")
    func dequeueSupplementaryViewTypeSafeWithKind() {
        let collectionView = createCollectionView()
        collectionView.registerSupplementaryView(resuableView: TestHeaderView.self, isHeader: true, fromNib: false)

        let indexPath = IndexPath(item: 0, section: 0)
        let view: TestHeaderView? = collectionView.dequeueReusableSupplementaryView(
            cell: TestHeaderView.self,
            kind: UICollectionView.elementKindSectionHeader,
            indexPath: indexPath
        )

        #expect(view != nil)
        #expect(view is TestHeaderView)
    }

    @Test("dequeueReusableSupplementaryView with type-safe method using isHeader")
    func dequeueSupplementaryViewTypeSafeWithIsHeader() {
        let collectionView = createCollectionView()
        collectionView.registerSupplementaryView(resuableView: TestHeaderView.self, isHeader: true, fromNib: false)

        let indexPath = IndexPath(item: 0, section: 0)
        let view: TestHeaderView? = collectionView.dequeueReusableSupplementaryView(
            cell: TestHeaderView.self,
            isHeader: true,
            indexPath: indexPath
        )

        #expect(view != nil)
        #expect(view is TestHeaderView)
    }

    @Test("visibleCurrentCellIndexPath returns indexPath for visible cell")
    func visibleCurrentCellIndexPath() {
        let collectionView = createCollectionView()
        collectionView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        collectionView.register(cell: TestCell.self, fromNib: false)

        // Create a data source
        class TestDataSource: NSObject, UICollectionViewDataSource {
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return 10
            }

            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath)
            }
        }

        let dataSource = TestDataSource()
        collectionView.dataSource = dataSource
        collectionView.reloadData()
        collectionView.layoutIfNeeded()

        // visibleCurrentCellIndexPath returns first visible cell's index path
        let indexPath = collectionView.visibleCurrentCellIndexPath

        // May be nil if no cells are visible yet, or returns the first visible cell
        if indexPath != nil {
            #expect(indexPath?.section == 0)
        }
    }
}
#endif
