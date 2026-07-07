//
//  AirportMarkerView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 07.07.2026.
//

import MapKit
import SnapKit
import UIKit

final class AirportMarkerView: MKAnnotationView {

    // MARK: - UI

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    // MARK: - Initialization

    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        configureCornerRadiusIfNeeded()
    }

    // MARK: - Public

    func asImage() -> UIImage {
        let targetSize = systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )
        bounds = CGRect(origin: .zero, size: targetSize)
        layoutIfNeeded()

        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }

    // MARK: - Private

    private func setupUI() {
        addSubviews(imageView, titleLabel, subtitleLabel)
        withBackgroundColor(.Background.elevation1)
        withShadow()

        setupImageView()
        setupTitleLabel()
        setupSubtitleLabel()
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label

        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
    }

    private func setupTitleLabel() {
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(imageView.snp.centerY)
            $0.leading.equalTo(imageView.snp.trailing).offset(14)
            $0.trailing.equalToSuperview().inset(14)
            $0.top.equalToSuperview().inset(4)
        }
    }

    private func setupSubtitleLabel() {
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.centerY)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(4)
        }
    }
}

// MARK: - ConfigurableView

extension AirportMarkerView: ConfigurableView {

    func configure(with configuration: AirportMarkerViewConfiguration) {
        imageView.image = configuration.image
        titleLabel.configure(with: configuration.iataLabelConfiguration)
        subtitleLabel.configure(with: configuration.countryLabelConfiguration)
    }

    private func configureCornerRadiusIfNeeded() {
        if layer.cornerRadius != bounds.height / 2 {
            layer.cornerRadius = bounds.height / 2
        }
    }
}
