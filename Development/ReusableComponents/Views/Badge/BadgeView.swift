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
        containerView.spacing = 4
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.bottom.equalToSuperview().inset(4)
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(8)
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
        configureImageView(with: configuration.imageConfiguration)
        titleLabel.configure(with: configuration.labelConfiguration)
        configureInsets(configuration.insets)
        backgroundColor = configuration.backgroundColor
    }

    private func configureImageView(with configuration: BadgeViewConfiguration.ImageConfiguration?) {
        if let configuration {
            imageView.isHidden = false
            imageView.image = configuration.image
            imageView.tintColor = configuration.tintColor
        } else {
            imageView.isHidden = true
        }
    }

    private func configureInsets(_ insets: Insets) {
        containerView.snp.updateConstraints {
            switch insets {
            case let .eachSide(inset):
                $0.top.bottom.leading.trailing.equalToSuperview().inset(inset)
            case let .custom(top, bottom, left, right):
                containerView.snp.updateConstraints {
                    $0.top.equalToSuperview().inset(top)
                    $0.bottom.equalToSuperview().inset(bottom)
                    $0.leading.equalToSuperview().inset(left)
                    $0.trailing.equalToSuperview().inset(right)
                }
            }
        }

    }
}
