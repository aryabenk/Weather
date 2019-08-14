import UIKit
import RecastAI
import ForecastIO

class dayCell: UITableViewCell {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var maxMinTemperature: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var request: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherForWeekTableView: UITableView!
    @IBOutlet weak var backgroundLabel: UILabel!
    
    var weatherRequest = WeatherRequest()
    var weather = WeatherData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityName.text = ""
        self.temperature.text = ""
        self.summary.text = ""
        
        backgroundLabel.layer.cornerRadius = 20
        backgroundLabel.layer.masksToBounds = true
        
        weatherForWeekTableView.layer.cornerRadius = 10
        weatherForWeekTableView.layer.masksToBounds = true
        
        weatherForWeekTableView.rowHeight = 50
        
        searchButton.layer.cornerRadius = 5
        //searchButton.layer.masksToBounds = true
        
        
        cityName.isHidden = true
        temperature.isHidden = true
        summary.isHidden = true
        weatherIcon.isHidden = true
        weatherForWeekTableView.isHidden = true
        backgroundLabel.isHidden = true
    }
    
    @IBAction func pressRequestButton(_ sender: UIButton) {
        if let cityName = request.text as String? {
            if !cityName.isEmpty {
                makeLocationRequest(cityName: cityName)
            }
        }
    }
    
    func makeLocationRequest(cityName: String) {
        weatherRequest.bot.textRequest(cityName, successHandler: requestSuccess, failureHandle: requestFailure)
    }
    
    func requestSuccess(response: Response) {
        if let location = response.get(entity: "location") as NSDictionary? {
            if let city = location["city"] as? String {
                self.weather.cityName = city
                if let lat = location["lat"] as? Double {
                    self.weather.latitude = lat
                }
                if let lng = location["lng"] as? Double {
                    self.weather.longtitude = lng
                }
            }
            else {
                cityError()
            }
        }
        else {
            cityError()
        }
        
        self.weatherRequest.makeWeatherRequest(cityLatitude: self.weather.latitude, cityLongtitude: self.weather.longtitude) {
            weatherData in
            self.weather.getWeather(weatherData: weatherData)
            DispatchQueue.main.async {
                self.displayWeather()
            }
        }
    }
    
    func requestFailure(error: Error) {
        cityError()
    }
    
    func displayWeather() {
        self.weatherIcon.image = UIImage(named: "\(weather.icon).png")
        self.weatherIcon.reloadInputViews()
        self.cityName.text = weather.cityName
        self.cityName.reloadInputViews()
        self.summary.text = weather.summary
        self.summary.reloadInputViews()
        self.temperature.text = "\(Int(weather.temperature))°C"
        
        cityName.isHidden = false
        temperature.isHidden = false
        summary.isHidden = false
        weatherIcon.isHidden = false
        weatherForWeekTableView.isHidden = false
        backgroundLabel.isHidden = false
        
        self.temperature.reloadInputViews()
        self.weatherForWeekTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.weatherForWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell") as! dayCell
        
        cell.date.text = String(weather.weatherForWeek[indexPath.row].date)
        cell.maxMinTemperature.text = "\(Int(weather.weatherForWeek[indexPath.row].temperatureMin))°C/\(Int(weather.weatherForWeek[indexPath.row].temperatureMax))°C"
        cell.weatherIcon.image = UIImage(named: "\(weather.weatherForWeek[indexPath.row].icon).png")
        return cell
    }
    
    func cityError() {
        let alert = UIAlertController(title: "Error", message: "Such city not found", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
