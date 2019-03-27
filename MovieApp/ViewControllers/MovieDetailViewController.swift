//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by NikitaPrakash Patil on 3/24/19.
//  Copyright © 2019 NikitaPrakash Patil. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailViewController: UIViewController {

     var movies: NSDictionary?
     var movieEndPoint: Int!
    
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var imageDetailView: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieOverView: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        networkRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    @objc func networkRequest() {
        
        let apiKey = "6ddab08ee53a2cc33dc849f29441b753"
        let movieUrl = URL(string: "https://api.themoviedb.org/3/movie/\(movieEndPoint!)?api_key=\(apiKey)")
        let request = URLRequest(url: movieUrl!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        self.movies = responseDictionary as? NSDictionary
                        self.updateValuesforMovie()
                        
                    }
                }
                else {
                    print("Network Error")
                }
        });
        task.resume()
    }

    
    func updateValuesforMovie(){
        
        let title =  self.movies?["original_title"] as! String
        self.movieTitle.text = title
        
        let Overview =  self.movies?["overview"] as! String
        self.movieOverView.text = Overview
        
        let releaseDate =  self.movies?["release_date"] as! String
        self.movieReleaseDate.text = releaseDate
        
        let ratings = self.movies?["vote_average"] as! Double
        self.rating.text = "\(ratings)"
        
        if let posterPath =  self.movies?["poster_path"] as? String{
            
            let baseurl = "https://image.tmdb.org/t/p/original"
            let imageurl = NSURL(string: baseurl+posterPath)
            self.posterImage.setImageWith(imageurl! as URL)
        }
        
    }
}
