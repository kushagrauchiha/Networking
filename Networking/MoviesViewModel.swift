// MoviesViewModel.swift
import Foundation
import Combine
import NetworkSDK

class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    private var cancellables = Set<AnyCancellable>()
    
    func getPopularMovies() {
        NetworkManager.shared.fetchPopularMovies()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] movies in
                self?.movies = movies
            })
            .store(in: &cancellables)
    }
    
    func getLatestMovies() {
        NetworkManager.shared.fetchNowPlayingMovies()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] movies in
                self?.movies = movies
            })
            .store(in: &cancellables)
    }
}
