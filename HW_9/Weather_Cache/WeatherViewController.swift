//
//  WeatherViewController.swift
//  HW_9
//
//  Created by Elizaveta Rogozhina on 14.07.2021.
//

import UIKit

var cityNameAlam: String = "" // needed for search city

class WeatherViewController: UIViewController {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var today_Label_Alam: UILabel!
    @IBOutlet weak var icon_Image_Alam: UIImageView!
    @IBOutlet weak var temp_Label_Alam: UILabel!
    @IBOutlet weak var max_Label_Alam: UILabel!
    @IBOutlet weak var min_temp_Label_alam: UILabel!
    @IBOutlet weak var descript_Label_Alam: UILabel!
    @IBOutlet weak var feels_like_Label_Alam: UILabel!
    @IBOutlet weak var weather_Table_Alamofire: UITableView!
    
    var massForTableAlam: [DaysInfo.forBaseTableAlam] = [],
        codFiveDays = "",
        tableRowDataAlam: String = "",
        dayForTableAlam: [String] = [],
        allDataAlam: [String] = [],
        allWeatherInfo_Alam: [[DaysInfo.forBaseTableAlam]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameAlam = searchTF.text!
        let viewModelAlam = ViewModelAlamofire()
        viewModelAlam.weatherDelegateAlam = self
        self.weather_Table_Alamofire.reloadData()
        self.weather_Table_Alamofire.dataSource = self
    }
    @IBAction func searchButton(_ sender: Any) {
        let alert = Alerts()
        if searchTF.text?.isEmpty == true{
            alert.alertNilTF(vc: self)
        }
        else{
            cityNameAlam = searchTF.text!
            let changeURL = changeURL()
            changeURL.changeTodayURLAlam(cityName: cityNameAlam)
            changeURL.changeFiveDaysURLAlam(cityName: cityNameAlam)
            if codFiveDays == ""{
                alert.alertCityNotFound(vc: self, cityName: cityNameAlam)
            }else{
                codFiveDays = ""
                let viewModelAlam = ViewModelAlamofire()
                viewModelAlam.weatherDelegateAlam = self
                self.weather_Table_Alamofire.reloadData()
                self.weather_Table_Alamofire.dataSource = self
            }
        }
    }
}

extension WeatherViewController: uploadWeatherAlamofire{

    func uploadFiveDays(todayData: String, allData_: [String], massForTable_: [DaysInfo.forBaseTableAlam], cod: String, allWeatherInfo_:  [[DaysInfo.forBaseTableAlam]]) {
        allWeatherInfo_Alam = allWeatherInfo_
        codFiveDays = cod
        allDataAlam = allData_
        massForTableAlam = massForTable_
        
        var set = Set<String>()
        dayForTableAlam = allDataAlam.filter{ set.insert($0).inserted }
        dayForTableAlam = dayForTableAlam.filter { $0 != "Not Found" }
        dayForTableAlam = dayForTableAlam.filter { $0 != todayData }
        weather_Table_Alamofire.reloadData()
    }
    
    func uploadToday(todayAlam: DaysInfo.All_Day_Info, description: String, image: UIImage) {
        let date = NSDate(timeIntervalSince1970: TimeInterval(todayAlam.dt)),
            dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "YYYY-MM-dd"

        let dateString = dayTimePeriodFormatter.string(from: date as Date)
     
        self.today_Label_Alam.text = "TODAY: \(dateString)"
        self.temp_Label_Alam.text = "\(String(describing: Int(todayAlam.main!.temp - 273.15)))°C \(cityNameAlam)"
        self.min_temp_Label_alam.text = "Min: \(String(describing: Int(todayAlam.main!.temp_min - 273.15)))°C"
        self.max_Label_Alam.text = "Max: \(String(describing: Int(todayAlam.main!.temp_max - 273.15)))°C"
        self.feels_like_Label_Alam.text = "Feels like: \(String(describing: Int(todayAlam.main!.feels_like - 273.15)))°C"
        self.descript_Label_Alam.text = description
        self.icon_Image_Alam.image = image
        weather_Table_Alamofire.reloadData()
    }
}

extension WeatherViewController: UITableViewDataSource{

    func tableView(_ tableView_Alam: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayForTableAlam.count
    }

    func tableView(_ tableView_Alam: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell_Alam = tableView_Alam.dequeueReusableCell(withIdentifier: "weather_Alamofire", for: indexPath) as! WeatherAlamofireTableViewCell
        
        tableRowDataAlam = dayForTableAlam[indexPath.row]
        cell_Alam.dataForCollectionAlam = allWeatherInfo_Alam[indexPath.row]
        cell_Alam.collectionTableAlam.reloadData()
        
        //day cell
        cell_Alam.day_Label_Alam.text = "\(tableRowDataAlam) \(cityNameAlam)"
        return cell_Alam
    }
}

extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
