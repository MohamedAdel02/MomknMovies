//
//  NetworkHelper.swift
//  MomknMovies
//
//  Created by Mohamed Adel on 22/08/2026.
//

import Foundation
 
enum APIEnvironment {
 
    case production
 
    var baseURL: String {
        switch self {
        case .production:
            return "https://api.themoviedb.org/"
        }
    }
 
    var version: String {
        switch self {
        case .production:
            return "3"
        }
    }
}
 
enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
 
struct HTTPRequest {
    
    var url: URL
    var method: HTTPMethod = .get
    var body: Data?
    var headers: [String: String] = [:]
    var queryItems: [URLQueryItem] = []
}

enum MoviePath: String {
   
   
   //Movies
   case movieDetails       = "movie"
   case popularMovies      = "movie/popular"
   case topRatedMovies     = "movie/top_rated"
   case upcomingMovies     = "movie/upcoming"
  
   //TV
   case showDetails        = "tv"
   case topRatedTVShows    = "tv/top_rated"
   case popularTVShows     = "tv/popular"
    
    //genres
    case genres            = "genre/movie/list"
   
   //Actors
   case personDetails      = "person"
   
   //Search
   case search             = "search/movie"

}


enum MovieEndpoint {

    case movieDetails(id: Int)
    case movieCast(id: Int)
    case popularMovies(page: Int)
    case topRatedMovies(page: Int)
    case upcomingMovies(page: Int)

    case showDetails(id: Int)
    case topRatedTVShows(page: Int)
    case popularTVShows(page: Int)

    case genres

    case personDetails(id: Int)

    case search(_ query: String)


   private var environment: APIEnvironment { .production }

   private var path: String {
       switch self {
       case .movieDetails(let id):
           return "\(MoviePath.movieDetails.rawValue)/\(id)"
       case .movieCast(let id):
           return "\(MoviePath.movieDetails.rawValue)/\(id)/credits"
       case .popularMovies:
           return MoviePath.popularMovies.rawValue
       case .topRatedMovies:
           return MoviePath.topRatedMovies.rawValue
       case .upcomingMovies:
           return MoviePath.upcomingMovies.rawValue
       case .showDetails(let id):
           return "\(MoviePath.showDetails.rawValue)/\(id)"
       case .topRatedTVShows:
           return MoviePath.topRatedTVShows.rawValue
       case .popularTVShows:
           return MoviePath.popularTVShows.rawValue
       case .genres:
           return MoviePath.genres.rawValue
       case .personDetails(let id):
           return "\(MoviePath.personDetails.rawValue)/\(id)"
       case .search:
           return MoviePath.search.rawValue
      
       }
   }
    
    private var page: Int {
        switch self {
        case .popularMovies(let page),
             .topRatedMovies(let page),
             .upcomingMovies(let page),
             .topRatedTVShows(let page),
             .popularTVShows(let page):
            return page
        default:
            return 1
        }
    }

    private var queryItems: [URLQueryItem] {
        
        let language = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"

        
        var items = [
            URLQueryItem(name: "api_key", value: "0d699223dc630e1d65cc7c6941884b31"),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "page", value: String(page))
        ]

        switch self {
        case .search(let query):
            items.append(URLQueryItem(name: "query", value: query))
        default:
            break
        }

        return items
    }
    
   func asHTTPRequest() throws -> HTTPRequest {
       let fullURLString = environment.baseURL + environment.version + "/" + path

       guard var components = URLComponents(string: fullURLString) else {
           throw NetworkError.invalidURL
       }
       components.queryItems = queryItems

       guard let url = components.url else {
           throw NetworkError.invalidURL
       }

       return HTTPRequest(url: url, method: .get, headers: [:], queryItems: queryItems)
   }
}
