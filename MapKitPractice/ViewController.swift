//
//  ViewController.swift
//  MapKitPractice
//
//  Created by kentaro on 2016/05/07.青木健太郎
//  Copyright © 2016年 kentaro aoki. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//シュミレーター上でMapの拡大縮小は、Optionを押しながらトラックパッドを操作することで可能

//Info.plistの編集
//  Key: NSLocationAlwaysUsageDescription
//  Type: String
//  Value: Use CoreLocation!

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let myMapView = MKMapView()
    
    let myLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMapView.frame = self.view.frame
        self.view.addSubview(myMapView)
        
        let longTapGesture = UILongPressGestureRecognizer()
        longTapGesture.addTarget(self, action: "longPressed:")
        myMapView.addGestureRecognizer(longTapGesture)
        myMapView.delegate = self
        
        myMapView.showsUserLocation = true
        myMapView.userLocation.coordinate
        myLocationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.NotDetermined {
            myLocationManager.requestAlwaysAuthorization()
        }
        myLocationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state != UIGestureRecognizerState.Began {
            return
        }
        
        let tappedLocation = sender.locationInView(myMapView)
        let tappedPoint = myMapView.convertPoint(tappedLocation, toCoordinateFromView: myMapView)
        
        let pin = MKPointAnnotation()
        pin.coordinate = tappedPoint
        pin.title = "タイトル"
        pin.subtitle = "サブタイトル"
        self.myMapView.addAnnotation(pin)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let myLocation = locations.last! as CLLocation
        let currentLocation = myLocation.coordinate
        
        let mySpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let myRegion = MKCoordinateRegionMake(currentLocation, mySpan)
        myMapView.setRegion(myRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation as? MKUserLocation == mapView.userLocation {
            return nil
        }
        
        var annotationView = myMapView.dequeueReusableAnnotationViewWithIdentifier("annotation") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        }
        
        annotationView?.animatesDrop = true
        annotationView?.canShowCallout = true
        annotationView?.draggable = true
        
        return annotationView
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var statusStr = ""
        switch (status) {
        case .NotDetermined:
            statusStr = "NotDetermined"
        case .Restricted:
            statusStr = "Restricted"
        case .Denied:
            statusStr = "Denied"
        case .AuthorizedAlways:
            statusStr = "AuthorizedAlways"
        case .AuthorizedWhenInUse:
            statusStr = "AuthorizedWhenInUse"
        }
        print(" CLAuthorizationStatus: \(statusStr)")
        
    }
}