//
//  HomeFlightListItemView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import SnapKit
import UIKit

final class HomeFlightListItemView: UIView {

    // MARK: - Dependencies

    private let imageResolver = ImageResolver()

    // MARK: - UI

    private let airlineImageView = UIImageView()
    private let airlineLabel = UILabel()
    private let flightNumberLabel = UILabel()

    private let statusBadgeView = BadgeView()

    private let originAirportCityLabel = UILabel()
    private let originAirportIATALabel = UILabel()

    private let destinationAirportCityLabel = UILabel()
    private let destinationAirportIATALabel = UILabel()

    private let tapGestureRecognizer = UITapGestureRecognizer()

    // MARK: - Properties

    private var onTap: (() -> Void)?

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
        addSubviews(airlineImageView, statusBadgeView, airlineLabel, flightNumberLabel, originAirportCityLabel, originAirportIATALabel, destinationAirportCityLabel, destinationAirportIATALabel)

        setupView()
        setupAirlineImageView()
        setupStatusBadgeView()
        setupAirlineLabel()
        setupFlightNumberLabel()
        setupOriginAirportIATALabel()
        setupOriginAirportCityLabel()
        setupDestinationAirportIATALabel()
        setupDestinationAirportCityLabel()
        setupTapGestureRecognizer()
    }

    private func setupView() {
        withBackgroundColor(.Background.elevation2)
        withCornerRadius(24)
        withShadow()
    }

    private func setupAirlineImageView() {
        airlineImageView.contentMode = .scaleAspectFill
        airlineImageView.tintColor = .Text.primary
        airlineImageView.clipsToBounds = true
        airlineImageView.withCornerRadius(19.5)
        airlineImageView.withBackgroundColor(.quaternarySystemFill)

        airlineImageView.snp.makeConstraints {
            $0.width.height.equalTo(39)
            $0.leading.top.equalToSuperview().inset(16)
        }
    }

    private func setupStatusBadgeView() {
        statusBadgeView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
        }
    }

    private func setupAirlineLabel() {
        airlineLabel.snp.makeConstraints {
            $0.trailing.lessThanOrEqualTo(statusBadgeView.snp.leading).offset(-12)
            $0.leading.equalTo(airlineImageView.snp.trailing).offset(12)
            $0.bottom.equalTo(airlineImageView.snp.centerY).offset(-1)
        }
    }

    private func setupFlightNumberLabel() {
        flightNumberLabel.snp.makeConstraints {
            $0.top.equalTo(airlineImageView.snp.centerY).offset(1)
            $0.leading.equalTo(airlineImageView.snp.trailing).offset(12)
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
            $0.top.greaterThanOrEqualTo(airlineImageView.snp.bottom).offset(40)
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
            $0.top.greaterThanOrEqualTo(airlineImageView.snp.bottom).offset(40)
        }
    }

    private func setupTapGestureRecognizer() {
        addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(handleTap))
    }

    @objc
    private func handleTap() {
        onTap?()
    }
}

// MARK: - ConfigurableView

extension HomeFlightListItemView: ConfigurableView {

    func configure(with configuration: HomeFlightListItemViewConfiguration) {
        configureImageView(with: configuration.airlineImageUrl)
        statusBadgeView.configure(with: configuration.statusBadgeViewConfiguration)
        airlineLabel.configure(with: configuration.airlineLabelConfiguration)
        flightNumberLabel.configure(with: configuration.flightNumberLabelConfiguration)
        originAirportCityLabel.configure(with: configuration.originCityLabelConfiguration)
        originAirportIATALabel.configure(with: configuration.originIATALabelConfiguration)
        destinationAirportCityLabel.configure(with: configuration.destinationCityLabelConfiguration)
        destinationAirportIATALabel.configure(with: configuration.destinationIATALabelConfiguration)
        onTap = configuration.onTap
    }

    func prepareForReuse() {
        airlineImageView.image = nil
        imageResolver.cancel()
    }

    private func configureImageView(with imageURL: URL?) {
        guard let imageURL else { return }

        imageResolver.resolveImage(
            from: imageURL,
            fallback: UIImage(systemName: "airplane.departure")
        ) { [weak self] image in
            self?.airlineImageView.image = image
        }
    }
}
