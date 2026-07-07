//
//  HomeEvent.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import MapKit

enum HomeEvent {
    case ui(UIEvent)
    case data(DataEvent)
}

extension HomeEvent {
    enum UIEvent {
        case map(MapEvent)
        case header(HeaderEvent)
        case flightList(FlightListEvent)
        case common(CommonEvent)
    }

    enum DataEvent {
        case onGetLocation(Coordinate)
        case onGetLocationFailed

        case onAirportsLoaded([Airport])
        case onAirportsFailed

        case onFlightsLoaded([Flight])
        case onFlightsFailed
    }
}

extension HomeEvent.UIEvent {
    enum MapEvent {
        case onMapDidLoad
        case onDefaultRegionSet
    }

    enum HeaderEvent {
        case onFilterTap
        case onMoreTap
        case onSearchStartEditing
        case onSearchTextEnter(text: String?)
        case onSearchTextEndEditing
    }

    enum FlightListEvent {
        case onSetup(
            cornerRadius: CGFloat,
            shadowOpacity: Float,
            detents: [HomeState.FlightListState.BottomSheetDetent]
        )
        case onBottomSheetHeightChange(progress: CGFloat)
        case onDetentSet(CGFloat)
        case onMapButtonTap
    }

    enum CommonEvent {
        case onViewDidLoad
        case onCalculateFlightListMaxHeight(CGFloat)
    }
}
