//
//  SchedulingServiceTests.swift
//  FleetScheduling-Chandan
//
//  Created by chandan Sharda on 29/08/25.
//

import XCTest
@testable import FleetScheduling_Chandan

final class ScheduleServiceTests: XCTestCase {

    var service: ScheduleService!

    override func setUp() {
        super.setUp()
        service = ScheduleService()
    }

    override func tearDown() {
        service = nil
        super.tearDown()
    }

    func testAllTrucksScheduledWithinTimeLimit() {
        let trucks = Truck.TRUCKS
        let chargers = Charger.CHARGERS

        // Give chargers enough time (10 hours) so all trucks can fit
        let result = service.calculateSchedule(trucks: trucks, chargers: chargers, timeLimitHours: 10)

        let scheduledTrucks = result.schedule.values.flatMap { $0 }

        XCTAssertEqual(scheduledTrucks.count, trucks.count, "All trucks should be scheduled")
        XCTAssertTrue(result.unscheduledTrucks.isEmpty, "No trucks should be unscheduled")
    }

    func testSomeTrucksUnscheduledDueToTimeLimit() {
        let trucks = Truck.TRUCKS
        let chargers = Charger.CHARGERS

        // Limit chargers to 2 hours → not all trucks can fit
        let result = service.calculateSchedule(trucks: trucks, chargers: chargers, timeLimitHours: 2)

        let scheduledTrucks = result.schedule.values.flatMap { $0 }

        XCTAssertLessThan(scheduledTrucks.count, trucks.count, "Some trucks should remain unscheduled")
        XCTAssertFalse(result.unscheduledTrucks.isEmpty, "Unscheduled trucks should not be empty")
    }

    func testNoChargersMeansAllUnscheduled() {
        let trucks = Truck.TRUCKS
        let chargers: [Charger] = []

        let result = service.calculateSchedule(trucks: trucks, chargers: chargers, timeLimitHours: 5)

        XCTAssertTrue(result.schedule.isEmpty, "No chargers means empty schedule")
        XCTAssertEqual(result.unscheduledTrucks.count, trucks.count, "All trucks should be unscheduled")
    }

    func testNoTrucksMeansEmptyAssignments() {
        let trucks: [Truck] = []
        let chargers = Charger.CHARGERS

        let result = service.calculateSchedule(trucks: trucks, chargers: chargers, timeLimitHours: 5)

        XCTAssertTrue(result.unscheduledTrucks.isEmpty, "No trucks means no unscheduled trucks")
        for charger in chargers {
            XCTAssertEqual(result.schedule[charger]?.count, 0, "Each charger should have an empty truck list")
        }
    }

    func testChargerAssignmentOrderGreedy() {
        let trucks = [
            Truck(id: "X", batteryCapacityKwh: 100, currentChargePercentage: 80),
            Truck(id: "Y", batteryCapacityKwh: 100, currentChargePercentage: 10)
        ]
        let chargers = [Charger(id: "Z", chargingRateKw: 10)]

        let result = service.calculateSchedule(trucks: trucks, chargers: chargers, timeLimitHours: 10)

        let scheduled = result.schedule[chargers[0]] ?? []
        XCTAssertTrue(scheduled.contains(where: { $0.id == "X" }), "Greedy should schedule the smaller truck first")
        XCTAssertEqual(result.unscheduledTrucks.first?.id, "Y", "Larger truck should remain unscheduled")
    }
}

