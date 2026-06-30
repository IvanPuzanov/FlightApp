//
//  BottomSheetViewController.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import SnapKit
import UIKit

protocol BottomSheetContentViewProtocol: UIView & ModuleInputProtocol {
    var bottomSheet: BottomSheetProtocol? { get set }

    func dispatch(_ event: BottomSheetEvent)
}

protocol BottomSheetProtocol: AnyObject {
    func setupDetents(_ detents: [CGFloat])
}

final class BottomSheetViewController<ContentView: BottomSheetContentViewProtocol>: UIViewController {

    // MARK: - UI

    private let grabberView = UIView()
    private let contentView: ContentView
    private lazy var panGestureRecognizer = UIPanGestureRecognizer()

    // MARK: - Properties

    private var detents: [CGFloat] = []
    private var currentHeight: CGFloat {
        heightConstraint?.layoutConstraints.first?.constant ?? 0
    }
    private var heightConstraint: Constraint?

    // MARK: - Initialization

    init(contentView: ContentView) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
        self.contentView.bottomSheet = self
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
        view.addSubviews(grabberView, contentView)

        setupAppearance()
        setupGestureRecognizer()
        setupGrabberView()
    }

    private func setupAppearance() {
        view.withBackgroundColor(.systemBackground)
            .withCornerRadius(44, corners: [.topLeft, .topRight])
            .withShadow(offsetY: -10)

        view.snp.makeConstraints {
            heightConstraint = $0.height.equalTo(120).constraint
        }
    }

    private func setupGestureRecognizer() {
        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture))
    }

    private func setupGrabberView() {
        grabberView
            .withBackgroundColor(.separator)
            .withCornerRadius(3)

        grabberView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(6)
            $0.top.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
        }
    }

    private func setupContentView() {
        contentView.snp.makeConstraints {
            $0.top.equalTo(grabberView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
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
            self.heightConstraint?.update(offset: height)
            self.view.superview?.layoutIfNeeded()
            self.dispacthEventOnHeightChange()
        }
    }

    private func dispacthEventOnHeightChange() {
        contentView.dispatch(.onHeightDidChange(0))
    }

    private func clipToNearestDetent() {
        if let nearestHeight = detents.min(by: { abs(currentHeight - $0) < abs(currentHeight - $1) }) {
            applyHeight(nearestHeight, animated: true)
        }
    }
}

// MARK: - BottomSheetProtocol

extension BottomSheetViewController: BottomSheetProtocol {

    func setupDetents(_ detents: [CGFloat]) {
        guard self.detents != detents else { return }

        self.detents = detents.sorted()
        if let minHeight = detents.min() {
            applyHeight(minHeight)
        }
    }
}
