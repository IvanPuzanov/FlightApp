//
//  HomeBottomSheetViewController.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import UIKit

protocol HomeBottomSheetViewControllerProtocol: AnyObject {}

final class HomeBottomSheetViewController: UIViewController {

    // MARK: - Dependencies

    private let presenter: HomePresenterProtocol

    // MARK: - UI

    private let panGestureRecognizer = UIPanGestureRecognizer()

    // MARK: - Initialization

    init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Private

    private func setupUI() {
        setupAppearance()
        setupGestureRecognizer()
    }

    private func setupAppearance() {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    private func setupGestureRecognizer() {
        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
    }
}

// MARK: - HomeBottomSheetViewController

extension HomeBottomSheetViewController: HomeBottomSheetViewControllerProtocol {}

// MARK: -

extension HomeBottomSheetViewController: UIGestureRecognizerDelegate {
}
