//
//  TravelledListDataModel.swift
//  SolulabTestProject
//
//  Created by Suraj on 05/01/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import Foundation

class WeatherInfoListDataModel:NSObject,NSCoding{
    
    var locationName:String = ""
    var locationTemp:String = ""
    
    init(_ locationName:String, _ locationTemp:String) {
        self.locationName = locationName
        self.locationTemp = locationTemp
    }
    
    required init(coder decoder: NSCoder){
        self.locationName = decoder.decodeObject(forKey: "locationName") as! String
        self.locationTemp = decoder.decodeObject(forKey: "locationTemp") as! String
    }
    func encode(with coder: NSCoder) {
        coder.encode(locationName, forKey: "locationName")
        coder.encode(locationTemp, forKey: "locationTemp")
    }
    
}
