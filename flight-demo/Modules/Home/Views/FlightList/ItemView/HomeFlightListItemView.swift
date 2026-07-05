//
//  HomeFlightListItemView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import SnapKit
import UIKit

final class HomeFlightListItemView: UIView {

    // MARK: - UI

    private let airlineImageView = UIImageView()
    private let airlineLabel = UILabel()

    private let badgesContainerView = UIStackView()
    private let flightNumberBadgeView = BadgeView()
    private let aircraftBadgeView = BadgeView()

    private let originAirportCityLabel = UILabel()
    private let originAirportIATALabel = UILabel()

    private let destinationAirportCityLabel = UILabel()
    private let destinationAirportIATALabel = UILabel()

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
        addSubviews(airlineImageView, airlineLabel, badgesContainerView, originAirportCityLabel, originAirportIATALabel, destinationAirportCityLabel, destinationAirportIATALabel)
        badgesContainerView.addArrangedSubviews(flightNumberBadgeView, aircraftBadgeView)

        setupView()
        setupAirlineImageView()
        setupAirlineLabel()
        setupBadgesContainerView()
        setupOriginAirportIATALabel()
        setupOriginAirportCityLabel()
        setupDestinationAirportIATALabel()
        setupDestinationAirportCityLabel()
    }

    private func setupView() {
        withBackgroundColor(.quaternarySystemFill)
        withCornerRadius(24)
    }

    private func setupAirlineImageView() {
        airlineImageView.contentMode = .scaleAspectFit
        airlineImageView.tintColor = .Text.primary
        airlineImageView.withCornerRadius(12)
        airlineImageView.withBackgroundColor(.quaternarySystemFill)

        airlineImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.leading.top.equalToSuperview().inset(16)
        }
    }

    private func setupAirlineLabel() {
        airlineLabel.snp.makeConstraints {
            $0.trailing.lessThanOrEqualTo(badgesContainerView.snp.leading).offset(-12)
            $0.leading.equalTo(airlineImageView.snp.trailing).offset(12)
            $0.centerY.equalTo(airlineImageView)
        }
    }

    private func setupBadgesContainerView() {
        badgesContainerView.spacing = 8

        badgesContainerView.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(16)
        }
    }

    private func setupOriginAirportIATALabel() {
        originAirportIATALabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(16)
        }
    }

    private func setupOriginAirportCityLabel() {
        originAirportCityLabel.snp.makeConstraints {
            $0.leading.equalTo(originAirportIATALabel)
            $0.bottom.equalTo(originAirportIATALabel.snp.top).offset(-4)
            $0.top.equalTo(airlineImageView.snp.bottom).offset(40)
        }
    }

    private func setupDestinationAirportIATALabel() {
        destinationAirportIATALabel.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(16)
        }
    }

    private func setupDestinationAirportCityLabel() {
        destinationAirportCityLabel.snp.makeConstraints {
            $0.trailing.equalTo(destinationAirportIATALabel)
            $0.bottom.equalTo(destinationAirportIATALabel.snp.top).offset(-4)
            $0.top.equalTo(airlineImageView.snp.bottom).offset(40)
        }
    }
}

// MARK: - ConfigurableView

extension HomeFlightListItemView: ConfigurableView {

    func configure(with configuration: HomeFlightListItemViewConfiguration) {
        airlineImageView.image = configuration.airlineImage
        airlineLabel.configure(with: configuration.airlineLabelConfiguration)
        flightNumberBadgeView.configure(with: configuration.flightNumberBadgeConfiguration)
        aircraftBadgeView.configure(with: configuration.aircarftBadgeConfiguration)
        originAirportCityLabel.configure(with: configuration.originCityLabelConfiguration)
        originAirportIATALabel.configure(with: configuration.originIATALabelConfiguration)
        destinationAirportCityLabel.configure(with: configuration.destinationCityLabelConfiguration)
        destinationAirportIATALabel.configure(with: configuration.destinationIATALabelConfiguration)
    }
}
