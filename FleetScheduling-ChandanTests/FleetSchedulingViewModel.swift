//
//  FleetSchedulingViewModel.swift
//  FleetScheduling-Chandan
//
//  Created by chandan Sharda on 29/08/25.
//

import XCTest
@testable import FleetScheduling_Chandan

final class FleetSchedulingViewModelTests: XCTestCase {

    var mockService: ScheduleService!
    var viewModel: FleetSchedulingViewModel!

    override func setUp() {
        super.setUp()
        mockService = ScheduleService()
        viewModel = FleetSchedulingViewModel(mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testInitializationCreatesSchedule() {
        // schedule and unscheduledTrucks should come from ScheduleService
        let allTrucks = Set(Truck.TRUCKS)
        let scheduledTrucks = Set(viewModel.schedule.values.flatMap { $0 })
        let unscheduledTrucks = Set(viewModel.unscheduledTrucks)

        // Combined should equal original trucks
        XCTAssertEqual(allTrucks, scheduledTrucks.union(unscheduledTrucks),
                       "All trucks should either be scheduled or unscheduled")
    }


    func testScheduleContainsAllChargers() {
        // Even if chargers are empty, they should appear as keys
        let chargerIdsInSchedule = Set(viewModel.schedule.keys.map { $0.id })
        let expectedChargerIds = Set(Charger.CHARGERS.map { $0.id })

        XCTAssertEqual(chargerIdsInSchedule, expectedChargerIds,
                       "Schedule should contain all chargers as keys")
    }

    func testSomeTrucksRemainUnscheduledIfNotEnoughTime() {
        // Run with a tighter time limit to force unscheduled trucks
        let shortService = ScheduleService()
        let shortData = shortService.calculateSchedule(
            trucks: Truck.TRUCKS,
            chargers: Charger.CHARGERS,
            timeLimitHours: 1 // not enough time
        )

        XCTAssertFalse(shortData.unscheduledTrucks.isEmpty,
                       "Some trucks should be unscheduled with tight time limits")
    }
}
