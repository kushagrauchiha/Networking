// MoviesViewModelTests.swift
import XCTest
import Combine
@testable import Networking

class MoviesViewModelTests: XCTestCase {
    var viewModel: MoviesViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = MoviesViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetPopularMovies() {
        let expectation = self.expectation(description: "Get Popular Movies")
        
        viewModel.$movies
            .dropFirst()
            .sink { movies in
                XCTAssertFalse(movies.isEmpty, "Movies array should not be empty")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.getPopularMovies()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
