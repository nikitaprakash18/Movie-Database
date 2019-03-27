//
//  MovieViewController.swift
//  MovieApp
//
//  Created by NikitaPrakash Patil on 3/23/19.
//  Copyright © 2019 NikitaPrakash Patil. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import Firebase

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITabBarControllerDelegate {
    
    var movies: [NSDictionary]?
    var movieEndPoint: String!
    
    let refreshControl = UIRefreshControl()
    let searchBar = UISearchBar()
    var searchResultsShown = false
    var filteredMovies: [NSDictionary]?
    
    @IBOutlet weak var tableView: UITableView!
    
     var ref: DatabaseReference!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference().child("popularMovies")
        
        tableView.dataSource = self
        tableView.delegate = self

        // searchbar
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    
        networkRequest()
        
        refreshControl.addTarget(self, action: #selector(networkRequest), for: UIControl.Event.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //Request to fetch the data
    @objc func networkRequest() {
        
        let apiKey = "6ddab08ee53a2cc33dc849f29441b753"
        let movieUrl = URL(string: "https://api.themoviedb.org/3/movie/\(movieEndPoint!)?api_key=\(apiKey)")
        let request = URLRequest(url: movieUrl!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                       self.movies = responseDictionary["results"] as? [NSDictionary]
                       
                        if self.movieEndPoint == "popular"{
                         self.adddetails()
                        }
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                        
                    }
                }
                else {
                    print("Network Error")
                    let alertController = UIAlertController(title: "Error", message: "Network is not connected", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
        });
        task.resume()
    }
    
    //Method to add data to firebase database
     func adddetails(){
       
        if let movieDict = movies{
            for movie in movieDict{
                let vc = Network()
                vc.networkRequest(movieEndPoint: (movie["id"] as? Int)!)
                
                /*generating a new key inside popularMovies node
                and also getting the generated key*/
               let key = ref.childByAutoId().key
                
                 //creating popular Movies with the given values
                let keydetails = ["id":key,
                              "Title": movie["title"] as! String,
                              "Overview": movie["overview"] as! String,
                              "moviePoster": movie["poster_path"] as! String
                    
                    ]
            
            //adding the movie details inside the generated unique key
            ref.child(key).setValue(keydetails)
            }
        }
    }
    
    //populate movie details to tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchResultsShown) {
            return filteredMovies?.count ?? 0
        }
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.selectionStyle = .none
        let movie: NSDictionary?
        if(searchResultsShown) {
            movie = filteredMovies?[indexPath.row]
        } else {
            movie = movies?[indexPath.row]
        }
        
        let title = movie?["title"] as! String
        let overview = movie?["overview"] as! String
        cell.movieName.text = title
        cell.movieDec.text = overview
        
        if let posterPath = movie?["poster_path"] as? String {
            let baseImageUrl = "https://image.tmdb.org/t/p/original"
            
            let imageUrl = NSURL(string: baseImageUrl + posterPath)
            cell.movieImage.setImageWith(imageUrl! as URL)
             cell.movieImage.layer.cornerRadius = 10
           cell.movieImage.layer.masksToBounds = true
        }
        return cell
    }
    
    //SearchBar Delegates
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchText = searchBar.text?.lowercased()
        if(searchText == "") {
            searchBarCancelButtonClicked(searchBar)
            return
        }
        
        filteredMovies = movies?.filter({ (movie: NSDictionary) -> Bool in
            let title = movie["title"] as! String
            return (title.lowercased().contains(searchText!))
        })
        searchResultsShown = true
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResultsShown = true
        searchBar.endEditing(true)
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultsShown = false
        searchBar.endEditing(true)
        self.tableView.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        self.hidesBottomBarWhenPushed = true
        let detailViewController = segue.destination as! MovieDetailViewController
        detailViewController.movieEndPoint = movie["id"] as? Int
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //method to signout
    @IBAction func SignOutAction(_ sender: Any) {
        
        
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                
                print(error.localizedDescription)
            }
        }else{
            let alertController = UIAlertController(title: "LogOut", message: "LogOut only if you'r not guest User", preferredStyle: .alert)
            // let defaultAction = UIAlertAction(title: "Logout", style: .cancel, handler: nil)
            //alertController.addAction(defaultAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    

}
