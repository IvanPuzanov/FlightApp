//
//  HomeHeaderViewConfigurationFactory.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import UIKit

private enum Constants {
    static let flightInfoLeadingIcon = UIImage(systemName: "arrow.left") ?? UIImage()
    static let flightInfoTrailingIcon = UIImage(systemName: "ellipsis") ?? UIImage()

    static let searchLeadingIcon = UIImage(systemName: "magnifyingglass") ?? UIImage()
    static let searchTrailingIcon = UIImage(systemName: "slider.horizontal.3") ?? UIImage()
}

protocol HomeHeaderViewConfigurationFactoryDelegate: AnyObject {
    func trailingIconButtonDidTap(mode: HomeState.HeaderState.Mode)
}

protocol HomeHeaderViewConfigurationFactoryProtocol: AnyObject {
    func makeHeaderViewConfiguration(
        from state: HomeState.HeaderState
    ) -> HomeHeaderViewConfiguration
}

final class HomeHeaderConfigurationFactory: HomeHeaderViewConfigurationFactoryProtocol {

    // MARK: - Properties

    weak var delegate: HomeHeaderViewConfigurationFactoryDelegate?

    // MARK: - Public

    func makeHeaderViewConfiguration(
        from state: HomeState.HeaderState
    ) -> HomeHeaderViewConfiguration {
        switch state.mode {
        case let .flightInfo(number, description):
            return HomeHeaderViewConfiguration(
                mode: createHeaderViewFlightInfoMode(
                    number: number,
                    description: description,
                    onTrailingIconTap: { [weak self] in
                        self?.delegate?.trailingIconButtonDidTap(mode: state.mode)
                    }
                )
            )
        case let .search(text):
            return HomeHeaderViewConfiguration(
                mode: createHeaderViewSearchMode(
                    text: text,
                    onTrailingIconTap: { [weak self] in
                        self?.delegate?.trailingIconButtonDidTap(mode: state.mode)
                    }
                )
            )
        }
    }

    // MARK: - Private

    private func createHeaderViewFlightInfoMode(
        number: String,
        description: String,
        onTrailingIconTap: (() -> Void)?
    ) -> HomeHeaderViewConfiguration.Mode {
        .flightInfo(
            HomeHeaderViewConfiguration.FlightDetailsModel(
                leadingIcon: Constants.flightInfoLeadingIcon,
                titleLabelText: number,
                subtitleLabelText: description,
                trailingIcon: Constants.flightInfoTrailingIcon,
                onTrailingIconTap: onTrailingIconTap
            )
        )
    }

    private func createHeaderViewSearchMode(
        text: String?,
        onTrailingIconTap: (() -> Void)?
    ) -> HomeHeaderViewConfiguration.Mode {
        .search(
            HomeHeaderViewConfiguration.SearchModel(
                leadingIcon: Constants.searchLeadingIcon,
                text: text,
                placeholderText: "Search flight or airline",
                trailingIcon: Constants.searchTrailingIcon,
                onTrailingIconTap: onTrailingIconTap
            )
        )
    }
}
