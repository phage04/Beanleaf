//
//  Locations.swift
//  OnionApps
//
//  Created by Lyle Christianne Jover on 15/07/2016.
//  Copyright © 2016 OnionApps. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let kTableHeaderHeight: CGFloat = 300.0
    var headerView: UIView!
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    var userLocNow: Locations!
    var locNow: Locations!
    var index: Int = 0
    
    var branches:[String] = ["Berger Str. 77, 60316 Frankfurt am Main", "An der Welle 7 60322 Frankfurt Germany", "Franziusstr. 35 60314 Frankfurt Germany", "Kantstr. 25 60316 Frankfurt Germany", "Schweizer Platz 56 60594 Frankfurt Germany"]
    var branchesLoc = [Locations]()
    var nearest: Locations!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.Plain, target:self, action:#selector(LocationsVC.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:nil)

        
        self.locationManager.requestAlwaysAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
        }

        mapView.delegate = self
        
       
        plotLocations()
    }
    
    override func viewDidAppear(animated: Bool) {
        plotLocations()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func plotLocations(){
        
        self.branchesLoc.removeAll()
    
        for loc in branches {
            let geoCoder = CLGeocoder()
            
            geoCoder.geocodeAddressString(loc, completionHandler: { (placemarks, error) in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                let locNow = Locations(title: "\(storeName)", locationName: "\(placeMark.thoroughfare!) Branch", address: loc, contact: "12345", coordinates: CLLocationCoordinate2DMake( (placeMark.location?.coordinate.latitude)!, (placeMark.location?.coordinate.longitude)!), location: CLLocation(latitude: (placeMark.location?.coordinate.latitude)!, longitude: (placeMark.location?.coordinate.longitude)!))
                
               
                self.branchesLoc.append(locNow)
                self.mapView.addAnnotation(locNow)
                
            
            })
        }
        
        locationManager.startUpdatingLocation()
    }
    

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let longitude = userLocation.coordinate.longitude
        let latitude = userLocation.coordinate.latitude
       
        if checkConnectivity() {
                let geoCoder = CLGeocoder()
                
                geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
                    
                    // Place details
                    var placeMark: CLPlacemark!
                    placeMark = placemarks?[0]
                    
                    self.userLocNow = Locations(title: "Your Location", locationName: "\(placeMark.subThoroughfare!)\(placeMark.thoroughfare!), \(placeMark.locality!) \(placeMark.postalCode!)", address: "\(placeMark.subThoroughfare!)\(placeMark.thoroughfare!), \(placeMark.locality!) \(placeMark.postalCode!)", contact: "n/a", coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), location: CLLocation(latitude: latitude, longitude: longitude))
                    
                    self.index = 0
                    
                    var x = 0
                    
                    for locationX in self.branchesLoc {
                        
                        
                        let distance = locationX.location.distanceFromLocation(userLocation)
                        print(distance)
                        locationX.addDistance(distance)
                        
                        if let _ = self.nearest {
                            
                            if self.nearest.distance > locationX.distance {
                                self.nearest = locationX
                                self.index = x
                            }              
                            
                        } else {
                            self.nearest = locationX
                            self.index = x
                        }
                        
                        x += 1
                    
                    }
                    
                    
                    self.centerMapOnLocation(self.nearest.location)
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                    self.tableView.reloadData()
                 
                })
        } else {
            showErrorAlert("Network Error", msg: "Please check your internet connection.", VC: self)

        }
        

        
    }


    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return branchesLoc.count-1
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label : UILabel = UILabel()
        if(section == 0){
            label.textColor = COLOR2
            label.text = "  Nearest Location"
            label.backgroundColor = COLOR1
            label.font = UIFont(name: font1Medium, size: 17)
        } else if (section == 1){
            label.textColor = COLOR2
            label.text = "  Other Locations"
            label.backgroundColor = COLOR1
            label.font = UIFont(name: font1Medium, size: 17)
        }
        return label
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("LocationsCell") as? LocationsCell {
            
            cell.selectionStyle = .None
            print("COL: \(indexPath.section)")
            print("ROW: \(indexPath.row)")
            
            
            
            if indexPath.section == 0 {
                locNow = nearest
            } else if indexPath.section == 1 {
                locNow = branchesLoc[indexPath.row]
            }
           
            cell.configureCell(locNow.locationName, addressVal: locNow.address, contactVal: locNow.contact, storeHoursVal: locNow.storeHours)
            
         
            return cell
           
        
        } else {
            return UITableViewCell()
        }
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func backButtonPressed(sender:UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
