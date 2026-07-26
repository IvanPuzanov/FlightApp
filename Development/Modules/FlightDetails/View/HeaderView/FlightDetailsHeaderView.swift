//
//  FlightDetailsHeaderView.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 17.07.2026.
//

import SnapKit
import UIKit

final class FlightDetailsHeaderView: UIView {

    // MARK: - UI

    private let timeLabel = UILabel()

    private let originStackView = UIStackView()
    private let originLabel = UILabel()
    private let originIATALabel = UILabel()
    private let originCityLabel = UILabel()

    private let destinationStackView = UIStackView()
    private let destinationLabel = UILabel()
    private let destinationIATALabel = UILabel()
    private let destinationCityLabel = UILabel()

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
        addSubviews(timeLabel, originStackView, destinationStackView)
        originStackView.addArrangedSubviews(
            originLabel, originIATALabel, originCityLabel
        )
        destinationStackView.addArrangedSubviews(
            destinationLabel, destinationIATALabel, destinationCityLabel
        )

        setupTimeLabel()
        setupOriginStackView()
        setupDestinationStackView()
    }

    private func setupTimeLabel() {
        timeLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }

    private func setupOriginStackView() {
        originStackView.axis = .vertical
        originStackView.spacing = 2

        originStackView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.bottom.equalTo(timeLabel.snp.top).offset(-4)
        }
    }

    private func setupDestinationStackView() {
        destinationStackView.axis = .vertical
        destinationStackView.spacing = 2

        destinationStackView.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()
            $0.bottom.equalTo(timeLabel.snp.top).offset(-4)
        }
    }
}

// MARK: - ConfigurableView

extension FlightDetailsHeaderView: ConfigurableView {

    func configure(with configuration: FlightDetailsHeaderViewConfiguration) {
        originLabel.configure(with: configuration.originLabelConfiguration)
        originIATALabel.configure(with: configuration.originIataLabelConfiguration)
        originCityLabel.configure(with: configuration.originCityLabelConfiguration)
        destinationLabel.configure(with: configuration.destinationLabelConfiguration)
        destinationIATALabel.configure(with: configuration.destinationIataLabelConfiguration)
        destinationCityLabel.configure(with: configuration.destinationCityLabelConfiguration)
        timeLabel.configure(with: configuration.timeLabelConfiguration)
    }
}
