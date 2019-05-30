//
//  PickupVC.swift
//  uteber-developement
//
//  Created by Stu on 26/5/19.
//  Copyright © 2019 UTEBer. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class PickupVC: UIViewController {

    @IBOutlet weak var pickupMapView: RoundMapView!
    
    var pickupCoordinate: CLLocationCoordinate2D!
    var passengerKey: String!
    
    var regionRadius: CLLocationDistance = 2000
    var pin: MKPlacemark? = nil
    
    var locationPlacemark: MKPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickupMapView.delegate = self
        
        locationPlacemark = MKPlacemark(coordinate: pickupCoordinate)
        
        dropPinFor(placemark: locationPlacemark)
        centerMapOnLocation(location: locationPlacemark.location!)
        
        DataService.instance.REF_TRIPS.child(passengerKey).observe(.value, with: {
            (tripSnapshot) in
            if tripSnapshot.exists() {
                if tripSnapshot.childSnapshot(forPath: TRIP_IS_ACCEPTED).value as? Bool == true {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func initData(coordinate: CLLocationCoordinate2D, passengerKey: String) {
        self.pickupCoordinate = coordinate
        self.passengerKey = passengerKey
    }

    @IBAction func acceptBtnWasPressed(_ sender: Any) {
        UpdateService.instance.acceptTrip(withPassengerKey: passengerKey, forDriverKey: Auth.auth().currentUser!.uid)
        presentingViewController?.shouldPresentLoadingView(true)
    }
    
    @IBAction func CancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PickupVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pickupPoint"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier:  identifier)
            
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "destinationAnnotation")
        
        return annotationView
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        pickupMapView.setRegion(coordinateRegion, animated: true)
    }
    
    func dropPinFor(placemark: MKPlacemark) {
        pin = placemark
        
        for annotation in pickupMapView.annotations {
            pickupMapView.removeAnnotation(annotation)
        }
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = placemark.coordinate
        
        pickupMapView.addAnnotation(annotation)
    }
}
