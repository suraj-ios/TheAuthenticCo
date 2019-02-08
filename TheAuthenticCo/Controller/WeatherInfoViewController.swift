//
//  WeatherInfoViewController.swift
//  TheAuthenticCo
//
//  Created by Suraj on 08/02/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit

class WeatherInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    var weatherInfoListData:[WeatherInfoListDataModel] = [WeatherInfoListDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "The Authentic Co"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherInfoListData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherInfoTableViewCell", for: indexPath) as! WeatherInfoTableViewCell
        
        cell.weatherTemp.text = self.weatherInfoListData[indexPath.row].locationName
        cell.currentWeatherState.text = NSString(format:"\(self.weatherInfoListData[indexPath.row].locationTemp)%@" as NSString, "\u{00B0}") as String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @IBAction func dismissPage(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
