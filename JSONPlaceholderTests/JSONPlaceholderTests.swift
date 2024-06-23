//
//  JSONPlaceholderTests.swift
//  JSONPlaceholderTests
//
//  Created by Jeffrey Tabios on 6/23/24.
//
import XCTest
import Combine
@testable import JSONPlaceholder

class PhotoListViewModelTests: XCTestCase {

    var viewModel: PhotoListViewModel!
    var mockAPIService: MockAPIService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = PhotoListViewModel(apiService: mockAPIService)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchPhotosSuccess() {
        let expectation = XCTestExpectation(description: "Photos fetched successfully")

        viewModel.$photos
            .sink { photos in
                if photos.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)

        XCTAssertEqual(viewModel.photos.count, 2)
        XCTAssertEqual(viewModel.photos[0].title, "Test Photo 1")
        XCTAssertEqual(viewModel.photos[1].title, "Test Photo 2")
    }

    func testFetchPhotosFailure() {
        let expectation = XCTestExpectation(description: "Error message received")

        mockAPIService.shouldReturnError = true

        viewModel.$errorMessage
            .sink { errorMessage in
                if errorMessage != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchPhotos()

        wait(for: [expectation], timeout: 5.0)

        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage?.message, "Mock error")
    }
}

class MockAPIService: APIService {
    var shouldReturnError = false

    func fetchPhotos(page: Int) -> AnyPublisher<[Photo], Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"]))
                .eraseToAnyPublisher()
        } else {
            let photos = [
                Photo(id: 1, title: "Test Photo 1", thumbnailUrl: "https://via.placeholder.com/150", url: "https://via.placeholder.com/600"),
                Photo(id: 2, title: "Test Photo 2", thumbnailUrl: "https://via.placeholder.com/150", url: "https://via.placeholder.com/600")
            ]
            return Just(photos)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
