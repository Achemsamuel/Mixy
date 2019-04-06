//
//  AboutMovieViewController.swift
//  Movie Finder
//
//  Created by Achem Samuel on 3/27/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit
import ChameleonFramework

class AboutMovieViewController: UIViewController {

    var stretchyHeaderUIImageView = UIImageView()
    let movieTitleCell = "titleCell"
    var aboutMovieImage = UIImageView()
    var overview = ""
    var movieTitle = ""
    var movieReleaseDate = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 180, left: 0, bottom: 0, right: 0)
        
        //stretchyHeaderUIImageView.image = UIImage(named: "10")
        stretchyHeaderUIImageView.contentMode = .scaleAspectFill
        stretchyHeaderUIImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        stretchyHeaderUIImageView.clipsToBounds = true
        view.addSubview(stretchyHeaderUIImageView)
        
        //////8888888***********
        ////////
       //navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }

}

extension AboutMovieViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieTitleCell, for: indexPath) as! MovieTitleRatingTableViewCell
       
        switch indexPath.row {
        case 0:
            cell.aboutLabel.text = self.overview
            //cell.backgroundColor = UIColor.darkGray
            cell.aboutMovieTitle.text = self.movieTitle
            cell.aboutMoviePoster.image = aboutMovieImage.image
            cell.movieReleaseDate.text = movieReleaseDate
        default:
           // cell.backgroundColor = UIColor.darkGray
            cell.movieReleaseDate.text = movieReleaseDate
            cell.aboutMoviePoster.image = UIImage(named: "10")
            cell.aboutMovieTitle.text = "The Awakening"
            cell.addToFavoritesOutletButton.setImage(UIImage(named: "greyHeart"), for: .normal)
            
        }
        
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = -scrollView.contentOffset.y
        let height = max(y, 80)
        stretchyHeaderUIImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
    }
    
    
    
}
