//
//  SchedulingService.swift
//  FleetScheduling-Chandan
//
//  Created by Chandan Sharda on 27/08/25.
//

import Foundation

final class ScheduleService {
    func calculateSchedule(trucks: [Truck], chargers: [Charger], timeLimitHours: Double) -> (schedule: [Charger: [Truck]], unscheduledTrucks: [Truck]) {

        let sortedTrucks = trucks.sorted { $0.kwhNeeded < $1.kwhNeeded }
        var schedule: [Charger: [Truck]] = [:]

        var chargerAvailableTime: [Charger: Double] = chargers.reduce(into: [:]) { result, charger in
            result[charger] = timeLimitHours
        }
        var unscheduledTrucks: [Truck] = []

        for charger in chargers {
            schedule[charger] = []
        }

        for truck in sortedTrucks {
            var assigned = false
            for charger in chargers {
                guard let availableTime = chargerAvailableTime[charger] else { continue }
                let hoursToCharge = truck.kwhNeeded / charger.chargingRateKw
                if hoursToCharge <= availableTime {
                    schedule[charger]?.append(truck)
                    chargerAvailableTime[charger]? -= hoursToCharge
                    assigned = true
                    break
                }
            }

            // if charger is out of capacity
            if !assigned {
                unscheduledTrucks.append(truck)
            }
        }
        return (schedule, unscheduledTrucks)
    }
}
