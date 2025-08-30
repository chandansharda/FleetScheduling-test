//
//  MainCoordinatorTests.swift
//  FleetScheduling-ChandanTests
//
//  Created by Chandan Sharda on 30/08/25.
//

import XCTest
@testable import FleetScheduling_Chandan

// MARK: - Spy Navigation Controller
final class MockNavigationController: UINavigationController {
    private(set) var pushedViewControllers: [UIViewController] = []

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewControllers.append(viewController)
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - Tests
final class MainCoordinatorTests: XCTestCase {
    var spyNav: MockNavigationController!
    var sut: MainCoordinator! // system under test

    override func setUp() {
        super.setUp()
        spyNav = MockNavigationController()
        sut = MainCoordinator(navigationController: spyNav)
    }

    override func tearDown() {
        spyNav = nil
        sut = nil
        super.tearDown()
    }

    func test_start_pushesFleetManagerViewController() {
        // When
        sut.start()

        // Then
        XCTAssertTrue(spyNav.pushedViewControllers.first is FleetManagerViewController,
                      "start() should push FleetManagerViewController")
    }

    func test_didTapOption_truckList_pushesListViewController() {
        sut.didTapOption(.truckList)

        let lastVC = spyNav.pushedViewControllers.last
        XCTAssertTrue(lastVC is ListViewController,
                      "TruckList option should push ListViewController")
        XCTAssertEqual((lastVC as? ListViewController)?.title, "Trucks")
    }

    func test_didTapOption_chargerList_pushesListViewController() {
        sut.didTapOption(.chargerList)

        let lastVC = spyNav.pushedViewControllers.last
        XCTAssertTrue(lastVC is ListViewController,
                      "ChargerList option should push ListViewController")
        XCTAssertEqual((lastVC as? ListViewController)?.title, "Chargers")
    }

    func test_didTapOption_scheduling_pushesScheduleViewController() {
        sut.didTapOption(.scheduling)

        let lastVC = spyNav.pushedViewControllers.last
        XCTAssertTrue(lastVC is ScheduleViewController,
                      "Scheduling option should push ScheduleViewController")
    }
}

