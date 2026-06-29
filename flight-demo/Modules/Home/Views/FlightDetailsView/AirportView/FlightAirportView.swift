//
//  FlightAirportView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import SnapKit
import UIKit

final class FlightAirportView: UIView {

    // MARK: - UI

    private let containerView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let descriptionLabel = UILabel()

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
        containerView.addArrangedSubviews(titleLabel, subtitleLabel, descriptionLabel)

        setupContainerView()
    }

    private func setupContainerView() {
        containerView.spacing = 4
        containerView.axis = .vertical
        containerView.alignment = .center

        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview().inset(18)
            $0.bottom.lessThanOrEqualToSuperview().inset(18)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
    }
}

// MARK: - ConfigurableView

extension FlightAirportView: ConfigurableView {

    func configure(with configuration: FlightAirportViewConfiguration) {
        backgroundColor = configuration.backgroundColor
        titleLabel.configure(with: configuration.titleLabelConfiguration)
        subtitleLabel.configure(with: configuration.subtitleLabelConfiguration)
        descriptionLabel.configure(with: configuration.descriptionLabelConfiguration)
    }
}
