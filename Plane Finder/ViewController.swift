//
//  ViewController.swift
//  Plane Finder
//
//  Created by Kenny Kim on 11/3/18.
//  Copyright © 2018 Kenny Kim. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, FrameExtractorDelegate {
    
    let locationManager = CLLocationManager()
    var latitude :Double = 0
    var longitude :Double = 0
    var altitude :Double = 0
    var heading :Double = 0
    let data = Data()
    var frameExtractor: FrameExtractor!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func RefreshPlanes(_ sender: UIButton) {
        print(data.getPlanes(la: latitude, lo: longitude))
    }
    
    @IBAction func BoundingBox(_ sender: UITextField) {
        data.setBoundingBox(radius: Double(sender.text ?? "0")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        initLocationManager()
        frameExtractor = FrameExtractor()
    }
    
    func captured(image: UIImage) {
        print("Image: \(image.size)")
        imageView.image = image
    }

    //https://stackoverflow.com/a/31277543
    func initLocationManager(){
        //Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        //For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        //Settings for location manager
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        
        data.setBoundingBox(radius: 0.5)
    }
    
    //https://stackoverflow.com/a/26728261
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        latitude = manager.location!.coordinate.latitude
        longitude = manager.location!.coordinate.longitude
        altitude = manager.location!.altitude
        print("Altitude: \(altitude)")
    }
    
    //https://medium.com/swiftly-swift/how-to-build-a-compass-app-in-swift-2b6647ae25e8
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading
        print(newHeading.trueHeading)
    }
}

