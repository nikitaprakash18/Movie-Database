//
//  Network.swift
//  MovieApp
//
//  Created by NikitaPrakash Patil on 3/25/19.
//  Copyright © 2019 NikitaPrakash Patil. All rights reserved.
//

import Foundation
import Firebase
//var movieEndPoint: String!

final class Network {

     var ref: DatabaseReference!
    init() {
        ref = Database.database().reference().child("movieDetails")
    }
    
    func networkRequest(movieEndPoint: Int) {
    let apiKey = "6ddab08ee53a2cc33dc849f29441b753"
        let movieUrl = URL(string: "https://api.themoviedb.org/3/movie/\(movieEndPoint)?api_key=\(apiKey)")
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
    if let movie = try! JSONSerialization.jsonObject(
    with: data, options:[]) as? NSDictionary {
    
   
       
        let key = self.ref.childByAutoId().key
            let keydetails = ["id":key,
                              "Title": movie["original_title"] as! String,
                              "Overview": movie["overview"] as! String,
                              "moviePoster": movie["poster_path"] as! String,
                              "movieReleaseDate": movie["release_date"] as! String,
                              "movieVote": movie["vote_average"] as! Double
                ] as [String : Any]
            
            //adding the movie details inside the generated unique key
        self.ref.child(key).setValue(keydetails)
        }
    
    
    }
    else {
    print("Network Error")
    //self.toggleNetWorkError(hideErrorValue: false)
    }
    });
    task.resume()
    }

}
