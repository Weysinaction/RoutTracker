//
//  ViewController.swift
//  RoutTracker
//
//  Created by Владислав Лазарев on 29.09.2021.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet var mapView: GMSMapView!
    
    //MARK: private properties
    let startLocation = CLLocationCoordinate2D(latitude: 55.753575, longitude: 37.62104)
    var locationManager: CLLocationManager?
    
    //MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        configureMap(location: startLocation)
        putMarker(location: startLocation)
    }
    
    //MARK: private methods
    private func configureMap(location: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition(target: location, zoom: 17)
        mapView.camera = camera
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
    }
    
    private func putMarker(location: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: location)
        marker.map = mapView
    }
    
    //MARK: IBAction
    
    @IBAction private func updateLocation(_ sender: Any) {
        locationManager?.startUpdatingLocation()
    }
    
    @IBAction private func currentLocation(_ sender: Any) {
        locationManager?.requestLocation()
    
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print(locations.first)
        configureMap(location: location.coordinate)
        putMarker(location: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

