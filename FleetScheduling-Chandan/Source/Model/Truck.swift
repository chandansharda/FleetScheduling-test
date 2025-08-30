//
//  Truck.swift
//  FleetScheduling-Chandan
//
//  Created by Chandan Sharda on 27/08/25.
//

struct Truck: CustomStringConvertible, Hashable {
    let id: String
    let batteryCapacityKwh: Double
    var currentChargePercentage: Double
    
    var kwhNeeded: Double {
        return batteryCapacityKwh * (100.0 - currentChargePercentage) / 100.0
    }
    
    var description: String {
        return "🚚 Truck-\(id) (\(String(format: "%.1f", currentChargePercentage))% charged)"
    }

    static let TRUCKS: [Truck] = [
        Truck(id: "1", batteryCapacityKwh: 100.0, currentChargePercentage: 60.0),
        Truck(id: "2", batteryCapacityKwh: 120.0, currentChargePercentage: 80.0),
        Truck(id: "3", batteryCapacityKwh: 80.0, currentChargePercentage: 10.0),
        Truck(id: "4", batteryCapacityKwh: 150.0, currentChargePercentage: 50.0),
        Truck(id: "5", batteryCapacityKwh: 90.0, currentChargePercentage: 45.0)
    ]
}

extension Truck: ListItem {}
