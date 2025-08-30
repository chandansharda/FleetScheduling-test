//
//  FleetSchedulingViewModel.swift
//  FleetScheduling-Chandan
//
//  Created by Chandan Sharda on 27/08/25.
//

final class FleetSchedulingViewModel {

    private let service: ScheduleService
    private(set) var schedule: [Charger: [Truck]]
    private(set) var unscheduledTrucks: [Truck]

    init(_ service: ScheduleService) {
        self.service = service
        let data = service.calculateSchedule(trucks: Truck.TRUCKS,
                                             chargers: Charger.CHARGERS,
                                             timeLimitHours: 8)
        schedule = data.schedule
        unscheduledTrucks = data.unscheduledTrucks
    }
}
