//
//  FleetManagerViewController.swift
//  FleetScheduling-Chandan
//
//  Created by Chandan Sharda on 27/08/25.
//

import UIKit

enum FleetOptionType {
    case truckList
    case chargerList
    case scheduling

    var title: String {
        switch self {
        case .truckList: return "Truck List"
        case .chargerList: return "Charger List"
        case .scheduling: return "Scheduling"
        }
    }
}

protocol FleetOptionCellDelegate: AnyObject {
    func didTapOption(_ option: FleetOptionType)
}

final class FleetManagerViewController: UIViewController {

    private let listOfOptions: [FleetOptionType]
    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Int, FleetOptionType>!
    weak var delegate: FleetOptionCellDelegate?

    init(listOfOptions: [FleetOptionType], _ delegate: FleetOptionCellDelegate? = nil) {
        self.listOfOptions = listOfOptions
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fleet Manager"
        view.backgroundColor = .systemBackground
        setupTableView()
        setUpDataSource()
        applySnapshot()
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(FleetOptionCell.self, forCellReuseIdentifier: FleetOptionCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setUpDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, FleetOptionType>(tableView: tableView) { [weak self] tableView, indexPath, option in
            guard let self = self,
                  let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: FleetOptionCell.reuseIdentifier,
                    for: indexPath
                ) as? FleetOptionCell
            else { return UITableViewCell() }

            cell.configure(with: option, delegate: self)
            return cell
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FleetOptionType>()
        snapshot.appendSections([0])
        snapshot.appendItems(listOfOptions)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Cell Delegate
extension FleetManagerViewController: FleetOptionCellDelegate {
    func didTapOption(_ option: FleetOptionType) {
        self.delegate?.didTapOption(option)
    }
}
