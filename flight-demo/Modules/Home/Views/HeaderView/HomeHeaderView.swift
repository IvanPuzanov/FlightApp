//
//  HomeHeaderView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import UIKit

final class HomeHeaderView: UIView {

    // MARK: - UI

    private let leadingImageView = UIImageView()
    private let contentView = UIStackView()
    private let trailingImageView = UIImageView()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let searchTextField = UITextField()

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
        addSubviews(leadingImageView, contentView, trailingImageView)
        contentView.addArrangedSubviews(titleLabel, subtitleLabel, searchTextField)

        setupLeadingImageView()
        setupTrailingImageView()
        setupContentView()
        setupTitleLabel()
        setupSubtitleLabel()
        setupSearchTextField()
    }

    private func setupLeadingImageView() {
        leadingImageView.tintColor = .Text.primary
        leadingImageView.contentMode = .scaleAspectFit
        leadingImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leadingImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            leadingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leadingImageView.heightAnchor.constraint(equalToConstant: 24),
            leadingImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupTrailingImageView() {
        trailingImageView.tintColor = .Text.primary
        trailingImageView.contentMode = .scaleAspectFit
        trailingImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            trailingImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            trailingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingImageView.heightAnchor.constraint(equalToConstant: 24),
            trailingImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupContentView() {
        contentView.axis = .vertical
        contentView.alignment = .leading
        contentView.spacing = 4
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingImageView.trailingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: trailingImageView.leadingAnchor, constant: -16),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 18),
            contentView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -18)
        ])
    }

    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.textColor = .Text.primary
    }

    private func setupSubtitleLabel() {
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = .secondaryLabel
    }

    private func setupSearchTextField() {
        searchTextField.font = .systemFont(ofSize: 16)
        searchTextField.textColor = .Text.primary
    }
}

// MARK: - ConfigurableView

extension HomeHeaderView: ConfigurableView {

    func configure(with configuration: HomeHeaderViewConfiguration) {
        UIView.animate(withDuration: 0.3) {
            switch configuration.mode {
            case let .flightInfo(model):
                self.configureFlightDetails(from: model)
            case let .search(model):
                self.configureSearch(from: model)
            }

            self.updateVisibility(for: configuration.mode)
        }
    }

    private func updateVisibility(for mode: HomeHeaderViewConfiguration.Mode) {
        switch mode {
        case .flightInfo:
            titleLabel.alpha = 1
            titleLabel.isHidden = false

            subtitleLabel.alpha = 1
            subtitleLabel.isHidden = false

            searchTextField.alpha = 0
            searchTextField.isHidden = true
        case .search:
            titleLabel.alpha = 0
            titleLabel.isHidden = true

            subtitleLabel.alpha = 0
            subtitleLabel.isHidden = true

            searchTextField.alpha = 1
            searchTextField.isHidden = false
        }
    }

    private func configureFlightDetails(from model: HomeHeaderViewConfiguration.FlightDetailsModel) {
        leadingImageView.image = model.leadingIcon
        trailingImageView.image = model.trailingIcon
        titleLabel.text = model.titleLabelText
        subtitleLabel.text = model.subtitleLabelText
    }

    private func configureSearch(from model: HomeHeaderViewConfiguration.SearchModel) {
        leadingImageView.image = model.leadingIcon
        trailingImageView.image = model.trailingIcon
        searchTextField.text = model.text
        searchTextField.placeholder = model.placeholderText
    }
}
