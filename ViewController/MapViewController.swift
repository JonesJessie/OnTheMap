//
//  MapViewController.swift
//  On the map
//
//  Created by Mac User on 4/30/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var postLocation: UIBarButtonItem!
    @IBOutlet weak var reload: UIBarButtonItem!
    @IBOutlet weak var logout: UIBarButtonItem!
    
    
    var students: [StudentAnnotation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMapData()
    }
    
    func loadMapData(){
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        self.students = ClientData.studentInformations?.compactMap({ student -> StudentAnnotation? in
            return StudentAnnotation(title: student.firstName + " " + student.lastName,
                                     subtitle: student.mediaURL,
                                     coordinate: CLLocationCoordinate2DMake(student.latitude, student.longitude))
        })
        
        if let students = self.students {
            mapView.addAnnotations(students)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is StudentAnnotation else { return nil }
        
        let identifier = "StudentInformation"
        
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
                if annotationView == nil {
                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView!.canShowCallout = true
                    annotationView!.pinTintColor = .red
                    annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                    
                } else {
                    annotationView!.annotation = annotation
                }
        
                return annotationView
            }
    
//        if annotationView == nil {
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView?.canShowCallout = true
//
//
//
//        } else {
//            annotationView?.annotation = annotation
//        }
//
//        return annotationView
//    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let studentInformation = view.annotation as? StudentAnnotation,
            let mediaUrlPath = studentInformation.subtitle,
            let mediaUrl = URL(string: mediaUrlPath),
            UIApplication.shared.canOpenURL(mediaUrl) else {
                self.showAlert(message: "This URL is not valid!")
                return
        }
        
        let vc = SFSafariViewController(url: mediaUrl)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    @IBAction func logoutPressed(_ sender: Any) {
        Client.logout(completion: handleLogoutResponse(success:error:))
        
    }
    func handleLogoutResponse(success: Bool, error: Error?){
        if success {
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            DispatchQueue.main.async {
                self.showAlert(message: "Failed to Logout! Try again.")
            }
        }
    }
    
    
    @IBAction func reloadPressed(_ sender: Any) {
        loadMapData()
    
    
    }
}




extension MapViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        let reuseId = "pin"
//
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//
//        if pinView == nil {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView!.canShowCallout = true
//            pinView!.pinTintColor = .red
//            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        else {
//            pinView!.annotation = annotation
//        }
//
//        return pinView
//    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if control == view.rightCalloutAccessoryView {
//            let app = UIApplication.shared
//            if let toOpen = view.annotation?.subtitle! {
//                app.openURL(URL(string: toOpen)!)
//            }
//        }
//    }

