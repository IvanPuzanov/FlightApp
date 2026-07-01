//
//  BadgeView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import SnapKit
import UIKit

final class BadgeView: UIView {

    // MARK: - UI

    private let containerView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2
    }

    // MARK: - Private

    private func setupUI() {
        addSubview(containerView)
        containerView.addArrangedSubviews(imageView, titleLabel)

        setupContainerView()
        setupImageView()
    }

    private func setupContainerView() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit

        imageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
    }
}

// MARK: - ConfigurableView

extension BadgeView: ConfigurableView {

    func configure(with configuration: BadgeViewConfiguration) {
        imageView.image = configuration.image
        imageView.isHidden = configuration.image == nil
        titleLabel.configure(with: configuration.labelConfiguration)
        backgroundColor = configuration.backgroundColor
    }
}
