//
//  HomeViewController.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 28.06.2026.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Dependecies

    private let presenter: HomePresenterProtocol

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
        presenter.dispatch(.onViewDidLoad)
    }

    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = .systemBackground
    }

}
