//
//  MovieTitleRatingTableViewCell.swift
//  Movie Finder
//
//  Created by Achem Samuel on 4/1/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit

class MovieTitleRatingTableViewCell: UITableViewCell {

    let overview = String()
   // let movie
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        aboutLabel.numberOfLines = 0
        aboutLabel.adjustsFontSizeToFitWidth = true
        aboutLabel.sizeToFit()
       
    }
    
    @IBOutlet weak var aboutMovieTitle: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var aboutMoviePoster: UIImageView!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var addToFavoritesOutletButton: UIButton!
    
    @IBAction func addToFavoritesButton(_ sender: UIButton) {
        addToFavoritesOutletButton.imageView?.image = UIImage(named: "heart")
        print("button clicked")
    }
    
    
}
