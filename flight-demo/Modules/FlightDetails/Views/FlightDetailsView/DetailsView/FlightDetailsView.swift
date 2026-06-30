//
//  FlightDetailsView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import SnapKit
import UIKit

final class FlightDetailsView: UIView {

    // MARK: - UI

    private let containerView = UIStackView()

    private let airportsContainerView = UIStackView()
    private let departureAirport = FlightAirportView()
    private let arrivalAirport = FlightAirportView()

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
        clipsToBounds = true
        layer.cornerRadius = 24

        setupContainerView()
        setupAirportsContainerView()
    }

    private func setupContainerView() {
        containerView.axis = .vertical
        containerView.spacing = 4
        containerView.addArrangedSubviews(airportsContainerView)

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupAirportsContainerView() {
        airportsContainerView.spacing = 4
        airportsContainerView.axis = .horizontal
        airportsContainerView.distribution = .fillEqually
        airportsContainerView.addArrangedSubviews(departureAirport, arrivalAirport)
    }
}

// MARK: - ConfigurableView

extension FlightDetailsView: ConfigurableView {

    func configure(with configuration: FlightDetailsViewConfiguration) {
        departureAirport.configure(with: configuration.departureAirportConfiguration)
        arrivalAirport.configure(with: configuration.arrivalAirportConfiguration)
    }
}
