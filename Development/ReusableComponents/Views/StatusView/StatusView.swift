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
    private let actionButton = UIButton()

    // MARK: - Properties

    private var onButtonTap: (() -> Void)?

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
        containerView.addArrangedSubviews(imageView, titleLabel, subtitleLabel, actionButton)

        setupContainerView()
        setupImageView()
        setupActionButton()
    }

    private func setupContainerView() {
        containerView.axis = .vertical
        containerView.setCustomSpacing(20, after: imageView)
        containerView.setCustomSpacing(4, after: titleLabel)
        containerView.setCustomSpacing(20, after: subtitleLabel)

        containerView.snp.makeConstraints {
            $0.height.lessThanOrEqualToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }

    private func setupImageView() {
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
        }
    }

    private func setupActionButton() {
        actionButton.addAction(
            UIAction { [weak self] _ in
                self?.onButtonTap?()
            },
            for: .touchUpInside
        )

        actionButton
            .withCornerRadius(18)
            .withBackgroundColor(.quaternarySystemFill)

        actionButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
}

// MARK: - ConfigurableView

extension StatusView: ConfigurableView {

    func configure(with configuration: StatusViewConfiguration) {
        imageView.configure(with: configuration.imageViewConfiguration)
        titleLabel.configure(with: configuration.titleLabelConfiguration)
        subtitleLabel.configure(with: configuration.subtitleLabelConfiguration)
        configureActionButton(with: configuration.actionButtonConfiguration)
    }

    private func configureActionButton(
        with configuration: StatusViewConfiguration.ButtonConfiguration?
    ) {
        if let configuration {
            onButtonTap = configuration.onTap
            actionButton.setTitle(configuration.text, for: .normal)
            actionButton.isHidden = false
        } else {
            actionButton.isHidden = true
        }
    }
}
