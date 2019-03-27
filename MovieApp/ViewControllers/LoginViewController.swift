//
//  LoginViewController.swift
//  MovieApp
//
//  Created by NikitaPrakash Patil on 3/23/19.
//  Copyright © 2019 NikitaPrakash Patil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController,UITextFieldDelegate, UIViewControllerTransitioningDelegate {

    //signUP IBoutlets
     @IBOutlet weak var signUpView: UIView!
     @IBOutlet weak var signuplabel: UILabel!
     @IBOutlet weak var signUpUsername: UITextField!
     @IBOutlet weak var signUpEmail: UITextField!
     @IBOutlet weak var signupPassword: UITextField!
     @IBOutlet weak var signUpConPassword: UITextField!
     @IBOutlet weak var signUpRegister: UIButton!
    
    //login IBoutlets
     @IBOutlet weak var loginView: UIView!
     @IBOutlet weak var welcomeLabel: UILabel!
     @IBOutlet weak var username: UITextField!
     @IBOutlet weak var password: UITextField!
    
    let alertValue = ""
    var errorMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //delegate
        self.signUpUsername.delegate = self
        self.signUpEmail.delegate = self
        self.signupPassword.delegate = self
        self.signUpConPassword.delegate = self
        self.username.delegate = self
        self.password.delegate = self
        
        placeholder()
        
        //to animate loginView
        UIView.animate(withDuration: 2) {
            self.username.alpha = 1
            self.password.alpha = 1
            self.loginView.alpha = 0.8
            self.welcomeLabel.alpha = 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //validation
        if((password.text?.count)! < 6){
            alert(alertValue: 1)
        }
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func SignUpViewAction(_ sender: Any) {
        
        let views = (frontView: self.loginView, backView: self.signUpView)
         self.loginView.alpha = 0
        
        // set a transition style transitionFlipFromBottom
       let transitionOptions = UIView.AnimationOptions.transitionFlipFromBottom
        
        UIView.transition(with: views.frontView!, duration: 1.0, options: transitionOptions, animations: {}, completion: { finished in
            
            UIView.animate(withDuration: 0.70) {
                self.signUpView.alpha = 0.8
                 UIView.transition(with: views.backView!, duration: 1.0, options: transitionOptions, animations:nil, completion: nil)
                self.signuplabel.alpha = 1
                self.signUpUsername.alpha = 1
                self.signUpEmail.alpha = 1
                self.signupPassword.alpha = 1
                self.signUpConPassword.alpha = 1
                self.signUpRegister.alpha = 1
            }
        })
    }
    
    @IBAction func SignUpCancelButton(_ sender: Any) {
        
        let views = (frontView: self.signUpView, backView: self.loginView)
        self.signUpView.alpha = 0
        // set a transition style transitionFlipFromBottom
        let transitionOptions = UIView.AnimationOptions.transitionFlipFromBottom
        
        UIView.transition(with: views.frontView!, duration: 1.0, options: transitionOptions, animations: {}, completion: { finished in
           
            UIView.animate(withDuration: 0.70) {
                self.loginView.alpha = 0.8
                UIView.transition(with: views.backView!, duration: 1.0, options: transitionOptions, animations:nil, completion: nil)
                self.username.alpha = 1
                self.password.alpha = 1
                self.welcomeLabel.alpha = 1
            }
        })
    }
    
    // placeholder for all the text fields
    func placeholder(){
        
        self.username.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        self.password.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        self.signUpUsername.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        self.signUpEmail.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        self.signupPassword.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        self.signUpConPassword.attributedPlaceholder = NSAttributedString(string: "confirm Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
    }
    
    // Login Action
    @IBAction func LoginAction(_ sender: Any) {
        
        if self.username.text == "" || self.password.text == "" {
            alert(alertValue: 2)
        } else {
            Auth.auth().signIn(withEmail: username.text!, password: password.text!) { (user, error) in
                if error == nil {
                    self.successfullyLogin()
                 } else {
                    self.errorMessage = (error?.localizedDescription)!
                    self.alert(alertValue: 3)
                }
            }
        }
    }
    
    // Sign up Action
    @IBAction func RegisterAccount(_ sender: Any) {
        
        if signUpUsername.text == "" || signUpEmail.text == "" {
            alert(alertValue: 2)
        }else if (signupPassword.text?.count)! < 6{
            alert(alertValue: 1)
        }else if signupPassword.text !=  signUpConPassword.text{
            alert(alertValue: 4)
        }else {
            AppSettings.displayName = signUpUsername.text!
            Auth.auth().signInAnonymously(completion: nil)
            Auth.auth().createUser(withEmail: signUpEmail.text!, password: signupPassword.text!) { (user, error) in
                
                if error == nil {
                    
                    AppSettings.displayName = self.signUpUsername.text!
                    Auth.auth().signInAnonymously(completion: nil)
                    
                    if let user = Auth.auth().currentUser {
                        self.successfullyLogin()
                   }
                } else {
                    self.errorMessage = (error?.localizedDescription)!
                    self.alert(alertValue: 3)
                }
            }
        }
        
    }
    
    //Alert Views for validations
    func alert(alertValue: Int){
        
        switch alertValue {
            
        case 1:
            let alertController = UIAlertController(title: "Error", message: "Password should be atleast 6 Characters", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        case 2:
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        case 3:
            let alertController = UIAlertController(title: "Error", message:  self.errorMessage, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        case 4:
            let alertController = UIAlertController(title: "Error", message:  "Password is incoorect", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        default: break
            
        }
    }
    
    // Way to login without username and password
    @IBAction func GuestUserAction(_ sender: Any) {
        self.successfullyLogin()
    }
    
    //method to login
    func  successfullyLogin(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let nowPlayingNavigationController = storyBoard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MovieViewController
        nowPlayingViewController.movieEndPoint = "popular"
        nowPlayingNavigationController.tabBarItem.title = "Popular"
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "movie")
        
        let topRatedNavigationController = storyBoard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        let topRatedViewController = topRatedNavigationController.topViewController as! MovieViewController
        topRatedViewController.movieEndPoint = "top_rated"
        topRatedNavigationController.tabBarItem.title = "Top Rated"
        topRatedNavigationController.tabBarItem.image = UIImage(named: "top_rate")
    
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barTintColor = UIColor.black
        tabBarController.tabBar.isTranslucent = true
        tabBarController.viewControllers = [nowPlayingNavigationController, topRatedNavigationController]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
}
