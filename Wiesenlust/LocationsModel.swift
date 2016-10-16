//
//  LocationsModel.swift
//  OnionApps
//
//  Created by Lyle Christianne Jover on 15/07/2016.
//  Copyright © 2016 OnionApps. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Locations: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String
    let address: String
    let contact: String
    let coordinate: CLLocationCoordinate2D
    let location: CLLocation
    var distance: CLLocationDistance
    let storeHours: String
    
    init(title: String, locationName: String, address: String, contact: String, storeHours: String, coordinates: CLLocationCoordinate2D, location: CLLocation) {
        self.title = title
        self.locationName = locationName
        self.address = address
        self.contact = contact
        self.coordinate = coordinates
        self.location = location
        self.distance = 99999.99
        self.storeHours = storeHours
        
        super.init()
    }
    
    func addDistance(_ distance: CLLocationDistance) {
        self.distance = distance
    }
    
    
    var subtitle: String? {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(CNPostalAddressStreetKey): "\(address)"]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}
