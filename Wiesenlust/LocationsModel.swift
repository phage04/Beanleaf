//
//  LocationsModel.swift
//  OnionApps
//
//  Created by Lyle Christianne Jover on 15/07/2016.
//  Copyright © 2016 OnionApps. All rights reserved.
//

import Foundation
import MapKit

class Locations: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String
    let address: String
    let contact: String
    let coordinate: CLLocationCoordinate2D
    let location: CLLocation
    var distance: CLLocationDistance
    
    init(title: String, locationName: String, address: String, contact: String, coordinates: CLLocationCoordinate2D, location: CLLocation) {
        self.title = title
        self.locationName = locationName
        self.address = address
        self.contact = contact
        self.coordinate = coordinates
        self.location = location
        self.distance = 99999.99
        
        super.init()
    }
    
    func addDistance(distance: CLLocationDistance) {
        self.distance = distance
    }
    
    
    var subtitle: String? {
        return locationName
    }
}