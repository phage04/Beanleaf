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
import SideMenu

class LocationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let kTableHeaderHeight: CGFloat = 300.0
    var headerView: UIView!
    var regionRadius: CLLocationDistance = 1000
    var userLocNow: Locations!
    var locNow: Locations!
    var index: Int = 0
    let locationManager = CLLocationManager()

    var branchesLoc = [Locations]()
    var filteredBranchesLoc = [Locations]()
    var inSearchMode = false
    var nearest: Locations!
    var nameTitle: String!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.Plain, target:self, action:#selector(LocationsVC.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:#selector(LocationsVC.showMenu))

        navigationController?.navigationBarHidden = false

        self.locationManager.requestAlwaysAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
        
        mapView.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Search
        searchBar.keyboardAppearance = UIKeyboardAppearance.Dark

        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.font = UIFont(name: font1Regular, size: 14)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        plotLocations()
    }
    
    override func viewDidAppear(animated: Bool) {
        plotLocations()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
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
                
                if let placeMark = placemarks?[0] {
               
                    if let long = placeMark.location?.coordinate.longitude, lat = placeMark.location?.coordinate.latitude   {
                        
                        if let name = placeMark.thoroughfare as String? {
                            self.nameTitle = name
                        } else if let name = placeMark.subLocality as String? {
                            self.nameTitle = name
                        }
                        
                        let locNow = Locations(title: "\(storeName)", locationName: "\(self.nameTitle) Branch", address: loc, contact: "+639178235953", coordinates: CLLocationCoordinate2DMake( (lat), (long)), location: CLLocation(latitude: lat, longitude: long))
                        
                        
                        print(locNow.locationName)
                        
                        if branches.count > self.branchesLoc.count {
                            self.branchesLoc.append(locNow)
                        }
                        

                        self.mapView.addAnnotation(locNow)
                        if self.branchesLoc.count == branches.count {
                            
                            self.tableView.reloadData()
                        }
                    }
                
                }
            
            })
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.showsCancelButton = true
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            tableView.reloadData()
        } else {
            inSearchMode = true
            filterContentForSearchText(searchBar.text!)
            
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        inSearchMode = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        view.endEditing(true)
        tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        
        filteredBranchesLoc = branchesLoc.filter { branches in
            
            return branches.address.lowercaseString.containsString(searchText.lowercaseString) || branches.locationName.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        view.endEditing(true)
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let longitude = userLocation.coordinate.longitude
        let latitude = userLocation.coordinate.latitude
        
        if let userLoc = userLocation as CLLocation? {
            self.getNearest(userLoc)
            
        }
        
    }
    
    func callClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
        if buttonRow != 9999 {
            self.callNumber(branchesLoc[buttonRow].contact)
        } else if buttonRow == 9999 {
            self.callNumber(nearest.contact)
        }
    }
    
    func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }

    func getNearest(userloc: CLLocation!){
        self.index = 0
        
        var x = 0
        
        for locationX in self.branchesLoc {
            
            
            let distance = locationX.location.distanceFromLocation(userloc)
            
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
            print("\(x) \(self.branchesLoc.count)")
            if let nearest = self.nearest.location as CLLocation! where x == self.branchesLoc.count-1{
                self.centerMapOnLocation(nearest)
                self.locationManager.stopUpdatingLocation()
            }
            
        }
        
        
        
        self.tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if inSearchMode {
            return filteredBranchesLoc.count
            }
            return branchesLoc.count
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
            label.backgroundColor = COLOR1
            label.font = UIFont(name: font1Medium, size: 17)
            if inSearchMode {
                label.text = "  Search Results"
            } else {
                label.text = "  Our Locations"
            }
        }
        return label
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.regionRadius = 500
        if indexPath.section == 0 {
            self.centerMapOnLocation(nearest.location)
        } else if indexPath.section == 1 {
            if inSearchMode {
                self.centerMapOnLocation(filteredBranchesLoc[indexPath.row].location)
            } else {
                self.centerMapOnLocation(branchesLoc[indexPath.row].location)
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("LocationsCell") as? LocationsCell {
            
            cell.selectionStyle = .None
                
            
            if indexPath.section == 0 {
                if let locNow = nearest {
                    cell.configureCell(locNow.locationName, addressVal: locNow.address, contactVal: locNow.contact, storeHoursVal: locNow.storeHours, row: 9999)
                } else {
                    return UITableViewCell()
                }
            } else if indexPath.section == 1 {
                
                if inSearchMode {
                    if let locNow = filteredBranchesLoc[indexPath.row] as Locations? {
                        cell.configureCell(locNow.locationName, addressVal: locNow.address, contactVal: locNow.contact, storeHoursVal: locNow.storeHours, row: indexPath.row)
                    } else {
                        return UITableViewCell()
                    }
                } else {
                    if let locNow = branchesLoc[indexPath.row] as Locations? {
                        cell.configureCell(locNow.locationName, addressVal: locNow.address, contactVal: locNow.contact, storeHoursVal: locNow.storeHours, row: indexPath.row)
                    } else {
                        return UITableViewCell()
                    }
                }
                
            }

            return cell
           
        
        } else {
            return UITableViewCell()
        }
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func backButtonPressed(sender:UIButton) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func showMenu() {
        performSegueWithIdentifier("menuSegue", sender: nil)
    }
    
    

}
