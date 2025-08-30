//
//  FleetOptionCell.swift
//  FleetScheduling-Chandan
//
//  Created by chandan Sharda on 27/08/25.
//
import UIKit

final class FleetOptionCell: UITableViewCell {
    static let reuseIdentifier = "FleetOptionCell"

    private let optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var option: FleetOptionType?
    weak var delegate: FleetOptionCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(optionButton)

        NSLayoutConstraint.activate([
            optionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            optionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            optionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            optionButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        optionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with option: FleetOptionType, delegate: FleetOptionCellDelegate) {
        self.option = option
        self.delegate = delegate
        optionButton.setTitle(option.title, for: .normal)
    }

    @objc private func buttonTapped() {
        guard let option = option else { return }
        delegate?.didTapOption(option)
    }
}
