//
//  HomeHeaderView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import SnapKit
import UIKit

protocol HomeHeaderViewModuleInputProtocol: ModuleInputProtocol where State == HomeState.HeaderState {}
protocol HomeHeaderViewModuleOutputProtocol: ModuleOutputProtocol where Event == HomeEvent.UIEvent {}

final class HomeHeaderView: UIView {

    // MARK: - Dependencies

    private let configurationFactory: HomeHeaderViewConfigurationFactoryProtocol

    // MARK: - UI

    private let gradientView = GradientView()
    private let containerView = UIView()

    private let leadingImageView = UIImageView()
    private let contentView = UIStackView()
    private let trailingImageView = UIImageView()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let searchTextField = UITextField()

    // MARK: - Initialization

    init(configurationFactory: HomeHeaderViewConfigurationFactoryProtocol) {
        self.configurationFactory = configurationFactory
        super.init(frame: .zero)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientView.snp.makeConstraints {
            $0.bottom.equalTo(containerView.snp.bottom).inset(10)
        }
    }

    // MARK: - Private

    private func setupUI() {
        addSubviews(gradientView, containerView)
        containerView.addSubviews(leadingImageView, contentView, trailingImageView)
        contentView.addArrangedSubviews(titleLabel, subtitleLabel, searchTextField)

        setupGradientView()
        setupContainerView()
        setupLeadingImageView()
        setupTrailingImageView()
        setupContentView()
        setupTitleLabel()
        setupSubtitleLabel()
        setupSearchTextField()
    }

    private func setupGradientView() {
        gradientView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
    }

    private func setupContainerView() {
        containerView
            .withBackgroundColor(.Background.header)
            .withCornerRadius(24)

        containerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }

    private func setupLeadingImageView() {
        leadingImageView.tintColor = .Text.primary
        leadingImageView.contentMode = .scaleAspectFit
        leadingImageView.translatesAutoresizingMaskIntoConstraints = false

        leadingImageView.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(14)
        }
    }

    private func setupTrailingImageView() {
        trailingImageView.tintColor = .Text.primary
        trailingImageView.contentMode = .scaleAspectFit
        trailingImageView.translatesAutoresizingMaskIntoConstraints = false

        trailingImageView.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(14)
        }
    }

    private func setupContentView() {
        contentView.axis = .vertical
        contentView.alignment = .leading
        contentView.spacing = 4
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(leadingImageView.snp.trailing).offset(14)
            $0.trailing.equalTo(trailingImageView.snp.leading).offset(-14)
            $0.top.bottom.equalToSuperview().inset(18)
        }
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

// MARK: - HomeHeaderViewModuleInputProtocol

extension HomeHeaderView: HomeHeaderViewModuleInputProtocol {

    func apply(_ state: HomeState.HeaderState) {
        let configuration = configurationFactory.makeHeaderViewConfiguration(from: state)
        configure(with: configuration)
        updateBackgroundColor(with: state.progress)
        gradientView.offsetStartPoint(y: state.progress)
    }
}

// MARK: - Configuration

extension HomeHeaderView {

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

    private func updateBackgroundColor(with progress: CGFloat) {
        let newBackgroundColor = UIColor.interpolate(
            from: .Background.header,
            to: .Background.neutral1,
            progress: progress)
        containerView.backgroundColor = newBackgroundColor
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
