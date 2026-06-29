//
//  GradientView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import UIKit

private enum Constants {
    static let gradientColors: [UIColor] = [
        .Background.elevation1.withAlphaComponent(0.8),
        .Background.elevation1.withAlphaComponent(0)
    ]
}

final class GradientView: UIView {

    // MARK: - UI

    private lazy var gradientLayer = CAGradientLayer()

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

        gradientLayer.frame = bounds
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        
        gradientLayer.colors = Constants.gradientColors.map { $0.cgColor }
    }

    // MARK: - Private

    private func setupUI() {
        isUserInteractionEnabled = false

        gradientLayer.colors = Constants.gradientColors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        layer.addSublayer(gradientLayer)
    }
}
