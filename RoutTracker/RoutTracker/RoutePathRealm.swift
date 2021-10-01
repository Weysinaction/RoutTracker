//
//  RoutePathRealm.swift
//  RoutTracker
//
//  Created by Владислав Лазарев on 01.10.2021.
//

import Foundation
import RealmSwift
import GoogleMaps

class RoutePathRealm: Object {
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0

    convenience init(position: CLLocationCoordinate2D) {
        self.init()
        latitude = position.latitude
        longitude = position.longitude
    }
}
