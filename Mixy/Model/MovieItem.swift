//
//  MovieItem.swift
//  Movie Finder
//
//  Created by Achem Samuel on 3/23/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import Foundation
import RealmSwift

class MovieItem : Object {
    
    @objc var movieId = 0
    @objc var movieTitle = ""
    @objc var releaseDate = ""
    @objc var posterPath = ""
    @objc var overview = ""
    @objc var backdropPath = ""
    
}
