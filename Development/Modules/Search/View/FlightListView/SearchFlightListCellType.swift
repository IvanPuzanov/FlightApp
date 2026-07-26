//
//  SearchFlightListCellType.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import Foundation

enum SearchFlightListCellType: Equatable {
    case shimmer(TableViewReusableCellConfiguration<ContainerView<ShimmerView>>)
    case flight(TableViewReusableCellConfiguration<ContainerView<SearchFlightListItemView>>)
}

extension SearchFlightListCellType: Identifiable {

    var id: String {
        switch self {
        case let .shimmer(cellConfiguration):
            return cellConfiguration.viewConfiguration.viewConfiguration.id
        case let .flight(cellConfiguration):
            return cellConfiguration.viewConfiguration.viewConfiguration.id
        }
    }
}
