//
//  AddPinViewController.swift
//  On the map
//
//  Created by Mac User on 5/1/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddPinViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    var location: String = ""
    var coordinate: CLLocationCoordinate2D?

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    
    
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var locationText: String?
    var mediaUrl: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        linkTextField.delegate = self
    }
    
    func setupBarButtonItems() {
        let cancelNavigationButton = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancel))
        cancelNavigationButton.tintColor = UIColor(red: 30/255, green: 180/255, blue: 226/255, alpha: 1)
        
        navigationItem.leftBarButtonItems = [cancelNavigationButton]
    }
    
    @objc func cancel(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        guard let locationText = self.locationTextField.text, locationText != ""  else {
            showAlert(message: "Please fill location text.")
            return
        }
        
        guard let mediaUrlPath = self.linkTextField.text,
            let mediaUrl = URL(string: mediaUrlPath),
            UIApplication.shared.canOpenURL(mediaUrl)  else {
                showAlert(message: "Please fill valid URL containing https://.")
                return
        }
        
        self.locationText = locationText
        self.mediaUrl = mediaUrl
        
        handleGetCoordinate(from: locationText)
        
    }
    
    func handleGetCoordinate(from locationText: String) {
        getCoordinate(from: locationText) { (location, error) in
            if error != nil  || !CLLocationCoordinate2DIsValid(location) {
                DispatchQueue.main.async {
                    self.showAlert(message: "Could not find location.")
                }
            } else {
                if let finishAddLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as? AddLocationViewController {
                    finishAddLocationVC.location = location
                    finishAddLocationVC.searchLocationText = self.locationText
                    finishAddLocationVC.mediaUrl = self.mediaUrl
                    self.navigationController?.pushViewController(finishAddLocationVC, animated: true)
                }
            }
        }
    }
    
    func getCoordinate(from location: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}

    
