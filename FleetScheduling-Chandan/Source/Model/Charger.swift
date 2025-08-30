//
//  Charger.swift
//  FleetScheduling-Chandan
//
//  Created by Chandan Sharda on 27/08/25.
//

class Charger: CustomStringConvertible, Hashable {
    let id: String
    let chargingRateKw: Double
    var isExpanded: Bool = false
    var description: String { "Charger-\(id) 🔋\(chargingRateKw)kwh" }

    init(id: String, chargingRateKw: Double, isExpanded: Bool = false) {
        self.id = id
        self.chargingRateKw = chargingRateKw
        self.isExpanded = isExpanded
    }

    func toggleIsExpanded() {
        isExpanded = !isExpanded
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static let CHARGERS: [Charger] = [
        Charger(id: "A", chargingRateKw: 10.0),
        Charger(id: "B", chargingRateKw: 15.0),
        Charger(id: "C", chargingRateKw: 10.0)
    ]

    static func == (lhs: Charger, rhs: Charger) -> Bool {
        lhs.id == rhs.id
    }
}


extension Charger: ListItem {}
