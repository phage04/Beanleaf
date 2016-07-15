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
    
    init(title: String, locationName: String, address: String, contact: String, coordinates: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.address = address
        self.contact = contact
        self.coordinate = coordinates
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}