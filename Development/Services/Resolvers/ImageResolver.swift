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
    func cancel()
}

final class ImageResolver: ImageResolverProtocol {

    // MARK: - Properties

    private let urlSession = URLSession(configuration: .default)
    private var bag: Set<AnyCancellable> = []

    // MARK: - Pubic

    func resolveImage(from url: URL, fallback: UIImage?, completion: @escaping (UIImage?) -> Void) {
        let key = url.absoluteString

        if let data = ResponseCache.shared.get(for: key), let image = UIImage(data: data) {
            completion(image)
        } else {
            urlSession
                .dataTaskPublisher(for: url)
                .handleEvents(receiveOutput: { output in
                    ResponseCache.shared.set(output.data, for: key)
                })
                .map { UIImage(data: $0.data) }
                .replaceError(with: fallback)
                .receive(on: DispatchQueue.main)
                .sink { image in
                    completion(image)
                }.store(in: &bag)
        }
    }

    func cancel() {
        bag.removeAll()
    }
}
