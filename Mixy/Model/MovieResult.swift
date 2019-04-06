//
//  MovieResult.swift
//  Movie Finder
//
//  Created by Achem Samuel on 3/23/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import Foundation


class MovieResult : NSObject {
    
    
    var pageNum = 0
    var totalPages = 0
    var totalResults = 0
    var upcomingMoviesArray = Array<MovieItem>()
    var topMoviesArray = Array<MovieItem>()
    var popularMoviesArray = Array<MovieItem>()
    var trendingMoviesArray = Array<MovieItem>()
    var liveTVArray = Array<MovieItem>()
    var topRatedTVArray = Array<MovieItem>() {
        didSet {
        
        }
    }
    
}
