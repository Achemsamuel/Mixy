//
//  MainViewController.swift
//  Movie Finder
//
//  Created by Achem Samuel on 4/4/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit
import Kingfisher
import ChameleonFramework

class MainViewController: UIViewController {
    
    /*----------------------------------------
     Mark: Declaration and Class Instances
     --------------------------------------*/
    
    //Variables *********************************************************
    
    var movieArray = ["Upcoming", "Trending", "Top Rated", "Popular", "Live TV", "Top Rated TV"]
    
    //Instances Class Initializers *********************************************************
    let findMoviesSearchController = UISearchController(searchResultsController: nil)
    let moviesResult = MovieResult()
    let movieItem = MovieItem()
    
    
    //Segues
    let goToAboutMovie = "goToAboutMovie"
    
    //Networking Variables *********************************************************
    var apiKey : String!
    let serviceUrl = "https://api.themoviedb.org/3"
    var baseUrl : String!
    var posterWidth = "original"
    var finalMovieUrl : String = ""
    let imagesUrl = "image.tmdb.org/t/p/"
    var movieTitle : String = ""
    
    
    //Cell Identifiers ***************************************************
    /*-------------------------------------------------------------
     ----
     COLLECTION VIEW CELLS ******************
     Upcoming Movies Collection Cell Identifier = upcomingCCI
     Trending Movies Collection Cell = trendingMCL
     Top Rated Movies Collection Cell Identifier = topRatedCCI
     Popular Movies Collection Cell Identifier = popularMCCI
     Live TV Shows Collection Cell Identifier = liveTVCCI
     Top Rated Shows Collection Cell identifier = topRatedTVCCI
     -----------------------------------------------------------*/
    
    //Upcoming Movies Cell Identifiers
    let upcomingCCI = "upcomingMoviesCollectionCell"
    let topRatedCCI = "topRatedMoviesCollectionCell"
    let trendingMCL = "trendingMoviesCollectionCell"
    let popularMCCI = "popularMoviesCollectionCell"
    let liveTVCCI = "liveTVCollectionCell"
    let topRatedTVCCI = "topRatedTVCollectionCell"
    

    /*---------------------------------
     Mark: Application Life Cycle
     ------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainSearchControllerSetUp()
        getApiKey()
        
        //Movies Json Result Methods
        getGeneralMovieResults()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    /*----------------------------------------
     No Network Alert
     ----------------------------------------*/
    
    func noNetworkAlert () {
        
        let noNetworkAlert = UIAlertController(title: "Sorry could not load movie" , message: "please check your internet connection and reload app", preferredStyle: .alert)
        noNetworkAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        //self.present(noNetworkAlert, animated: true, completion: .reloadData)
        
    }
    

}



/*-------------------------------------------
 Collection View DataSource & Delegate Set up
 -------------------------------------------*/

extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //let cache = NSCache<AnyObject, AnyObject>
        //_ = UserDefaults()
        switch collectionView.tag {
        case 0:
            return moviesResult.upcomingMoviesArray.count
        case 1:
            return moviesResult.trendingMoviesArray.count
        case 2:
            return moviesResult.topMoviesArray.count
        case 3:
            return moviesResult.popularMoviesArray.count
        case 4:
            return moviesResult.liveTVArray.count
        case 5:
            return moviesResult.topRatedTVArray.count
        default:
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case 0:
            if let upcomingMoviesCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: upcomingCCI, for: indexPath) as? UpcomingMoviesCollectionViewCell {
                upcomingMoviesCollectionCell.upcomingMoviesImageView.backgroundColor = UIColor.randomFlat
                
                //Image Fetching and Advanced Caching
                let upcomingMovieItemPath = moviesResult.upcomingMoviesArray[indexPath.row]
                let posterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(upcomingMovieItemPath.posterPath)")
                
                var upcomingMoviesImageView = upcomingMoviesCollectionCell.upcomingMoviesImageView
                upcomingMoviesImageView?.kf.indicatorType = .activity
                
                //Check If File Exists In Cache
                let cache = ImageCache.default
                let cached = cache.isCached(forKey: posterItem)
                print("Is Upcoming Movies Image at indexPath Cached: \(cached)")
                
                if cached == true {
                    print("Updating upcoming movie cells from cache")
                    cache.retrieveImage(forKey: posterItem) { result  in
                        switch result {
                        case.success(let value):
                            //print("Value.cache type \(value.cacheType)")
                            // print(value.image!)
                            DispatchQueue.main.async {
                                upcomingMoviesImageView?.image = value.image
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                } else {
                    print("Downloading Upcoming Images")
                    upcomingMoviesImageView!.kf.setImage(with: URL(string: posterItem), placeholder: UIImage(named: "Upcoming movies image"), options: [
                        .transition(.flipFromLeft(0.5)), .cacheOriginalImage, .memoryCacheExpiration(.days(1))
                        ])
                    {
                        result in
                        switch result {
                        case.success(let value):
                            print("Upcoming Image Download Task Completed For: \(value.source.url!.absoluteString)")
                        case.failure(let error):
                            print("Upcoming Image Download Task failed: \(error.localizedDescription)")
                        }
                    }
                }
                
                return upcomingMoviesCollectionCell
            }
            
        case 1:
            if let trendingMoviesCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: trendingMCL, for: indexPath) as? TrendingMoviesCollectionViewCell {
                trendingMoviesCollectionCell.trendingMoviesImageView.backgroundColor = UIColor.randomFlat
                
                //Image Fetching and Advanced Caching
                let trendingMovieItemPath = moviesResult.trendingMoviesArray[indexPath.row]
                let posterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(trendingMovieItemPath.posterPath)")
                
                var trendingMoviesImageView = trendingMoviesCollectionCell.trendingMoviesImageView
                trendingMoviesImageView?.kf.indicatorType = .activity
                
                //Check If File Exists In Cache
                let cache = ImageCache.default
                let cached = cache.isCached(forKey: posterItem)
                print("Is Trending Movies Image at indexPath Cached: \(cached)")
                
                if cached == true {
                    print("Updating trending movies cells from cache")
                    cache.retrieveImage(forKey: posterItem) { result  in
                        switch result {
                        case.success(let value):
                            //print("Value.cache type \(value.cacheType)")
                            // print(value.image!)
                            DispatchQueue.main.async {
                                trendingMoviesImageView?.image = value.image
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                else {
                    print("Prepare to download Trending Movies Images")
                    
                    trendingMoviesImageView!.kf.setImage(with: URL(string: posterItem), placeholder: UIImage(named: "Trending movies image"), options: [
                        .transition(.flipFromLeft(0.5)), .cacheOriginalImage, .memoryCacheExpiration(.days(1))
                        ])
                    {
                        result in
                        switch result {
                        case.success(let value):
                            print("Trending Image Download Task Completed For: \(value.source.url!.absoluteString)")
                        case.failure(let error):
                            print("Trending Image Download Task failed: \(error.localizedDescription)")
                        }
                    }
                    
                }
                return trendingMoviesCollectionCell
            }
            
            
        case 2:
            if let topRatedMoviesCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: topRatedCCI, for: indexPath) as? TopRatedMoviesCollectionViewCell {
                topRatedMoviesCollectionCell.topRatedMoviesImageView.backgroundColor = UIColor.randomFlat
                
                //Image Fetching and Advanced Caching
                let topRatedMovieItemPath = moviesResult.topMoviesArray[indexPath.row]
                let posterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(topRatedMovieItemPath.posterPath)")
                
                var topRatedMovieImageView = topRatedMoviesCollectionCell.topRatedMoviesImageView
                topRatedMovieImageView?.kf.indicatorType = .activity
                
                //Check If File Exists In Cache
                let cache = ImageCache.default
                let cached = cache.isCached(forKey: posterItem)
                print("Is Top Rated Movies Image at indexPath Cached: \(cached)")
                
                if cached == true {
                    print("Updating top rated image cells from cache")
                    cache.retrieveImage(forKey: posterItem) { result  in
                        switch result {
                        case.success(let value):
                            //print("Value.cache type \(value.cacheType)")
                            // print(value.image!)
                            DispatchQueue.main.async {
                                topRatedMovieImageView?.image = value.image
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                } else {
                    print("Downloading Top Rated movies images")
                    topRatedMovieImageView!.kf.setImage(with: URL(string: posterItem), placeholder: UIImage(named: "Top Rated movies image"), options: [
                        .transition(.flipFromLeft(0.5)), .cacheOriginalImage, .memoryCacheExpiration(.days(1))
                        ])
                    {
                        result in
                        switch result {
                        case.success(let value):
                            print("Top Rated Image Download Task Completed For: \(value.source.url!.absoluteString)")
                        case.failure(let error):
                            print("Top Rated Image Download Task failed: \(error.localizedDescription)")
                        }
                    }
                }
                return topRatedMoviesCollectionCell
            }
            
            
        case 3:
            if let popularMoviesCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: popularMCCI, for: indexPath) as? PopularMoviesCollectionViewCell {
                popularMoviesCollectionCell.popularMoviesImageView.backgroundColor = UIColor.randomFlat
                
                //Image Fetching and Advanced Caching
                let popularMoviesItemPath = moviesResult.popularMoviesArray[indexPath.row]
                let posterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(popularMoviesItemPath.posterPath)")
                var popularMoviesImageView = popularMoviesCollectionCell.popularMoviesImageView
                popularMoviesImageView?.kf.indicatorType = .activity
                
                //Check If File Exists In Cache
                let cache = ImageCache.default
                let cached = cache.isCached(forKey: posterItem)
                print("Is Popular movies Image at index path cahed : \(cached)")
                
                if cached == true {
                    print("updating popular image cells from cache")
                    cache.retrieveImage(forKey: posterItem) { result  in
                        switch result {
                        case.success(let value):
                            print("Value.cache type \(value.cacheType)")
                            
                            print(value.image!)
                            DispatchQueue.main.async {
                                popularMoviesImageView?.image = value.image
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                } else {
                    print("Downloading Popular Movie Images")
                    popularMoviesImageView!.kf.setImage(with: URL(string: posterItem), placeholder: UIImage(named: "Popular movies image"), options: [
                        .transition(.flipFromLeft(0.5)), .cacheOriginalImage, .memoryCacheExpiration(.days(1))
                        ])
                    {
                        result in
                        switch result {
                        case.success(let value):
                            print("Popular Movies Image Download Task Completed For: \(value.source.url!.absoluteString)")
                        case.failure(let error):
                            print("Popular Images Image Download Task failed: \(error.localizedDescription)")
                        }
                    }
                }
                
                
                
                return popularMoviesCollectionCell
            }
            
            
        case 4:
            if let liveTVCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: liveTVCCI, for: indexPath) as? LiveTVShowsCollectionViewCell {
                liveTVCollectionCell.liveTVShowsImageView.backgroundColor = UIColor.randomFlat
                //
                //collectionView.reloadItems(at: [indexPath])

                //Image Fetching and Advanced Caching
                let liveTVItemPath = moviesResult.liveTVArray[indexPath.row]
                let posterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(liveTVItemPath.posterPath)")
                
                var liveTVImageView = liveTVCollectionCell.liveTVShowsImageView
                liveTVImageView?.kf.indicatorType = .activity
                
                //Check If File Exists In Cache
                let cache = ImageCache.default
                let cached = cache.isCached(forKey: posterItem)
                print("Is Popular movies Image at index path cahed : \(cached)")
                
                if cached == true {
                    print("updating liveTV image cells from cache")
                    cache.retrieveImage(forKey: posterItem) { result  in
                        switch result {
                        case.success(let value):
                            print("Value.cache type \(value.cacheType)")
                            
                            print(value.image!)
                            DispatchQueue.main.async {
                                liveTVImageView?.image = value.image
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                } else {
                    print("Downloading live TV Images")
                    liveTVImageView!.kf.setImage(with: URL(string: posterItem), placeholder: UIImage(named: "Live TV Shows image"), options: [
                        .transition(.flipFromLeft(0.5)), .cacheOriginalImage, .memoryCacheExpiration(.days(1))
                        ])
                    {
                        result in
                        switch result {
                        case.success(let value):
                            print("Live TV Shows Image Download Task Completed For: \(value.source.url!.absoluteString)")
                        case.failure(let error):
                            print("Live TV Shows Image Download Task failed: \(error.localizedDescription)")
                        }
                    }
                }
                return liveTVCollectionCell
            }
            
        case 5:
            if let topRatedTVCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: topRatedTVCCI, for: indexPath) as? TopRatedTVShowsCollectionViewCell {
                topRatedTVCollectionCell.topRatedTVShowsImageView.backgroundColor = UIColor.randomFlat
                
                //Image Fetching and Advanced Caching
                let topRatedTVItemPath = moviesResult.topRatedTVArray[indexPath.row]
                let posterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(topRatedTVItemPath.posterPath)")
                
                var topRatedTVImageView = topRatedTVCollectionCell.topRatedTVShowsImageView
                topRatedTVImageView?.kf.indicatorType = .activity
                
                //Check If File Exists In Cache
                let cache = ImageCache.default
                let cached = cache.isCached(forKey: posterItem)
                print("Is topRated Tv movies Image at index path cahed : \(cached)")
                
                if cached == true {
                    print("Updating top Rated Tv Image cells from cache")
                    cache.retrieveImage(forKey: posterItem) { result  in
                        switch result {
                        case.success(let value):
                            print("Value.cache type \(value.cacheType)")
                            
                            print(value.image!)
                            DispatchQueue.main.async {
                                topRatedTVImageView?.image = value.image
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                } else {
                    topRatedTVImageView!.kf.setImage(with: URL(string: posterItem), placeholder: UIImage(named: "Top Rated TV Shows image"), options: [
                        .transition(.flipFromLeft(0.5)), .cacheOriginalImage, .memoryCacheExpiration(.days(1))
                        ])
                    {
                        result in
                        switch result {
                        case.success(let value):
                            print("Top Rated TV Shows Image Download Task Completed For: \(value.source.url!.absoluteString)")
                        case.failure(let error):
                            print("Top Rated TV Shows Image Download Task failed: \(error.localizedDescription)")
                        }
                    }
                }
                return topRatedTVCollectionCell
            }
            
        default:
            let cell = UICollectionViewCell()
            return cell
        }
        return UICollectionViewCell()
    }
    

/****************************
 
 //Cell selection Method
 
 ****************************/

public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let aboutMovieDestinationVC = mainStoryboard.instantiateViewController(withIdentifier: "AboutMovieViewController") as! AboutMovieViewController
    
    
    //Selected Cells Check and assignment
    //let cache = ImageCache.default
    switch collectionView.tag {
    case 0:
        //print("Upcoming cell tapped : \(movieTitleAtIndexPath)")
        let movieAtIndexPath =  moviesResult.upcomingMoviesArray[indexPath.item]
        let movieTitleAtIndexPath = movieAtIndexPath.movieTitle
        let movieOverview = movieAtIndexPath.overview
        let releaseDate = movieAtIndexPath.releaseDate
        
        aboutMovieDestinationVC.movieTitle = movieTitleAtIndexPath
        aboutMovieDestinationVC.overview = movieOverview
        aboutMovieDestinationVC.movieReleaseDate = releaseDate
        
        
        //Set Backdrop Image
        let backdropPoster = ("https://\(self.imagesUrl)\(self.posterWidth)\(movieAtIndexPath.backdropPath)")
        KingfisherManager.shared.retrieveImage(with: URL(string: backdropPoster)!) { result in
            switch result {
            case.success(let value):
                print("Backdrop poster gotten succesfully")
                aboutMovieDestinationVC.stretchyHeaderUIImageView.image = value.image
            case.failure(let error):
                print("Failed to get backdrop Image :\(error.localizedDescription)")
            }
        }
        
        //Set AboutImageView Image
        let posterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(movieAtIndexPath.posterPath)")
        KingfisherManager.shared.retrieveImage(with: URL(string: posterItem)!) { result in
            switch result {
            case .success(let value):
                print("Image successfully gotten and stored: \(value.image)")
                aboutMovieDestinationVC.aboutMovieImage.image = value.image
            case .failure(let error):
                print("Failed to download Images: \(error.localizedDescription)")
            }
        }
        self.navigationController?.pushViewController(aboutMovieDestinationVC, animated: true)
        
    case 1:
        let movieAtIndexPath = moviesResult.trendingMoviesArray[indexPath.item]
        let movieTitleAtIndexPath = movieAtIndexPath.movieTitle
        let movieOverview = movieAtIndexPath.overview
        let releaseDate = movieAtIndexPath.releaseDate
        
        aboutMovieDestinationVC.movieTitle = movieTitleAtIndexPath
        aboutMovieDestinationVC.overview = movieOverview
        aboutMovieDestinationVC.movieReleaseDate = releaseDate
        
        //Set Backdrop Image
        let backdropPoster = ("https://\(self.imagesUrl)\(self.posterWidth)\(movieAtIndexPath.backdropPath)")
        KingfisherManager.shared.retrieveImage(with: URL(string: backdropPoster)!) { result in
            switch result {
            case.success(let value):
                print("Backdrop poster gotten succesfully")
                aboutMovieDestinationVC.stretchyHeaderUIImageView.image = value.image
            case.failure(let error):
                print("Failed to get backdrop Image :\(error.localizedDescription)")
            }
        }
        
        //Set AboutImageView Image
        let posterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(movieAtIndexPath.posterPath)")
        KingfisherManager.shared.retrieveImage(with: URL(string: posterItem)!) { result in
            switch result {
            case .success(let value):
                print("Image successfully gotten and stored: \(value.image)")
                aboutMovieDestinationVC.aboutMovieImage.image = value.image
            case .failure(let error):
                print("Failed to download Images: \(error.localizedDescription)")
            }
        }
        
        self.navigationController?.pushViewController(aboutMovieDestinationVC, animated: true)
        
    case 2:
        let movieAtIndexPath = moviesResult.topMoviesArray[indexPath.item]
        let movieTitleAtIndexPath = movieAtIndexPath.movieTitle
        let movieOverview = movieAtIndexPath.overview
        let releaseDate = movieAtIndexPath.releaseDate
        
        aboutMovieDestinationVC.movieTitle = movieTitleAtIndexPath
        aboutMovieDestinationVC.overview = movieOverview
        aboutMovieDestinationVC.movieReleaseDate = releaseDate
        
        //Set Backdrop Image
        let backdropPoster = ("https://\(self.imagesUrl)\(self.posterWidth)\(movieAtIndexPath.backdropPath)")
        KingfisherManager.shared.retrieveImage(with: URL(string: backdropPoster)!) { result in
            switch result {
            case.success(let value):
                print("Backdrop poster gotten succesfully")
                aboutMovieDestinationVC.stretchyHeaderUIImageView.image = value.image
            case.failure(let error):
                print("Failed to get backdrop Image :\(error.localizedDescription)")
            }
        }
        
        //Set AboutImageView Image
        let posterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(movieAtIndexPath.posterPath)")
        KingfisherManager.shared.retrieveImage(with: URL(string: posterItem)!) { result in
            switch result {
            case .success(let value):
                print("Image successfully gotten and stored: \(value.image)")
                aboutMovieDestinationVC.aboutMovieImage.image = value.image
            case .failure(let error):
                print("Failed to download Images: \(error.localizedDescription)")
            }
        }
        self.navigationController?.pushViewController(aboutMovieDestinationVC, animated: true)
        
    case 3:
        let movieAtIndexPath = moviesResult.popularMoviesArray[indexPath.item]
        let movieTitleAtIndexPath = movieAtIndexPath.movieTitle
        let movieOverview = movieAtIndexPath.overview
        let releaseDate = movieAtIndexPath.releaseDate
        
        aboutMovieDestinationVC.movieTitle = movieTitleAtIndexPath
        aboutMovieDestinationVC.overview = movieOverview
        aboutMovieDestinationVC.movieReleaseDate = releaseDate
        
        //Set Backdrop Image
        let backdropPoster = ("https://\(self.imagesUrl)\(self.posterWidth)\(movieAtIndexPath.backdropPath)")
        KingfisherManager.shared.retrieveImage(with: URL(string: backdropPoster)!) { result in
            switch result {
            case.success(let value):
                print("Backdrop poster gotten succesfully")
                aboutMovieDestinationVC.stretchyHeaderUIImageView.image = value.image
            case.failure(let error):
                print("Failed to get backdrop Image :\(error.localizedDescription)")
            }
        }
        
        //Set AboutImageView Image
        let posterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(movieAtIndexPath.posterPath)")
        KingfisherManager.shared.retrieveImage(with: URL(string: posterItem)!) { result in
            switch result {
            case .success(let value):
                print("Image successfully gotten and stored: \(value.image)")
                aboutMovieDestinationVC.aboutMovieImage.image = value.image
            case .failure(let error):
                print("Failed to download Images: \(error.localizedDescription)")
            }
        }
        
        self.navigationController?.pushViewController(aboutMovieDestinationVC, animated: true)
        
    case 4:
        let movieAtIndexPath = moviesResult.liveTVArray[indexPath.item]
        let movieTitleAtIndexPath = movieAtIndexPath.movieTitle
        let movieOverview = movieAtIndexPath.overview
        let releaseDate = movieAtIndexPath.releaseDate
        
        aboutMovieDestinationVC.movieTitle = movieTitleAtIndexPath
        aboutMovieDestinationVC.overview = movieOverview
        aboutMovieDestinationVC.movieReleaseDate = releaseDate
        
        //Set Backdrop Image
        let backdropPoster = ("https://\(self.imagesUrl)\(self.posterWidth)\(movieAtIndexPath.backdropPath)")
        KingfisherManager.shared.retrieveImage(with: URL(string: backdropPoster)!) { result in
            switch result {
            case.success(let value):
                print("Backdrop poster gotten succesfully")
                aboutMovieDestinationVC.stretchyHeaderUIImageView.image = value.image
            case.failure(let error):
                print("Failed to get backdrop Image :\(error.localizedDescription)")
            }
        }
        
        //Set AboutImageView Image
        let posterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(movieAtIndexPath.posterPath)")
        KingfisherManager.shared.retrieveImage(with: URL(string: posterItem)!) { result in
            switch result {
            case .success(let value):
                print("Image successfully gotten and stored: \(value.image)")
                aboutMovieDestinationVC.aboutMovieImage.image = value.image
            case .failure(let error):
                print("Failed to download Images: \(error.localizedDescription)")
            }
        }
        self.navigationController?.pushViewController(aboutMovieDestinationVC, animated: true)
        
    case 5:
        let movieAtIndexPath = moviesResult.topRatedTVArray[indexPath.item]
        let movieTitleAtIndexPath = movieAtIndexPath.movieTitle
        let movieOverview = movieAtIndexPath.overview
        let releaseDate = movieAtIndexPath.releaseDate
        
        aboutMovieDestinationVC.movieTitle = movieTitleAtIndexPath
        aboutMovieDestinationVC.overview = movieOverview
        aboutMovieDestinationVC.movieReleaseDate = releaseDate
        
        //Set Backdrop Image
        let backdropPoster = ("https://\(self.imagesUrl)\(self.posterWidth)\(movieAtIndexPath.backdropPath)")
        KingfisherManager.shared.retrieveImage(with: URL(string: backdropPoster)!) { result in
            switch result {
            case.success(let value):
                print("Backdrop poster gotten succesfully")
                aboutMovieDestinationVC.stretchyHeaderUIImageView.image = value.image
            case.failure(let error):
                print("Failed to get backdrop Image :\(error.localizedDescription)")
            }
        }
        
        //Set AboutImageView Image
        let posterItem = ("https://\(self.imagesUrl)\(self.posterWidth)\(movieAtIndexPath.posterPath)")
        KingfisherManager.shared.retrieveImage(with: URL(string: posterItem)!) { result in
            switch result {
            case .success(let value):
                print("Image successfully gotten and stored: \(value.image)")
                aboutMovieDestinationVC.aboutMovieImage.image = value.image
            case .failure(let error):
                print("Failed to download Images: \(error.localizedDescription)")
            }
        }
        self.navigationController?.pushViewController(aboutMovieDestinationVC, animated: true)
        
    default:
        print("no cell tapped yet")
    }
    
    }
}


/*-------------------------------
 Mark: Search Bar Methods Set Up
 -------------------------------*/
extension MainViewController {
    
    func mainSearchControllerSetUp () {
        
        findMoviesSearchController.searchResultsUpdater = self as? UISearchResultsUpdating
        findMoviesSearchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = findMoviesSearchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = true
        
    }
    
    
}


