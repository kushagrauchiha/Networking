import Foundation

enum URLHelper {
    static func posterImageURL(from path: String) -> URL? {
        let url = URL(string: "https://image.tmdb.org/t/p/w342")?.appending(path: path)
        return url
    }

    static func backdropImageURL(from path: String) -> URL? {
        let url = URL(string: "https://image.tmdb.org/t/p/w780")?.appending(path: path)
        return url
    }
}
