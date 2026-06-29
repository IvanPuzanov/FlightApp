//
//  HomeBottomSheetViewController.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import UIKit

protocol HomeBottomSheetViewControllerProtocol: AnyObject {
    func apply(state: HomeState.BottomSheetState)
}

final class HomeBottomSheetViewController: UIViewController {

    // MARK: - Dependencies

    private let presenter: HomePresenterProtocol

    // MARK: - UI

    private lazy var panGestureRecognizer = UIPanGestureRecognizer(
        target: self,
        action: #selector(handlePanGesture)
    )
    private var heightConstraint = NSLayoutConstraint()

    // MARK: - Properties

    private var detents: [HomeState.BottomSheetState.Detent] = []
    private var currentHeight: CGFloat {
        heightConstraint.constant
    }

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
        view.withBackgroundColor(.systemBackground)
            .withCornerRadius(44, corners: [.topLeft, .topRight])
            .withShadow(offsetY: -10)

        heightConstraint = view.heightAnchor.constraint(equalToConstant: 120)
        NSLayoutConstraint.activate([heightConstraint].compactMap { $0 })
    }

    private func setupGestureRecognizer() {
        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
    }

    @objc
    private func handlePanGesture() {
        switch panGestureRecognizer.state {
        case .began:
            break
        case .changed:
            let translation = panGestureRecognizer.translation(in: view)
            let newHeight = currentHeight - translation.y
            applyHeight(newHeight)
        case .cancelled, .ended:
            clipToNearestDetent()
        default:
            break
        }

        panGestureRecognizer.setTranslation(.zero, in: view)
    }

    private func applyHeight(_ height: CGFloat, animated: Bool = false) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.heightConstraint.constant = height
            self.view.superview?.layoutIfNeeded()
        }
    }

    private func clipToNearestDetent() {
        let heights = detents.map { detent in
            switch detent {
            case let .compact(height), let .medium(height), let .custom(height):
                return height
            }
        }

        let nearestHeight = heights.min { abs(currentHeight - $0) < abs(currentHeight - $1) }
        guard let nearestHeight else { return }

        applyHeight(nearestHeight, animated: true)
    }
}

// MARK: - HomeBottomSheetViewController

extension HomeBottomSheetViewController: HomeBottomSheetViewControllerProtocol {

    func apply(state: HomeState.BottomSheetState) {
        detents = state.detents
        for case let .compact(height) in detents {
            applyHeight(height)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension HomeBottomSheetViewController: UIGestureRecognizerDelegate {
    // TODO: - Add pan gesutre handling
}
