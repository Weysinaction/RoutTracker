//
//  ViewController.swift
//  RoutTracker
//
//  Created by Владислав Лазарев on 29.09.2021.
//

import UIKit
import GoogleMaps
import RealmSwift

final class ViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet var mapView: GMSMapView!
    
    //MARK: private properties
    private let startLocation = CLLocationCoordinate2D(latitude: 55.753575, longitude: 37.62104)
    private var locationManager: CLLocationManager?
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    private var coordinates: [RoutePathRealm] = []
    private let realmService = RealmService()
    
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
        if mapView != nil {
            mapView.camera = camera
        }
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.requestAlwaysAuthorization()
    }
    
    private func putMarker(location: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: location)
        marker.map = mapView
    }
    
    private func stopTracking() {
        route?.map = nil
        locationManager?.stopUpdatingLocation()
        realmService.writeToRealm(coordinates)
    }
    
    //MARK: IBAction
    
    @IBAction private func updateLocation(_ sender: Any) {
        locationManager?.startUpdatingLocation()
    }
    
    @IBAction private func currentLocation(_ sender: Any) {
        locationManager?.requestLocation()
    
    }
    @IBAction func beginTrack(_ sender: Any) {
        coordinates = []
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
    }
    
    @IBAction func endTrack(_ sender: Any) {
        stopTracking()
    }
    
    @IBAction func previousTrack(_ sender: Any) {
        stopTracking()
        let coordinates = realmService.getObjects(RoutePathRealm.self)
        var cameraPosition = CLLocationCoordinate2D()
        route = GMSPolyline()
        route?.map = mapView
        routePath = GMSMutablePath()
        
        for coordinate in coordinates {
            let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            routePath?.add(position)
            cameraPosition = position
        }
        route?.path = routePath
        configureMap(location: cameraPosition)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        
        let position = location
        coordinates.append(RoutePathRealm(position: position))
        
        configureMap(location: location)
        routePath?.add(location)
        route?.path = routePath
        
        let cameraPosition = GMSCameraPosition.camera(withTarget: location, zoom: 17)
        mapView.animate(to: cameraPosition)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

