//
//  ImageCache.swift
//  JSONPlaceholder
//
//  Created by Jeffrey Tabios on 6/23/24.
//

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private let url: URL?
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?

    init(url: URL?, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }

    deinit {
        cancellable?.cancel()
    }

    func load() {
        guard let url else { return }
        if let image = cache?[url] {
            self.image = image
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] image in
                if let image = image {
                    self?.cache?[self?.url] = image
                }
            })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

struct AsyncImageLoaderView: View {
    @StateObject private var imageLoader: ImageLoader

    init(url: URL?) {
        _imageLoader = StateObject(wrappedValue: ImageLoader(url: url, cache: ImageCache.shared))
    }

    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            ProgressView()
                .onAppear {
                    imageLoader.load()
                }
        }
    }
}

// Simple in-memory cache
class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSURL, UIImage>()

    subscript(key: URL?) -> UIImage? {
        get { key.flatMap { cache.object(forKey: $0 as NSURL) } }
        set {
            guard let key = key else { return }
            if let image = newValue {
                cache.setObject(image, forKey: key as NSURL)
            } else {
                cache.removeObject(forKey: key as NSURL)
            }
        }
    }
}
