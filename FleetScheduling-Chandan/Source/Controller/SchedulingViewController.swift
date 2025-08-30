//
//  SchedulingViewController.swift
//  FleetScheduling-Chandan
//
//  Created by chandan Sharda on 28/08/25.
//

import UIKit

final class ScheduleViewController: UIViewController {

    // MARK: - Types
    enum Section: Int, CaseIterable {
        case chargers
        case unscheduled

        var sectionHeader: String {
            switch self {
            case .chargers:
                return "Chargers with scheduled trucks"
            case .unscheduled:
                return "Unscheduled Trucks"
            }
        }
    }

    enum ListRow: Hashable {
        case charger(Charger, truckCount: Int)
        case truck(Truck)
    }

    // MARK: - Properties
    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Section, ListRow>!
    private let viewModel: FleetSchedulingViewModel

    // MARK: - Init
    init() {
        self.viewModel = FleetSchedulingViewModel(.init())
        super.init(nibName: nil, bundle: nil)
        self.title = "Schedule"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        setupDataSource()
        applySnapshot()
    }

    // MARK: - Setup
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, ListRow>(
            tableView: tableView
        ) { tableView, indexPath, row in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var content = cell.defaultContentConfiguration()

            switch row {
            case .charger(let charger, let truckCount):
                content.text = charger.description
                content.secondaryText = "\(truckCount) trucks"
                cell.accessoryType = .disclosureIndicator
            case .truck(let truck):
                content.text = truck.description
                cell.accessoryType = .none
            }

            cell.contentConfiguration = content
            return cell
        }
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ListRow>()

        // Chargers section
        snapshot.appendSections([.chargers])
        for (charger, trucks) in viewModel.schedule {
            snapshot.appendItems([.charger(charger, truckCount: trucks.count)], toSection: .chargers)

            if charger.isExpanded {
                let truckRows = (viewModel.schedule[charger] ?? []).map { ListRow.truck($0) }
                snapshot.appendItems(truckRows, toSection: .chargers)
            }
        }

        // Unscheduled trucks section
        snapshot.appendSections([.unscheduled])
        let truckRows = viewModel.unscheduledTrucks.map { ListRow.truck($0) }
        snapshot.appendItems(truckRows, toSection: .unscheduled)

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = dataSource.itemIdentifier(for: indexPath) else { return }
        tableView.deselectRow(at: indexPath, animated: true)

        switch row {
        case .charger(let charger, _):
            charger.toggleIsExpanded()
            applySnapshot()
        case .truck:
            break
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SectionHeaderView.reuseIdentifier
        ) as? SectionHeaderView else {
            return nil
        }

        let section = dataSource.snapshot().sectionIdentifiers[section]
        header.configure(title: section.sectionHeader)
        return header
    }
}
