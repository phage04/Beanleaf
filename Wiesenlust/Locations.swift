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
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let kTableHeaderHeight: CGFloat = 300.0
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
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.plain, target:self, action:#selector(LocationsVC.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.plain, target:self, action:#selector(LocationsVC.showMenu))

        navigationController?.isNavigationBarHidden = false

        self.locationManager.requestAlwaysAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            UIApplication.shared.cancelAllLocalNotifications()
        }
        
        mapView.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.search
        searchBar.keyboardAppearance = UIKeyboardAppearance.dark

        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.font = UIFont(name: font1Regular, size: 14)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        activityIndicator.color = COLOR1
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        plotLocations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        plotLocations()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func plotLocations(){
        
        var index = 0
        
        self.branchesLoc.removeAll()
    
        for loc in branches {
            let geoCoder = CLGeocoder()
            
            geoCoder.geocodeAddressString(loc, completionHandler: { (placemarks, error) in
                
                
                // Place details
                
                if let placeMark = placemarks?[0] {
               
                    if let long = placeMark.location?.coordinate.longitude, let lat = placeMark.location?.coordinate.latitude   {
                        
                        if let name = placeMark.thoroughfare as String? {
                            self.nameTitle = name
                        } else if let name = placeMark.subLocality as String? {
                            self.nameTitle = name
                        }
                        
                        let locNow = Locations(title: "\(storeName)", locationName: "\(self.nameTitle) Branch", address: loc, contact: "\(contacts[index])", storeHours: "\(storeHours[index])", coordinates: CLLocationCoordinate2DMake( (lat), (long)), location: CLLocation(latitude: lat, longitude: long))
                        
                        
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
            index += 1
            })
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.showsCancelButton = true
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            tableView.reloadData()
        } else {
            inSearchMode = true
            filterContentForSearchText(searchBar.text!)
            
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        inSearchMode = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        view.endEditing(true)
        tableView.reloadData()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        filteredBranchesLoc = branchesLoc.filter { branches in
            
            return branches.address.lowercased().contains(searchText.lowercased()) || branches.locationName.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        view.endEditing(true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let longitude = userLocation.coordinate.longitude
        let latitude = userLocation.coordinate.latitude
        
        if let userLoc = userLocation as CLLocation? {
            self.getNearest(userLoc)
            
        }
        
    }
    
    func callClicked(_ sender:UIButton) {
        
        let buttonRow = sender.tag
        if buttonRow != 9999 {
            self.callNumber(branchesLoc[buttonRow].contact)
        } else if buttonRow == 9999 {
            self.callNumber(nearest.contact)
        }
    }
    
    func callNumber(_ phoneNumber:String) {
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }

    func getNearest(_ userloc: CLLocation!){
        self.index = 0
        
        var x = 0
        
        for locationX in self.branchesLoc {
            
            
            let distance = locationX.location.distance(from: userloc)
            
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
            if let nearest = self.nearest.location as CLLocation! , x == self.branchesLoc.count-1{
                self.centerMapOnLocation(nearest)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.locationManager.stopUpdatingLocation()
            }
            
        }
        
        
        
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.regionRadius = 500
        if (indexPath as NSIndexPath).section == 0 {
            self.centerMapOnLocation(nearest.location)
        } else if (indexPath as NSIndexPath).section == 1 {
            if inSearchMode {
                self.centerMapOnLocation(filteredBranchesLoc[(indexPath as NSIndexPath).row].location)
            } else {
                self.centerMapOnLocation(branchesLoc[(indexPath as NSIndexPath).row].location)
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationsCell") as? LocationsCell {
            
            cell.selectionStyle = .none
                
            
            if (indexPath as NSIndexPath).section == 0 {
                if let locNow = nearest {
                    cell.configureCell(locNow.locationName, addressVal: locNow.address, contactVal: locNow.contact, storeHoursVal: locNow.storeHours, row: 9999)
                } else {
                    return UITableViewCell()
                }
            } else if (indexPath as NSIndexPath).section == 1 {
                
                if inSearchMode {
                    if let locNow = filteredBranchesLoc[(indexPath as NSIndexPath).row] as Locations? {
                        cell.configureCell(locNow.locationName, addressVal: locNow.address, contactVal: locNow.contact, storeHoursVal: locNow.storeHours, row: (indexPath as NSIndexPath).row)
                    } else {
                        return UITableViewCell()
                    }
                } else {
                    if let locNow = branchesLoc[(indexPath as NSIndexPath).row] as Locations? {
                        cell.configureCell(locNow.locationName, addressVal: locNow.address, contactVal: locNow.contact, storeHoursVal: locNow.storeHours, row: (indexPath as NSIndexPath).row)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func backButtonPressed(_ sender:UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func showMenu() {
        performSegue(withIdentifier: "menuSegue", sender: nil)
    }
    
    

}
