//
//  ListViewController.swift
//  FleetScheduling-Chandan
//
//  Created by chandan Sharda on 27/08/25.
//

import UIKit

protocol ListItem {
    var description: String { get }
}

struct AnyListItem: Hashable {
    private let base: any ListItem
    var description: String { base.description }


    init(_ base: any ListItem) { self.base = base }

    static func == (lhs: AnyListItem, rhs: AnyListItem) -> Bool {
        lhs.description == rhs.description
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(base.description)
    }
}

final class ListViewController: UIViewController {

    private let items: [AnyListItem]
    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Int, AnyListItem>!

    init(title: String, items: [AnyListItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        setupDataSource()
        applySnapshot(animatingDifferences: false)
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, AnyListItem>(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = item.description
            cell.contentConfiguration = content
            return cell
        }
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AnyListItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
