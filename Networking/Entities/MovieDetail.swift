import Foundation

struct MovieDetailResponse: Codable {
    public let results: [MovieDetail]
}

public struct MovieDetail: Codable, Identifiable {
    let adult: Bool
    let backdropPath: String
    let budget: Int
    let genres: [GenreInfo]
    public let id: Int
    let homepage: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let revenue: Int
    let runtime: Int
    let tagline: String
    let title: String

    struct GenreInfo: Codable, Identifiable {
        let id: Int
        let name: String
    }
}
