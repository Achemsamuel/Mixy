//
//  ApiHelper.swift
//  Movie Finder
//
//  Created by Achem Samuel on 3/23/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import Foundation


/*------------------------
 Mark: Networking Methods
 ------------------------*/

extension MainViewController {
    
    //Api key fetching method
    func getApiKey () {
        guard let path = Bundle.main.path(forResource: "MovieConfiguration", ofType: "plist"), let movieConfigDict = NSDictionary.init(contentsOfFile: path) else {
            fatalError("Path/Movie Configuration Could not be found")
            
        }
        apiKey = (movieConfigDict.value(forKey: "ApiKey") as! String)
        print(apiKey!)
    }
    
    
    //movieDB Configurations Set up
    func fetchConfigurations (onComplete: @escaping (_ message : String)-> ()) -> Void {
        
        let  configurationsUrl = "\(serviceUrl)/configuration?api_key=\(apiKey!)"
        
        var request = URLRequest.init(url: URL.init(string: configurationsUrl)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                //self.noNetworkAlert()
                print("Error fetching configurations: \(String(describing: error))")
                onComplete("Error fetching configurations: \(String(describing: error))")
                
            } else {
                
                guard let configurationsJson = try! JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else { fatalError()
                }
                guard let imagesDictionary = configurationsJson.value(forKey: "images") as? NSDictionary else {
                    fatalError()
                }
                
                self.baseUrl = (imagesDictionary.value(forKey: "secure_base_url") as! String)
                print("BaseURl: \(String(describing: self.baseUrl!))")
                onComplete("BaseUrl \(String(describing: self.baseUrl!))")
            }
        }.resume()
       
    }
    
    
    /*------------------------
      Upcoming Movies Api Methods
     ------------------------*/
    func fetchUpcomingMovies (onComplete: @escaping (_ moviesResult : NSDictionary )-> (), onFailure : @escaping (_ message : String)-> ()) -> Void {
        
        let moviesUrl = "\(serviceUrl)/movie/upcoming?api_key=\(apiKey!)&language=en-US&page=1"
        
        var request = URLRequest.init(url: URL.init(string: moviesUrl)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                self.noNetworkAlert()
                onFailure("Error fetching upcoming Movies: \(String(describing: error))")
                print("Error fetching upcoming Movies: \(String(describing: error))")
            }  else {
                guard let upcomingMoviesResultJson = try! JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else {
                    fatalError("Could not get upcomingMoviesResultJson Json Serialized Object")
                }
                onComplete(upcomingMoviesResultJson)
                print("Upcoming MoviesResult Json: \(upcomingMoviesResultJson)")
            }
            
        }.resume()
       
    }
    
    
    /*------------------------
     Trending Movies Api Methods
     ------------------------*/
    func fetchTrendingMovies (onComplete : @escaping (_ moviesResult : NSDictionary)->(), onFailure : @escaping (_ message : String)->()) -> Void {
        
         let trendinMoviesUrl = ("\(serviceUrl)/trending/all/day?api_key=\(apiKey!)")
        
        var request = URLRequest.init(url: URL.init(string: trendinMoviesUrl)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                onFailure("Error fetching trending Movies: \(String(describing: error))")
                print("Error fetching trending Movies: \(String(describing: error))")
            } else {
                guard let trendingMoviesResultJson = try! JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else {
                    fatalError("Could not get trendingMoviesResultJson Json Serialized Object ")
                }
                onComplete(trendingMoviesResultJson)
                //print("Trending Movies Result Json: \(trendingMoviesResultJson)")
            }
        }.resume()
       
    }
    
    
    /*------------------------
     Top Rated Movies Api Methods
     ------------------------*/
    func fetchTopRatedMovies (onComplete : @escaping (_ moviesResult : NSDictionary)->(), onFailure: @escaping (_ message : String)->()) -> Void {
        
        let topRatedUrl = ("\(serviceUrl)/movie/top_rated?api_key=\(apiKey!)&language=en-US&page=1")
        
        var request = URLRequest.init(url: URL.init(string: topRatedUrl)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                onFailure("Error fetching top rated movies: \(String(describing: error))")
                print("Error fetching top rated movies: \(String(describing: error))")
            } else {
                
                guard let topRatedMoviesJsonResult = try! JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else {
                    fatalError("Could not get topRatedMoviesJsonResult Json Serialized Object ")
                }
                onComplete(topRatedMoviesJsonResult)
                //print("Top Rated movies JSon Result: \(topRatedMoviesJsonResult)")
            }
        }.resume()
        
    }
    
    
    /*------------------------
     Popular Movies Api Methods
     ------------------------*/
    func fetchPopularMovies (onComplete : @escaping (_ moviesResult : NSDictionary)->(), onFailure : @escaping (_ message : String)->())-> Void {
        
        let popularMoviesUrl = ("\(serviceUrl)/movie/popular?api_key=\(apiKey!)&language=en-US&page=1")
        
        var request = URLRequest.init(url: URL.init(string: popularMoviesUrl)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                onFailure("Error fetching popular movies: \(String(describing: error))")
                print("Error fetching popular movies: \(String(describing: error))")
            } else {
                guard let popularMoviesJsonResult = try! JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else {
                    fatalError("could not get popularMoviesJsonResult json serialized object")
                }
                onComplete(popularMoviesJsonResult)
                //print("Popular Movies Json Result :\(popularMoviesJsonResult)")
            }
        }.resume()
        
    }
    
    
    /*------------------------
     Live Tv Movies Api Methods
     ------------------------*/
    func fetchLiveTVShows (onComplete : @escaping (_ moviesResult : NSDictionary)->(), onFailure : @escaping (_ message : String)->()) -> Void {
        
        let liveTVUrl = ("\(serviceUrl)/tv/on_the_air?api_key=\(apiKey!)&language=en-US&page=1")
        
        var request = URLRequest.init(url: URL.init(string: liveTVUrl)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, respone, error) in
            if error != nil {
                onFailure("could not fetch live TV JSon results:\(String(describing: error))")
                print("could not fetch live TV JSon results:\(String(describing: error))")
            } else {
                guard let liveTVResultsJson = try! JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else {
                    fatalError("could not get liveTVResultsJson json object")
                }
                onComplete(liveTVResultsJson)
                //print("Live TV Results JSon :\(liveTVResultsJson)")
            }
        }.resume()
       
        
    }
    
    
    /*------------------------
     Top Rated Tv Movies Api Methods
     ------------------------*/
    func fetchTopRatedTVShows (onComplete: @escaping (_ moviesResult : NSDictionary)->(), onFailure : @escaping (_ message : String)->()) -> Void {
        
         let topRatedTVUrl = ("\(serviceUrl)/tv/top_rated?api_key=\(apiKey!)&language=en-US&page=1")
        
        var request = URLRequest.init(url: URL.init(string: topRatedTVUrl)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                onFailure("Error fetching top rated TV Shows: \(String(describing: error))")
                print("Error fetching top rated TV Shows: \(String(describing: error))")
            } else {
                guard let topRatedTVJsonResults = try! JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else {
                    fatalError("could not get topRatedTVJsonResults json object")
                }
                onComplete(topRatedTVJsonResults)
                //print("Top Rated TV JSon Result: \(topRatedTVJsonResults)")
            }
        }.resume()
        
    }
    
    
    
    func getGeneralMovieResults () {
        
        ///////////////////////////////////////////////////////////////////////
                                                                        //Upcoming Movies
        ///////////////////////////////////////////////////////////////////////
        
        fetchUpcomingMovies(onComplete: { (upcomingMoviesResult) in
            //print("Upcoming Movies Result: \(upcomingMoviesResult)")
            
            //Total Results
            self.moviesResult.pageNum = upcomingMoviesResult.value(forKey: "page") as! Int
            self.moviesResult.totalPages = upcomingMoviesResult.value(forKey: "total_pages") as! Int
            self.moviesResult.totalResults = upcomingMoviesResult.value(forKey: "total_results") as! Int
            
            //Movie Results
             let upcomingMoviesJsonArray = upcomingMoviesResult.value(forKey: "results") as! NSArray
            upcomingMoviesJsonArray.forEach({ (upcomingMoviesJsonItem) in
                
                let upcomingMoviesJsonDictionary = upcomingMoviesJsonItem as! NSDictionary
                let upcomingMovieItem = MovieItem()
                
                upcomingMovieItem.movieId = upcomingMoviesJsonDictionary.value(forKey: "id") as! Int
                upcomingMovieItem.movieTitle = upcomingMoviesJsonDictionary.value(forKey: "original_title") as! String
                upcomingMovieItem.posterPath = upcomingMoviesJsonDictionary.value(forKey: "poster_path") as! String
                upcomingMovieItem.releaseDate = upcomingMoviesJsonDictionary.value(forKey: "release_date") as! String
                upcomingMovieItem.overview = upcomingMoviesJsonDictionary.value(forKey: "overview") as! String
                upcomingMovieItem.backdropPath = upcomingMoviesJsonDictionary.value(forKey: "backdrop_path") as? String ?? "No backdrop for movie"
                
                self.moviesResult.upcomingMoviesArray.append(upcomingMovieItem)
                print("Upcoming Movies Backdrop: \(upcomingMovieItem.backdropPath)")
                
            })
            
        }) { (message) in
            print("upcoming movies message error: \(message)")
        }
        
        
        ///////////////////////////////////////////////////////////////////////
                                                                            //Trending Movies
        ///////////////////////////////////////////////////////////////////////
        
        fetchTrendingMovies(onComplete: { (trendingMoviesResult) in
            //print("Trending Movies Result: \(trendingMoviesResult)")
            
            //Total Results
            self.moviesResult.pageNum = trendingMoviesResult.value(forKey: "page") as! Int
            self.moviesResult.totalPages = trendingMoviesResult.value(forKey: "total_pages") as! Int
            self.moviesResult.totalResults = trendingMoviesResult.value(forKey: "total_results") as! Int
            
            //Movie Result
            let trendingMoviesJsonArray = trendingMoviesResult.value(forKey: "results") as! NSArray
            trendingMoviesJsonArray.forEach({ (moviesJsonItem) in
                
                let trendingMoviesJsonDictionary = moviesJsonItem as! NSDictionary
                let trendingMoviesItem = MovieItem()
                
                trendingMoviesItem.movieId = trendingMoviesJsonDictionary.value(forKey: "id") as! Int
                trendingMoviesItem.movieTitle = trendingMoviesJsonDictionary.value(forKey: "original_title") as? String ?? "No movie title availble for movie"
                trendingMoviesItem.posterPath = trendingMoviesJsonDictionary.value(forKey: "poster_path") as! String
                trendingMoviesItem.releaseDate = trendingMoviesJsonDictionary.value(forKey: "release_date") as? String ?? "No release dates available"
                trendingMoviesItem.overview = trendingMoviesJsonDictionary.value(forKey: "overview") as! String
                trendingMoviesItem.backdropPath = trendingMoviesJsonDictionary.value(forKey: "backdrop_path") as? String ?? "No backdrop for movie"
                self.moviesResult.trendingMoviesArray.append(trendingMoviesItem)
                //print("Trending Movies Backdrop: \(self.movieItem.overview)")
                
                
            })
            
        }) { (message) in
            print("tending movies message eeror :\(message)")
        }
        
        
        ///////////////////////////////////////////////////////////////////////
                                                                                //Top Rated Movies
        ///////////////////////////////////////////////////////////////////////
        
        fetchTopRatedMovies(onComplete: { (topRatedMoviesResult) in
           // print("Top Rated Movies Result: \(topRatedMoviesResult)")
            
            //Total Results
            self.moviesResult.pageNum = topRatedMoviesResult.value(forKey: "page") as! Int
            self.moviesResult.totalPages = topRatedMoviesResult.value(forKey: "total_pages") as! Int
            self.moviesResult.totalResults = topRatedMoviesResult.value(forKey: "total_results") as! Int
            
            //Movie Result
            let topRatedMoviesJsonArray = topRatedMoviesResult.value(forKey: "results") as! NSArray
            topRatedMoviesJsonArray.forEach({ (moviesJsonItem) in
                
                let topRatedMoviesJsonDictionary = moviesJsonItem as! NSDictionary
                let topRatedMoviesItem = MovieItem()
                
                topRatedMoviesItem.movieId = topRatedMoviesJsonDictionary.value(forKey: "id") as! Int
                topRatedMoviesItem.movieTitle = topRatedMoviesJsonDictionary.value(forKey: "original_title") as! String
                topRatedMoviesItem.posterPath = topRatedMoviesJsonDictionary.value(forKey: "poster_path") as! String
                topRatedMoviesItem.releaseDate = topRatedMoviesJsonDictionary.value(forKey: "release_date") as! String
                topRatedMoviesItem.overview = topRatedMoviesJsonDictionary.value(forKey: "overview") as! String
                topRatedMoviesItem.backdropPath = topRatedMoviesJsonDictionary.value(forKey: "backdrop_path") as? String ?? "No backdrop for movie"
                
                self.moviesResult.topMoviesArray.append(topRatedMoviesItem)
                //print("Top Ratd Movies Overview: \(self.movieItem.overview)")
                
            })
            
        }) { (message) in
            print("top rated movies error message :\(message)")
        }
        
        
        ///////////////////////////////////////////////////////////////////////
                                                                                //Popular Movies
        ///////////////////////////////////////////////////////////////////////
        
        fetchPopularMovies(onComplete: { (popularMoviesResult) in
            //print("Popular Movies Result: \(popularMoviesResult)")
            
            //Total Results
            self.moviesResult.pageNum = popularMoviesResult.value(forKey: "page") as! Int
            self.moviesResult.totalPages = popularMoviesResult.value(forKey: "total_pages") as! Int
            self.moviesResult.totalResults = popularMoviesResult.value(forKey: "total_results") as! Int
            
            //Movies Result
            let popularMoviesJsonArray = popularMoviesResult.value(forKey: "results") as! NSArray
            popularMoviesJsonArray.forEach({ (moviesJsonItem) in
                
                let popularMoviesJsonDictionary = moviesJsonItem as! NSDictionary
                let popularMoviesItem = MovieItem()
                
                popularMoviesItem.movieId = popularMoviesJsonDictionary.value(forKey: "id") as! Int
                popularMoviesItem.movieTitle = popularMoviesJsonDictionary.value(forKey: "original_title") as! String
                popularMoviesItem.posterPath = popularMoviesJsonDictionary.value(forKey: "poster_path") as! String
                popularMoviesItem.releaseDate = popularMoviesJsonDictionary.value(forKey: "release_date") as! String
                popularMoviesItem.overview = popularMoviesJsonDictionary.value(forKey: "overview") as! String
                popularMoviesItem.backdropPath = popularMoviesJsonDictionary.value(forKey: "backdrop_path") as? String ?? "No backdrop for movie"
                
                self.moviesResult.popularMoviesArray.append(popularMoviesItem)
                //print("Popular Movies Overview: \(self.movieItem.overview, self.movieItem.posterPath)")
                //print("Release date:\(popularMoviesItem.releaseDate)")
                
            })
            
        }) { (message) in
            print("popular movies error message: \(message)")
        }
        
        
        ///////////////////////////////////////////////////////////////////////
                                                                    //Live TV Shows
        ///////////////////////////////////////////////////////////////////////
        
        fetchLiveTVShows(onComplete: { (liveTVShowsResult) in
            //print("Live TV Shows Result: \(liveTVShowsResult)")
            
            //Total Results
            self.moviesResult.pageNum = liveTVShowsResult.value(forKey: "page") as! Int
            self.moviesResult.totalPages = liveTVShowsResult.value(forKey: "total_pages") as! Int
            self.moviesResult.totalResults = liveTVShowsResult.value(forKey: "total_results") as! Int
            
            //Movie Results
            let popularMoviesJsonArray = liveTVShowsResult.value(forKey: "results") as! NSArray
            popularMoviesJsonArray.forEach({ (movieJsonItem) in
                
                let popularMoviesJsonDictionary = movieJsonItem as! NSDictionary
                let liveTVShowsItem = MovieItem()
                
                liveTVShowsItem.movieId = popularMoviesJsonDictionary.value(forKey: "id") as! Int
                liveTVShowsItem.movieTitle = popularMoviesJsonDictionary.value(forKey: "original_name") as! String
                liveTVShowsItem.releaseDate = popularMoviesJsonDictionary.value(forKey: "first_air_date") as! String
                liveTVShowsItem.posterPath = popularMoviesJsonDictionary.value(forKey: "poster_path") as! String
                liveTVShowsItem.overview = popularMoviesJsonDictionary.value(forKey: "overview") as! String
                liveTVShowsItem.backdropPath = popularMoviesJsonDictionary.value(forKey: "backdrop_path") as? String ?? "No backdrop for movie"
                
                self.moviesResult.liveTVArray.append(liveTVShowsItem)
               // print("Live TV Shows Overview: \(self.movieItem.overview, self.movieItem.posterPath)")
                
            })
            
        }) { (message) in
            print("live tv shows result error message: \(message)")
        }
        
        
        ///////////////////////////////////////////////////////////////////////
                                                                    //Top Rated TV SHows
        ///////////////////////////////////////////////////////////////////////
        fetchTopRatedTVShows(onComplete: { (topRatedTVShowsResult) in
            //print("Top Rated TV Shows Result: \(topRatedTVShowsResult)")
            
            //Total Results
            self.moviesResult.pageNum = topRatedTVShowsResult.value(forKey: "page") as! Int
            self.moviesResult.totalPages = topRatedTVShowsResult.value(forKey: "total_pages") as! Int
            self.moviesResult.totalResults = topRatedTVShowsResult.value(forKey: "total_results") as! Int
            
            //Movie Results
            let topRatedTVJsonArray = topRatedTVShowsResult.value(forKey: "results") as! NSArray
            topRatedTVJsonArray.forEach({ (movieJsonItem) in
                
                let topRatedTVJsonDictionary = movieJsonItem as! NSDictionary
                let topTVShowsItem = MovieItem()
                
                topTVShowsItem.movieId = topRatedTVJsonDictionary.value(forKey: "id") as! Int
                topTVShowsItem.movieTitle = topRatedTVJsonDictionary.value(forKey: "original_name") as! String
                topTVShowsItem.posterPath = topRatedTVJsonDictionary.value(forKey: "poster_path") as! String
                topTVShowsItem.releaseDate = topRatedTVJsonDictionary.value(forKey: "first_air_date") as! String
                topTVShowsItem.overview = topRatedTVJsonDictionary.value(forKey: "overview") as! String
                topTVShowsItem.backdropPath = topRatedTVJsonDictionary.value(forKey: "backdrop_path") as? String ?? "No backdrop for movie"
                
                self.moviesResult.topRatedTVArray.append(topTVShowsItem)
                //print("Top Rated TV Overview: \(self.movieItem.overview, self.movieItem.posterPath)")
                
            })
            
        }) { (message) in
            print("top rated tv shows result error message: \(message)")
        }
        
    }
    
    
}
