//
//  ContainerView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import SnapKit
import UIKit

final class ContainerView<View: UIView & ConfigurableView>: UIView {

    // MARK: - UI

    private let contentView = View()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private

    private func setupUI() {
        addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview().inset(0)
        }
    }
}

// MARK: - ConfigurableView

extension ContainerView: ConfigurableView {

    func configure(with configuration: ContainerViewConfiguration<View>) {
        contentView.configure(with: configuration.viewConfiguration)
        configureInsets(configuration.insets)
    }

    private func configureInsets(_ insets: Insets) {
        contentView.snp.updateConstraints {
            switch insets {
            case let .eachSide(inset):
                $0.leading.trailing.top.bottom.equalToSuperview().inset(inset)
            case let .custom(top, bottom, left, right):
                $0.top.equalToSuperview().inset(top)
                $0.bottom.equalToSuperview().inset(bottom)
                $0.leading.equalToSuperview().inset(left)
                $0.trailing.equalToSuperview().inset(right)
            }
        }
    }
}
