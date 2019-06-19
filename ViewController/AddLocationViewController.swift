//
//AddLocationViewController.swift
//  On the map
//
//  Created by Mac User on 5/6/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!

    var location: CLLocationCoordinate2D?
    var mediaUrl: URL?
    var searchLocationText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let location = location else { return }
        let myLocationAnnotation = StudentAnnotation(title: searchLocationText, subtitle: nil, coordinate: location)
        mapView.addAnnotation(myLocationAnnotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is StudentAnnotation else { return nil }
        
        let identifier = "StudentInformation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        guard let myLocation = location else { return }
        
        let myStudentInformation = StudentInformation(uniqueKey: Client.Auth.key,
                                                      firstName: Client.Auth.firstName,
                                                      lastName: Client.Auth.lastName,
                                                      mapString: searchLocationText ?? "",
                                                      mediaURL: mediaUrl?.absoluteString ?? "",
                                                      latitude: myLocation.latitude,
                                                      longitude: myLocation.longitude,
                                                      objectId: Client.Auth.objectId)
        if Client.Auth.objectId != "" {
            Client.updateStudentLocation(studentInformation: myStudentInformation, completion: handlePostStudentLocation(success:error:))
        } else {
            Client.postStudentLocation(studentInformation: myStudentInformation, completion: handlePostStudentLocation(success:error:))
        }
    }
    
    func handlePostStudentLocation(success: Bool, error: Error?){
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToOnTheMap", sender: nil)
            }
        } else {
            DispatchQueue.main.async {
                self.showAlert(message: "Failed to send location. Try again.")
            }
        }
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
