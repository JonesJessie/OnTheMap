//
//  LoginViewController.swift
//  On the map
//
//  Created by Mac User on 4/30/19.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let signupURL = URL(string: "https://auth.udacity.com/sign-up")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        signupButton.isEnabled = !loggingIn
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        setLoggingIn(true)
        guard let username = emailTextField.text, let password = passwordTextField.text else {
            self.showAlert(message: "Enter Valid Username and Password.")
            return
        }
        Client.login(username: username, password: password, completion: handleLoginResponse(success:error:))
        }
    
    @IBAction func signupPressed(_ sender: Any) {
        setLoggingIn(true)
        UIApplication.shared.open(signupURL!, options: [:], completionHandler: nil)
    }
    
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            Client.getUserData(userId: Client.Auth.key, completion: handleUserDataResponse(success:error:))
        } else {
            print(error.debugDescription)
            setLoggingIn(false)
            DispatchQueue.main.async {
                var errorMessage = "Failed to login. Try again or check internet connection."
                if let clientError = error as? ClientError {
                    errorMessage = clientError.message
                } else if let error = error {
                    errorMessage = error.localizedDescription
                }
                self.showAlert(message: errorMessage)
            }
        }
    }
    func handleUserDataResponse(success: Bool, error: Error?){
        if success {
            Client.getStudentLocation(uniqueKey: Client.Auth.key, completion: handleStudentLocationResponse(success:error:))
        } else {
            print(error.debugDescription)
            setLoggingIn(false)
            DispatchQueue.main.async {
                var errorMessage = "Failed to login. Try again or check internet connection."
                if let error = error {
                    errorMessage = error.localizedDescription
                }
                self.showAlert(message: errorMessage)
            }
        }
    }
    
    func handleStudentLocationResponse(success: Bool, error: Error?){
        if success {
            Client.getStudentLocations(limit: 100,completion: handleStudentLocationsResponse(success:error:))
        } else {
            print(error.debugDescription)
            setLoggingIn(false)
            DispatchQueue.main.async {
                var errorMessage = "Failed to login. Try again or check internet connection."
                if let error = error {
                    errorMessage = error.localizedDescription
                }
                self.showAlert(message: errorMessage)
            }
        }
    }
    
    func handleStudentLocationsResponse(success: Bool, error: Error?){
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "LoginComplete", sender: nil)
            }
        } else {
            print(error.debugDescription)
            setLoggingIn(false)
            var errorMessage = " to download student locations."
            if let error = error {
                errorMessage = error.localizedDescription
            }
            self.showAlert(message: errorMessage)
        }
    }
}
