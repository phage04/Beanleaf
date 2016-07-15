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
    var branches:[String] = ["Berger Str. 77, 60316 Frankfurt am Main", "An der Welle 7 60322 Frankfurt Germany"]
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

        
        headerView = self.tableView.tableHeaderView
        self.tableView.tableHeaderView = nil
        self.tableView.addSubview(headerView)
        
        self.tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)

        self.tableView.dataSource = self
        self.tableView.delegate = self
        updateHeaderView()
        plotLocations()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func plotLocations(){
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
        
        
       
        
                let geoCoder = CLGeocoder()
                
                geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
                    
                    // Place details
                    var placeMark: CLPlacemark!
                    placeMark = placemarks?[0]
                    
                    self.userLocNow = Locations(title: "Your Location", locationName: "\(placeMark.subThoroughfare!)\(placeMark.thoroughfare!), \(placeMark.locality!) \(placeMark.postalCode!)", address: "\(placeMark.subThoroughfare!)\(placeMark.thoroughfare!), \(placeMark.locality!) \(placeMark.postalCode!)", contact: "n/a", coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), location: CLLocation(latitude: latitude, longitude: longitude))
                    
                    
                    
                    for locationX in self.branchesLoc {
                        
                        
                        let distance = locationX.location.distanceFromLocation(userLocation)
                        print(distance)
                        locationX.addDistance(distance)
                        
                        if let _ = self.nearest {
                            
                            if self.nearest.distance > locationX.distance {
                                self.nearest = locationX
                            }              
                            
                        } else {
                            self.nearest = locationX
                        }
                    
                    }
                    print(self.nearest.address)
                    self.centerMapOnLocation(self.nearest.location)
                   
                 
                })
        
        

        
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderView()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: self.tableView.bounds.width, height: kTableHeaderHeight)
        
        if self.tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = self.tableView.contentOffset.y
            headerRect.size.height = -self.tableView.contentOffset.y
        }
        
        headerView.frame = headerRect
    }
    


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func backButtonPressed(sender:UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
