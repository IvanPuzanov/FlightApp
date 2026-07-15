//
//  SearchHeaderView.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import Combine
import SnapKit
import UIKit

final class SearchHeaderView: UIView {

    // MARK: - Dependencies

    private let store: SearchStoreProtocol
    private let configurationFactory: SearchHeaderViewConfigurationFactoryProtocol

    // MARK: - UI

    private let gradientView = GradientView()
    private let containerView = UIView()

    private let leadingIconButton = UIButton()
    private let contentView = UIStackView()
    private let trailingIconButton = UIButton()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let searchTextField = UITextField()

    // MARK: - Properties

    private var bag: Set<AnyCancellable> = []
    private var onLeadingIconTap: (() -> Void)?
    private var onTrailingIconTap: (() -> Void)?

    // MARK: - Initialization

    init(
        store: SearchStoreProtocol,
        configurationFactory: SearchHeaderViewConfigurationFactoryProtocol
    ) {
        self.store = store
        self.configurationFactory = configurationFactory
        super.init(frame: .zero)

        setupBindings()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setupBindings() {
        store.stateDidChange
            .compactMap { [weak store] in
                store?.state.headerState
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.apply(state)
            }.store(in: &bag)
    }

    private func setupUI() {
        addSubviews(gradientView, containerView)
        containerView.addSubviews(leadingIconButton, contentView, trailingIconButton)
        contentView.addArrangedSubviews(titleLabel, subtitleLabel, searchTextField)

        setupContainerView()
        setupLeadingIconButton()
        setupTrailingIconButton()
        setupContentView()
        setupTitleLabel()
        setupSubtitleLabel()
        setupSearchTextField()
        setupGradientView()
    }

    private func setupGradientView() {
        gradientView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(contentView).offset(10)
        }
    }

    private func setupContainerView() {
        containerView
            .withBackgroundColor(.systemBackground)
            .withCornerRadius(24)

        containerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }

    private func setupLeadingIconButton() {
        leadingIconButton.tintColor = .Text.primary
        leadingIconButton.contentMode = .scaleAspectFit
        leadingIconButton.addAction(UIAction { [weak self] _ in
            self?.onLeadingIconTap?()
        }, for: .touchUpInside)

        leadingIconButton.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(14)
        }
    }

    private func setupTrailingIconButton() {
        trailingIconButton.tintColor = .Text.primary
        trailingIconButton.contentMode = .scaleAspectFit
        trailingIconButton.addAction(UIAction { [weak self] _ in
            self?.onTrailingIconTap?()
        }, for: .touchUpInside)

        trailingIconButton.snp.makeConstraints {
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
            $0.leading.equalTo(leadingIconButton.snp.trailing).offset(14)
            $0.trailing.equalTo(trailingIconButton.snp.leading).offset(-14)
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
        searchTextField.delegate = self
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.font = .systemFont(ofSize: 16)
        searchTextField.returnKeyType = .done
        searchTextField.textColor = .Text.primary
        searchTextField.addTarget(self, action: #selector(handleSearchTextTyping), for: .editingChanged)

        searchTextField.snp.makeConstraints {
            $0.width.equalTo(contentView)
        }
    }

    @objc
    private func handleSearchTextTyping() {
        store.dispatch(event: .ui(.header(.onSearchTextEnter(text: searchTextField.text))))
    }

    private func apply(_ state: SearchState.HeaderState) {
        let configuration = configurationFactory.makeHeaderViewConfiguration(from: state)
        configure(with: configuration)

        updateBackgroundColor(with: state.bottomSheetProgress)
        gradientView.offsetStartPoint(y: state.bottomSheetProgress)
    }
}

// MARK: - UITextFieldDelegate

extension SearchHeaderView: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        store.dispatch(event: .ui(.header(.onSearchStartEditing)))
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        store.dispatch(event: .ui(.header(.onSearchTextEndEditing)))
        return textField.resignFirstResponder()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        store.dispatch(event: .ui(.header(.onSearchTextEndEditing)))
    }
}

// MARK: - SearchHeaderViewConfigurationFactoryDelegate

extension SearchHeaderView: SearchHeaderViewConfigurationFactoryDelegate {

    func leadingIconButtonDidTap(mode: SearchState.HeaderState.Mode) {
        switch mode {
        case .flightInfo:
            store.dispatch(event: .ui(.header(.onBackTap)))
        case .search:
            break
        }
    }

    func trailingIconButtonDidTap(mode: SearchState.HeaderState.Mode) {
        switch mode {
        case .flightInfo:
            store.dispatch(event: .ui(.header(.onFilterTap)))
        case .search:
            store.dispatch(event: .ui(.header(.onMoreTap)))
        }
    }
}

// MARK: - Configuration

extension SearchHeaderView {

    func configure(with configuration: SearchHeaderViewConfiguration) {
        UIView.animate(withDuration: 0.3) {
            self.updateVisibility(for: configuration.mode)
            
            switch configuration.mode {
            case let .flightInfo(model):
                self.configureFlightDetails(from: model)
            case let .search(model):
                self.configureSearch(from: model)
            }
        } completion: { _ in
            self.setNeedsLayout()
        }
    }

    private func updateBackgroundColor(with progress: CGFloat) {
        let newBackgroundColor = UIColor.interpolate(
            from: .systemBackground,
            to: .secondarySystemBackground,
            progress: progress
        )
        containerView.backgroundColor = newBackgroundColor
    }

    private func updateVisibility(for mode: SearchHeaderViewConfiguration.Mode) {
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

    private func configureFlightDetails(from model: SearchHeaderViewConfiguration.FlightDetailsModel) {
        leadingIconButton.setImage(model.leadingIcon, for: .normal)
        trailingIconButton.setImage(model.trailingIcon, for: .normal)
        titleLabel.text = model.titleLabelText
        subtitleLabel.text = model.subtitleLabelText
        onLeadingIconTap = model.onLeadingIconTap
        onTrailingIconTap = model.onTrailingIconTap
    }

    private func configureSearch(from model: SearchHeaderViewConfiguration.SearchModel) {
        leadingIconButton.setImage(model.leadingIcon, for: .normal)
        trailingIconButton.setImage(model.trailingIcon, for: .normal)
        searchTextField.text = model.text
        searchTextField.placeholder = model.placeholderText
        onTrailingIconTap = model.onTrailingIconTap
    }
}
