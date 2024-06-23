//
//  ApiService.swift
//  JSONPlaceholder
//
//  Created by Jeffrey Tabios on 6/23/24.
//

import Foundation
import Combine

protocol APIService {
    func fetchPhotos(page: Int) -> AnyPublisher<[Photo], Error>
}

class RealAPIService: APIService {
    private let baseUrl = "https://jsonplaceholder.typicode.com/photos"

    func fetchPhotos(page: Int) -> AnyPublisher<[Photo], Error> {
        let url = URL(string: "\(baseUrl)?_page=\(page)&_limit=20")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Photo].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
