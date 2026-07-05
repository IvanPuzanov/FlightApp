//
//  TableViewReusableCell.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import SnapKit
import UIKit

final class TableViewReusableCell<View: UIView & ConfigurableView>: UITableViewCell {

    // MARK: - Identifier

    static var reuseIdentifier: String {
        return String(describing: View.self)
    }

    // MARK: - UI

    private var view = View()
    private var masksToBoundsObserver: NSKeyValueObservation?

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        masksToBoundsObserver = layer.observe(\.masksToBounds, changeHandler: { [weak self] _, _ in
            self?.layer.masksToBounds = false
        })
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        view.prepareForReuse()
    }

    // MARK: - Private

    private func setupUI() {
        contentView.addSubview(view)
        backgroundColor = .clear
        selectionStyle = .none
        layer.masksToBounds = false

        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - ConfigurableView

extension TableViewReusableCell: ConfigurableView {

    func configure(with configuration: TableViewReusableCellConfiguration<View>) {
        view.configure(with: configuration.viewConfiguration)
    }
}

