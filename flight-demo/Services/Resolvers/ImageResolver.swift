//
//  ImageResolver.swift
//  flight-demo
//
//  Created by Ivan Puzanov on 05.07.2026.
//

import Combine
import UIKit

protocol ImageResolverProtocol: AnyObject {
    func resolveImage(from url: URL, fallback: UIImage?, completion: @escaping (UIImage?) -> Void)
}

final class ImageResolver: ImageResolverProtocol {

    // MARK: - Properties

    private var bag: Set<AnyCancellable> = []

    // MARK: - Pubic

    func resolveImage(from url: URL, fallback: UIImage?, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: fallback)
            .receive(on: DispatchQueue.main)
            .sink { image in
                completion(image)
            }.store(in: &bag)
    }
}
