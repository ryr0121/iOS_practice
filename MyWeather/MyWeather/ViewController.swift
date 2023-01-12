import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBOutlet weak var weatherInfoStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getCurrentWeatherBtnDidTap(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
    }
    
    func configureView(weatherInfo: WeatherInformation) {
        self.cityNameLabel.text = weatherInfo.name
        if let weather = weatherInfo.weather.first {
            self.currentWeatherLabel.text = weather.description
        }
        self.currentTempLabel.text = "\(Int(weatherInfo.temp.temp - 273.15))℃"
        self.minTempLabel.text = "최저: \(Int(weatherInfo.temp.minTemp - 273.15))℃"
        self.maxTempLabel.text = "최고: \(Int(weatherInfo.temp.maxTemp - 273.15))℃"
    }
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=c3f33f03b748102bae7b6b3a0ff00cbd") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in
            debugPrint(cityName)
            let successRange = (200..<300)
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let weatherInfo = try? decoder.decode(WeatherInformation.self, from: data) else {
                    debugPrint("weatherInfo get error")
                    return }
                DispatchQueue.main.async {
                    self?.weatherInfoStackView.isHidden = false
                    self?.configureView(weatherInfo: weatherInfo)
                }
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

