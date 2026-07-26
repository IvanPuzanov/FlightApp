//
//  SearchFlightListMapButton.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 05.07.2026.
//

import SnapKit
import UIKit

final class SearchFlightListMapButton: UIView {

    // MARK: - UI

    private let imageView = UIImageView()
    private let label = UILabel()
    private let tapGesture = UITapGestureRecognizer()

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
    
    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2
    }

    // MARK: - Private

    private func setupUI() {
        addSubviews(imageView, label)

        setupImageView()
        setupLabel()
        setupTapGestureRecognizer()
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit

        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(14)
            $0.top.bottom.greaterThanOrEqualToSuperview().inset(14)
            $0.width.height.equalTo(24)
        }
    }

    private func setupLabel() {
        label.snp.makeConstraints {
            $0.centerY.equalTo(imageView)
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(14)
        }
    }

    private func setupTapGestureRecognizer() {
        addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(handleOnTap))
    }

    @objc
    private func handleOnTap() {
        onTap?()
    }
}

// MARK: - ConfigurableView

extension SearchFlightListMapButton: ConfigurableView {

    func configure(with configuration: SearchFlightListMapButtonConfiguration) {
        imageView.image = configuration.image
        imageView.tintColor = configuration.imageTintColor
        label.configure(with: configuration.labelConfiguration)
        backgroundColor = configuration.backgroundColor
        onTap = configuration.onTap
    }
}
