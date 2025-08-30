//
//  FleetManagerViewControllerTests.swift
//  FleetScheduling-Chandan
//
//  Created by chandan Sharda on 29/08/25.
//

import XCTest
@testable import FleetScheduling_Chandan

// MARK: - Mock Delegate
private final class MockFleetOptionCellDelegate: FleetOptionCellDelegate {
    private(set) var tappedOption: FleetOptionType?

    func didTapOption(_ option: FleetOptionType) {
        tappedOption = option
    }
}

final class FleetManagerViewControllerTests: XCTestCase {

    var viewController: FleetManagerViewController!
    fileprivate var mockDelegate: MockFleetOptionCellDelegate!

    override func setUp() {
        super.setUp()
        mockDelegate = MockFleetOptionCellDelegate()

        viewController = FleetManagerViewController(
            listOfOptions: [.truckList, .chargerList],
            mockDelegate
        )

        // Force view lifecycle
        _ = viewController.view
    }

    override func tearDown() {
        viewController = nil
        mockDelegate = nil
        super.tearDown()
    }

    func testViewControllerInitialization() {
        XCTAssertEqual(viewController.title, "Fleet Manager")
        XCTAssertNotNil(viewController.view, "View should load")
    }

    func testTableViewNumberOfRowsMatchesOptions() {
        let tableView = viewController.view.subviews.compactMap { $0 as? UITableView }.first
        XCTAssertNotNil(tableView, "TableView should be present")

        let rows = tableView?.numberOfRows(inSection: 0)
        XCTAssertEqual(rows, 2, "Row count should match the number of listOfOptions")
    }

    func testCellIsFleetOptionCell() {
        let tableView = viewController.view.subviews.compactMap { $0 as? UITableView }.first!
        let cell = tableView.dataSource?.tableView(
            tableView,
            cellForRowAt: IndexPath(row: 0, section: 0)
        )
        XCTAssertTrue(cell is FleetOptionCell, "Cell should be FleetOptionCell")
    }

    func testDelegateForwarding() {
        // Simulate tapping option
        viewController.didTapOption(.truckList)

        XCTAssertEqual(mockDelegate.tappedOption, .truckList, "Delegate should receive the tapped option")
    }
}
