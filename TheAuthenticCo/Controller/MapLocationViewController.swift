//
//  ViewController.swift
//  TheAuthenticCo
//
//  Created by Suraj on 08/02/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

class MapLocationViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager!
    let apiKey = "8c1e240150949fb7bfe0bf0503c8a20e"
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var isSetFirstTime:Bool = false
    var weatherInfoListData:[WeatherInfoListDataModel] = [WeatherInfoListDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        self.map.showsUserLocation = true
        self.map.isZoomEnabled = true
        self.map.mapType = MKMapType.standard
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MapLocationViewController.handleGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.map.addGestureRecognizer(tapGesture)
        
        self.title = "The Authentic Co"
        
    }
    
    @objc func handleGesture(_ gesture:UIGestureRecognizer){
        let touchLocation = gesture.location(in: map)
        let locationCoordinate = map.convert(touchLocation,toCoordinateFrom: map)
        self.toGetCurrentWeatherInfo(locationCoordinate.latitude, locationCoordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            if self.isSetFirstTime == false{
                self.isSetFirstTime = true
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.map.setRegion(region, animated: true)
            }
            //Show address of current user location
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if (error != nil){
                }
                if (placemarks) != nil
                {
                    let placemark = placemarks! as [CLPlacemark]
                    if placemark.count>0{
                        let placemark = placemarks![0]
                        
                        let adress = (placemark.thoroughfare != nil) ? placemark.thoroughfare : ""
                        let subAddress = (placemark.subThoroughfare != nil) ? placemark.subThoroughfare : ""
                        let locality = (placemark.locality != nil) ? placemark.locality : ""
                        let subLocality = (placemark.subLocality != nil) ? placemark.subLocality : ""
                        let country = (placemark.country != nil) ? placemark.country : ""
                        let postalCode = (placemark.postalCode != nil) ? placemark.postalCode : ""
                        
                        let theLocation: MKUserLocation = self.map.userLocation
                        theLocation.title = "\(subAddress! + " " + adress! + " " + subLocality!)"
                        theLocation.subtitle = "\(locality! + " " + country! + " " + postalCode!)"
                    }
                }
            }// end here
            
        }
    }
    
    func toGetCurrentWeatherInfo(_ lat:CLLocationDegrees, _ long:CLLocationDegrees){
        self.activityIndicator.startAnimating()
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric").responseJSON {
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                
                if let data = UserDefaults.standard.data(forKey: "weatherInfoListData"),
                let weatherListData = NSKeyedUnarchiver.unarchiveObject(with: data) as? [WeatherInfoListDataModel]{
                    self.weatherInfoListData = weatherListData
                    
                    let obj = WeatherInfoListDataModel(jsonResponse["name"].stringValue, "\(Int(round(jsonTemp["temp"].doubleValue)))")
                    self.weatherInfoListData.append(obj)
                    
                    let tasksDetailsObj = NSKeyedArchiver.archivedData(withRootObject: self.weatherInfoListData)
                    UserDefaults.standard.set(tasksDetailsObj, forKey: "weatherInfoListData")
                    UserDefaults.standard.synchronize()
                    
                }else{
                    
                    let obj = WeatherInfoListDataModel(jsonResponse["name"].stringValue, "\(Int(round(jsonTemp["temp"].doubleValue)))")
                    self.weatherInfoListData.append(obj)
                    
                    let tasksDetailsObj = NSKeyedArchiver.archivedData(withRootObject: self.weatherInfoListData)
                    UserDefaults.standard.set(tasksDetailsObj, forKey: "weatherInfoListData")
                    UserDefaults.standard.synchronize()
                }
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destination = storyBoard.instantiateViewController(withIdentifier: "WeatherInfoViewController") as! WeatherInfoViewController
                
                if let data = UserDefaults.standard.data(forKey: "weatherInfoListData"),
                let weatherListData = NSKeyedUnarchiver.unarchiveObject(with: data) as? [WeatherInfoListDataModel]{
                    destination.weatherInfoListData.removeAll()
                    destination.weatherInfoListData = weatherListData
                }
                
                let navigationViewController = UINavigationController(rootViewController: destination)
                self.present(navigationViewController, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func openWeatherListViewController(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyBoard.instantiateViewController(withIdentifier: "WeatherInfoViewController") as! WeatherInfoViewController
        
        if let data = UserDefaults.standard.data(forKey: "weatherInfoListData"),
            let weatherListData = NSKeyedUnarchiver.unarchiveObject(with: data) as? [WeatherInfoListDataModel]{
            destination.weatherInfoListData.removeAll()
            destination.weatherInfoListData = weatherListData
        }
        let navigationViewController = UINavigationController(rootViewController: destination)
        self.present(navigationViewController, animated: false, completion: nil)
    }
    
}

