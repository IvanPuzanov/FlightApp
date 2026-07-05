//
//  BottomSheetViewController.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 30.06.2026.
//

import SnapKit
import UIKit

protocol BottomSheetContentViewProtocol: UIView & ScrollProvider & ModuleInputProtocol {
    var bottomSheet: BottomSheetProtocol? { get set }

    func dispatch(_ event: BottomSheetEvent)
}

protocol BottomSheetProtocol: AnyObject {
    func setupDetents(_ detents: [CGFloat])
}

final class BottomSheetViewController<ContentView: BottomSheetContentViewProtocol>: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - UI

    private let contentView: ContentView
    private lazy var panGestureRecognizer = UIPanGestureRecognizer()
    private var animator: UIViewPropertyAnimator?

    // MARK: - Properties

    private var detents: [CGFloat] = []
    private var currentHeight: CGFloat {
        heightConstraint?.layoutConstraints.first?.constant ?? 0
    }
    private var maxDetent: CGFloat = 0
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
        view.addSubviews(contentView)

        setupAppearance()
        setupGestureRecognizer()
        setupContentView()
    }

    private func setupAppearance() {
        view.snp.makeConstraints {
            heightConstraint = $0.height.equalTo(120).constraint
        }
    }

    private func setupGestureRecognizer() {
        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture))
    }

    private func setupContentView() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    @objc
    private func handlePanGesture() {
        switch panGestureRecognizer.state {
        case .began:
            animator?.stopAnimation(true)
        case .changed:
            let translation = panGestureRecognizer.translation(in: view)
            let newHeight = currentHeight - translation.y
            updateScrollViewAvailability()

            guard newHeight <= maxDetent else { return }

            applyHeight(newHeight)
        case .cancelled, .ended:
            let velocity = panGestureRecognizer.velocity(in: view)
            clipToNearestDetent(with: velocity.y)
        default:
            break
        }

        panGestureRecognizer.setTranslation(.zero, in: view)
    }

    private func applyHeight(_ height: CGFloat, animated: Bool = false) {
        animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.9) {
            self.heightConstraint?.update(offset: height)
            self.view.superview?.layoutIfNeeded()
            self.dispacthEventOnHeightChange()
        }

        animator?.startAnimation()
    }

    private func dispacthEventOnHeightChange() {
        let progress = currentHeight / maxDetent
        contentView.dispatch(.onProgressDidChange(progress))
    }

    private func clipToNearestDetent(with velocity: CGFloat) {
        let targetHeight: CGFloat

        switch velocity {
        case ..<(-800):
            targetHeight = detents.first(where: { $0 > currentHeight }) ?? maxDetent
        case 800...:
            targetHeight = detents.last(where: { $0 < currentHeight }) ?? detents[0]
        default:
            targetHeight = detents.min {
                abs($0 - currentHeight) < abs($1 - currentHeight)
            } ?? currentHeight
        }

        applyHeight(targetHeight, animated: true)
    }

    private func updateScrollViewAvailability() {
        let translation = panGestureRecognizer.translation(in: view)
        let scrollView = contentView.scrollView
        let isScrollOnTop = scrollView.contentOffset.y <= 0
        let isAtMaxDetent = currentHeight >= maxDetent
        let isSwipingDown = translation.y > 0

        if isAtMaxDetent {
            scrollView.isScrollEnabled = !(isSwipingDown && isScrollOnTop)
        } else {
            scrollView.isScrollEnabled = false
        }
    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer === panGestureRecognizer else { return true }

        return currentHeight < maxDetent || contentView.scrollView.contentOffset.y <= 0
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        gestureRecognizer === panGestureRecognizer
        && otherGestureRecognizer === contentView.scrollView.panGestureRecognizer
    }
}

// MARK: - BottomSheetProtocol

extension BottomSheetViewController: BottomSheetProtocol {

    func setupDetents(_ detents: [CGFloat]) {
        guard self.detents != detents else { return }

        self.detents = detents.sorted()
        self.maxDetent = detents.last ?? 0
        if let minHeight = detents.min() {
            applyHeight(minHeight)
        }
    }
}
