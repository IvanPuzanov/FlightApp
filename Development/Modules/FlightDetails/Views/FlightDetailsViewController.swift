//
//  FlightDetailsViewController.swift
//  FlightDemoApp
//
//  Created by Ivan Puzanov on 09.07.2026.
//

import UIKit

final class FlightDetailsViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Public

    private func setupUI() {
        setupAsBottomSheet()
    }

    private func setupAsBottomSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .large
        }
    }
}
