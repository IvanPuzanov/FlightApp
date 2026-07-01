//
//  StatusView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import SnapKit
import UIKit

final class StatusView: UIView {

    // MARK: - UI

    private let containerView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

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
        addSubview(containerView)
        containerView.addArrangedSubviews(imageView, titleLabel, subtitleLabel)

        setupContainerView()
        setupImageView()
    }

    private func setupContainerView() {
        containerView.axis = .vertical
        containerView.alignment = .center
        containerView.setCustomSpacing(20, after: imageView)
        containerView.setCustomSpacing(4, after: titleLabel)

        containerView.snp.makeConstraints {
            $0.height.lessThanOrEqualToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill

        imageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
        }
    }
}

// MARK: - ConfigurableView

extension StatusView: ConfigurableView {

    func configure(with configuration: StatusViewConfiguration) {
        imageView.image = configuration.image
        imageView.tintColor = configuration.imageColor
        titleLabel.configure(with: configuration.titleLabelConfiguration)
        subtitleLabel.configure(with: configuration.subtitleLabelConfiguration)
    }
}
