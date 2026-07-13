//
//  SearchFlightListItemView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 01.07.2026.
//

import SnapKit
import UIKit

final class SearchFlightListItemView: UIView {

    // MARK: - Dependencies

    private let imageResolver = ImageResolver()

    // MARK: - UI

    private let priceBadge = BadgeView()
    private let airlineImageView = UIImageView()

    private let baggageStackView = UIStackView()
    private let baggageBadgeView = BadgeView()
    private let carryOnBadgeView = BadgeView()

    private let originLabelsStackView = UIStackView()
    private let originIataLabel = UILabel()
    private let originCityLabel = UILabel()

    private let destinationLabelsStackView = UIStackView()
    private let destinationIataLabel = UILabel()
    private let destinationCityLabel = UILabel()

    private let tapGestureRecognizer =  UITapGestureRecognizer()

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
        addSubviews(priceBadge, airlineImageView, baggageStackView, originLabelsStackView, destinationLabelsStackView)
        baggageStackView.addArrangedSubviews(baggageBadgeView, carryOnBadgeView)
        originLabelsStackView.addArrangedSubviews(originIataLabel, originCityLabel)
        destinationLabelsStackView.addArrangedSubviews(destinationIataLabel, destinationCityLabel)

        setupView()
        setupPriceBadgeView()
        setupAirlineImageView()
        setupBaggageStackView()
        setupOriginLabelsStackView()
        setupDestinationLabelStackView()
        setupTapGestureRecognizer()
    }

    private func setupView() {
        withBackgroundColor(.Background.elevation2)
        withCornerRadius(24)
        withShadow()
    }

    private func setupPriceBadgeView() {
        priceBadge.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(16)
        }
    }

    private func setupAirlineImageView() {
        airlineImageView.layer.cornerRadius = 15
        airlineImageView.clipsToBounds = true

        airlineImageView.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(16)
            $0.size.equalTo(30)
        }
    }

    private func setupBaggageStackView() {
        baggageStackView.spacing = 8
        baggageStackView.snp.makeConstraints {
            $0.top.equalTo(airlineImageView.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
    }

    private func setupOriginLabelsStackView() {
        originLabelsStackView.axis = .vertical
        originLabelsStackView.setCustomSpacing(2, after: originIataLabel)
        originLabelsStackView.setCustomSpacing(5, after: originCityLabel)

        originLabelsStackView.snp.makeConstraints {
            $0.top.equalTo(baggageStackView.snp.bottom).offset(14)
            $0.leading.bottom.equalToSuperview().inset(16)
        }
    }

    private func setupDestinationLabelStackView() {
        destinationLabelsStackView.axis = .vertical
        destinationLabelsStackView.setCustomSpacing(2, after: destinationIataLabel)
        destinationLabelsStackView.setCustomSpacing(5, after: destinationCityLabel)

        destinationLabelsStackView.snp.makeConstraints {
            $0.top.equalTo(baggageStackView.snp.bottom).offset(14)
            $0.trailing.bottom.equalToSuperview().inset(16)
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

extension SearchFlightListItemView: ConfigurableView {

    func configure(with configuration: SearchFlightListItemViewConfiguration) {
        priceBadge.configure(with: configuration.priceBadgeViewConfiguration)
        configureAirlineImageView(with: configuration.airlineImageUrl)
        configureBaggageBadgeView(
            baggageBadgeView,
            configuration: configuration.baggageBadgeViewConfiguration
        )
        configureBaggageBadgeView(
            carryOnBadgeView,
            configuration: configuration.carryOnBadgeViewConfiguration
        )
        originIataLabel.configure(with: configuration.originIataLabelConfiguration)
        originCityLabel.configure(with: configuration.originCityLabelConfiguration)
        destinationIataLabel.configure(with: configuration.destinationIataLabelConfiguration)
        destinationCityLabel.configure(with: configuration.destinationCityLabelConfiguration)
        onTap = configuration.onTap
    }

    func prepareForReuse() {
        airlineImageView.image = nil
        imageResolver.cancel()
    }

    private func configureAirlineImageView(with imageURL: URL?) {
        guard let imageURL else { return }

        imageResolver.resolveImage(
            from: imageURL,
            fallback: UIImage(systemName: "airplane.departure")
        ) { [weak self] image in
            self?.airlineImageView.image = image
        }
    }

    private func configureBaggageBadgeView(_ badgeView: BadgeView, configuration: BadgeViewConfiguration?) {
        if let configuration {
            badgeView.isHidden = false
            badgeView.configure(with: configuration)
        } else {
            badgeView.isHidden = true
        }
    }
}
