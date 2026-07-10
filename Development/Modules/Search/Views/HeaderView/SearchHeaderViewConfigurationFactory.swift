//
//  SearchHeaderViewConfigurationFactory.swift
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

protocol SearchHeaderViewConfigurationFactoryDelegate: AnyObject {
    func trailingIconButtonDidTap(mode: SearchState.HeaderState.Mode)
}

protocol SearchHeaderViewConfigurationFactoryProtocol: AnyObject {
    func makeHeaderViewConfiguration(
        from state: SearchState.HeaderState
    ) -> SearchHeaderViewConfiguration
}

final class SearchHeaderConfigurationFactory: SearchHeaderViewConfigurationFactoryProtocol {

    // MARK: - Properties

    weak var delegate: SearchHeaderViewConfigurationFactoryDelegate?

    // MARK: - Public

    func makeHeaderViewConfiguration(
        from state: SearchState.HeaderState
    ) -> SearchHeaderViewConfiguration {
        switch state.mode {
        case let .flightInfo(number, description):
            return SearchHeaderViewConfiguration(
                mode: createHeaderViewFlightInfoMode(
                    number: number,
                    description: description,
                    onTrailingIconTap: { [weak self] in
                        self?.delegate?.trailingIconButtonDidTap(mode: state.mode)
                    }
                )
            )
        case let .search(text):
            return SearchHeaderViewConfiguration(
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
    ) -> SearchHeaderViewConfiguration.Mode {
        .flightInfo(
            SearchHeaderViewConfiguration.FlightDetailsModel(
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
    ) -> SearchHeaderViewConfiguration.Mode {
        .search(
            SearchHeaderViewConfiguration.SearchModel(
                leadingIcon: Constants.searchLeadingIcon,
                text: text,
                placeholderText: "Search flight or airline",
                trailingIcon: Constants.searchTrailingIcon,
                onTrailingIconTap: onTrailingIconTap
            )
        )
    }
}
