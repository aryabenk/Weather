import UIKit
import RecastAI
import ForecastIO

class WeatherRequest: NSObject {
    var bot = RecastAIClient(token: "63f64b84aeb1934ad5d9b42304f7ed99", language: "en")
    var client = DarkSkyClient(apiKey: "952184233c5fbb2e3f61c763799a51b1")
    
    func makeWeatherRequest(cityLatitude: Double, cityLongtitude: Double, completeonClosure: @escaping (Forecast?) -> ()) {
        client.units = .si
        
        client.getForecast(latitude: cityLatitude, longitude: cityLongtitude, completion: { (result) in
            switch result {
            case .success(let current, _):
                completeonClosure(current as Forecast?)
            case .failure(let error):
                print(error)
            }
        })
    }
}
