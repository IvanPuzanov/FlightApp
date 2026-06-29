//
//  SegmentedControl.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 29.06.2026.
//

import SnapKit
import UIKit

final class SegmentedControl: UIView {

    // MARK: - UI

    private let segmentedControl = UISegmentedControl()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private

    private func setupUI() {
        addSubview(segmentedControl)
        setupSegmentedControl()
    }

    private func setupSegmentedControl() {
        segmentedControl.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - ConfigurableView

extension SegmentedControl: ConfigurableView {

    func configure(with configuration: SegmentedControlConfiguration) {
        segmentedControl.removeAllSegments()
        configuration.segments.enumerated().forEach { index, segment in
            segmentedControl.insertSegment(withTitle: segment.text, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = configuration.segments.firstIndex { $0.isSelected } ?? 0
    }
}
