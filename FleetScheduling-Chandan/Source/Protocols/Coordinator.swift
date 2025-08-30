//
//  Coordinator.swift
//  FleetScheduling-Chandan
//
//  Created by chandan Sharda on 27/08/25.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let options: [FleetOptionType] = [.truckList, .chargerList, .scheduling]
        let fleetVC = FleetManagerViewController(listOfOptions: options, self)
        navigationController.pushViewController(fleetVC, animated: false)
    }
}

extension MainCoordinator: FleetOptionCellDelegate {
    func didTapOption(_ option: FleetOptionType) {
        switch option {
        case .truckList:
            moveToListController(withTitle: "Trucks", items: Truck.TRUCKS.map { AnyListItem($0) })
        case .chargerList:
            moveToListController(withTitle: "Chargers", items: Charger.CHARGERS.map { AnyListItem($0) })
        case .scheduling:
            let controller = ScheduleViewController()
            navigationController.pushViewController(controller, animated: true)
        }

    }

    func moveToListController(withTitle title: String, items: [AnyListItem]) {
        let controller = ListViewController(title: title, items: items)
        navigationController.pushViewController(controller, animated: true)
    }
}
