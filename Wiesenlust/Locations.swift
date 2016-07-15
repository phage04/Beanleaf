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
    var userLocOld: Locations!
    
    
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
            locationManager.startUpdatingLocation()
        }

        
        headerView = self.tableView.tableHeaderView
        self.tableView.tableHeaderView = nil
        self.tableView.addSubview(headerView)
        
        self.tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)

        self.tableView.dataSource = self
        self.tableView.delegate = self
        updateHeaderView()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let longitude = userLocation.coordinate.longitude
        let latitude = userLocation.coordinate.latitude
        
        centerMapOnLocation(userLocation)
        
                let geoCoder = CLGeocoder()
                
                geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
                    
                    // Place details
                    var placeMark: CLPlacemark!
                    placeMark = placemarks?[0]
                    print("City: \(placeMark.locality!)")
                    print("Street: \(placeMark.thoroughfare!)")
                    print("Postal Code: \(placeMark.postalCode!)")
                    print("Long: \(longitude) Lat: \(latitude)")
                    
                    self.userLocNow = Locations(title: "Your Location", locationName: "\(placeMark.subThoroughfare!)\(placeMark.thoroughfare!), \(placeMark.locality!) \(placeMark.postalCode!)", address: "\(placeMark.subThoroughfare!)\(placeMark.thoroughfare!), \(placeMark.locality!) \(placeMark.postalCode!)", contact: "n/a", coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                    self.userLocOld = self.userLocNow
                    if let oldLoc = self.userLocOld {
                        self.mapView.removeAnnotation(oldLoc)
                    }
                    self.mapView.addAnnotation(self.userLocNow)
                    
                   
                 
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
