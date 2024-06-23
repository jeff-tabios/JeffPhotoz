//
//  PhotoListViewModel.swift
//  JSONPlaceholder
//
//  Created by Jeffrey Tabios on 6/23/24.
//

import Foundation
import Combine

class PhotoListViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var errorMessage: AppError?
    @Published var isLoading = false

    private let apiService: APIService
    private var cancellables = Set<AnyCancellable>()

    init(apiService: APIService = RealAPIService()) {
        self.apiService = apiService
        loadCachedPhotos()
        fetchPhotos()
    }

    func loadCachedPhotos() {
        if apiService is RealAPIService {
            photos = CoreDataManager.shared.fetchCachedPhotos()
        }
    }

    func fetchPhotos(page: Int = 1) {
        self.isLoading = false
        apiService.fetchPhotos(page: page)
            .receive(on: DispatchQueue.main) // Ensure UI updates on the main thread
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    break
                case .failure(let error):
                    self.errorMessage = AppError(message: error.localizedDescription)
                }
            }, receiveValue: { fetchedPhotos in
                self.photos.append(contentsOf: fetchedPhotos)
                CoreDataManager.shared.savePhotos(fetchedPhotos)
            })
            .store(in: &cancellables)
    }
}
