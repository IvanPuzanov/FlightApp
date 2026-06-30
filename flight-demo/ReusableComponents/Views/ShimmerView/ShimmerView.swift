//
//  ShimmerView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import SnapKit
import UIKit

final class ShimmerView: UIView {

    // MARK: - Properties

    private var heightConstraint: Constraint?
    private static let animationStartTime = CACurrentMediaTime()

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
        backgroundColor = .secondarySystemFill
        withCornerRadius(24)

        snp.makeConstraints {
            heightConstraint = $0.height.equalTo(100).constraint
        }
    }

    private func startAnimation() {
        if layer.animation(forKey: "shimmer") != nil {
            return
        }

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.3
        animation.duration = 0.8
        animation.autoreverses = true
        animation.repeatCount = .infinity

        animation.beginTime = Self.animationStartTime

        layer.add(animation, forKey: "shimmer")
    }

    private func stopAnimation() {
        layer.removeAllAnimations()
    }
}

// MARK: - ConfigurableView

extension ShimmerView: ConfigurableView {

    func configure(with configuration: ShimmerViewConfiguration) {
        heightConstraint?.update(offset: configuration.height)
        startAnimation()
    }

    func prepareForReuse() {
        stopAnimation()
    }
}
