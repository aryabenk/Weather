import UIKit
import RecastAI
import ForecastIO

struct WeatherOfTheDay {
    var date = String()
    var summary = String()
    var temperatureMax = Double()
    var temperatureMin = Double()
    var icon = String()
    
    init(date: String, summary: String, temperatureMax: Double, temperatureMin: Double, icon: String) {
        self.date = date
        self.summary = summary
        self.temperatureMax = temperatureMax
        self.temperatureMin = temperatureMin
        self.icon = icon
    }
}

class WeatherData: NSObject {
    var cityName = String()
    var latitude = Double()
    var longtitude = Double() 
    
    var temperature = Double()
    var summary = String()
    var icon = String()
    var weatherForWeek = [WeatherOfTheDay]()
    
    func getWeather(weatherData: Forecast?) {
        if let temperature = weatherData?.currently?.temperature as Double? {
            self.temperature = temperature
        }
        if let summary = weatherData?.currently?.summary as String? {
            self.summary = summary
        }
        if let icon = weatherData?.currently?.icon.debugDescription as String? {
            self.icon = icon
        }
        if weatherForWeek.count > 0 {
            weatherForWeek.removeAll()
        }
        getWeatherForWeek(weatherDataForWeek: weatherData?.daily?.data)
    }
    
    func getWeatherForWeek(weatherDataForWeek: [DataPoint]?) {
        if let week = weatherDataForWeek as [DataPoint]? {
            for day in week {
                let weather = WeatherOfTheDay(date: getDateOfDay(day: day), summary: getSummaryOfDay(day: day), temperatureMax: getMaxTemperatureOfDay(day: day), temperatureMin: getMinTemperatureOfDay(day: day), icon: getIconOfDay(day: day))
                self.weatherForWeek.append(weather)
            }
        }
    }
    
    func getMinTemperatureOfDay(day: DataPoint) -> Double {
        if let temperatureMin = day.temperatureMin as Double? {
            return temperatureMin
        }
        return 0
    }
    
    func getMaxTemperatureOfDay(day: DataPoint) -> Double {
        if let temperatureMax = day.temperatureMax as Double? {
            return temperatureMax
        }
        return 0
    }
    
    func getSummaryOfDay(day: DataPoint) -> String {
        if let summary = day.summary as String? {
            return summary
        }
        return ""
    }
    
    func getIconOfDay(day: DataPoint) -> String {
        if let icon = day.icon.debugDescription as String? {
            return icon
        }
        return ""
    }
    
    func getDateOfDay(day: DataPoint) -> String {
        if let date = day.time.description as String? {
            return changeDateFormat(dateString: date)
        }
        return ""
    }
    
    func changeDateFormat(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.locale = Locale(identifier: "en_EN")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return dateFormatter.string(from: date!)
    }
}
