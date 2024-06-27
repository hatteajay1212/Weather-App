//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Ajay Hatte on 25/06/24.
//

import Foundation
import Alamofire
import Combine

class WeatherViewModel : ObservableObject{
    let TAG = "WeatherViewModel"
    @Published var dailyWeatherList : [ModelDailyForecastData] = []
    @Published var currentWeatherData : ModelCurrentWeatherData?
    @Published var location : String = "Nagpur"
    var latitude : Double = 19.07
    var longitude : Double = 72.87
    private var cancellables = Set<AnyCancellable>()
    let API_KEY = "9de990522fa65d853b2684bee02bf731"
    let APP_KEY_FOR_DAILY_DATA = "a7397a987f864ab0a71100649242606"
    @Published var shouldShowDetailedView = false
    var selectedModelForecast : ModelDailyForecastData?
    @Published var isLoadingCurrentData = false
    let NO_OF_DAYS = 10
    @Published var isLoadingDayWiseData = false
    var errorMessage : String = ""
    @Published var shouldShowAlert = false
    
    func fetchWeatherData(){
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchCurrentWeatherData(onCompletion: {
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        fetchDailyWeatherData(onCompletion: {
            dispatchGroup.leave()
        })
    }
    
    private func fetchCurrentWeatherData(onCompletion : @escaping () -> ()){
        let methodTag = "getCurrentWeatherData"
        let url = NetworkUtils.URL_CURRENT_WEATHER_DATA
        let parameters : [String : Any] = [
            APIKeys.KEY_LATITUDE : latitude,
            APIKeys.KEY_LONGITUDE : longitude,
            APIKeys.KEY_APP_ID : API_KEY,
            APIKeys.KEY_UNITS : "metric"
        ]
        
        if NetworkUtils.isInternetAvailable(){
            DispatchQueue.main.async {
                self.isLoadingCurrentData = true
            }
            AF.request(url,method: .get,parameters: parameters,encoding: URLEncoding.queryString,headers:nil)
                .validate()
                .publishDecodable(type: ModelCurrentWeatherData.self)
                .value()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: {[weak self] completion in
                    onCompletion()
                    switch(completion){
                    case .finished:
                        break
                    case .failure(let error):
                        print("\(self?.TAG) \(methodTag) errorcode : \(error.responseCode)")
                        self?.isLoadingCurrentData = false
                        if error.isResponseSerializationError {
                            self?.showAlert(message: "Error while decoding data, please try again.")
                        }else{
                            self?.handleApiErrors(errorCode: error.responseCode ?? 0)
                        }
                    }
                }, receiveValue: {[weak self] response in
                    print("\(self?.TAG) \(methodTag) response : \(response)")
                    guard let self = self else {
                        return
                    }
                    self.currentWeatherData = response
                    self.isLoadingCurrentData = false
                })
                .store(in: &cancellables)
        }else{
            showAlert(message: "Bad internet connectivity, please try again.")
        }
    }
        
    private func fetchDailyWeatherData(onCompletion : @escaping () -> ()){
        let methodTag = "fetchDailyWeatherData"
        let url = NetworkUtils.URL_DAILY_WEATHER_DATA
        let parameters : [String : Any] = [
            APIKeys.KEY_QUERY : location,
            APIKeys.KEY_APP_KEY : APP_KEY_FOR_DAILY_DATA,
            APIKeys.KEY_NO_OF_DAYS : NO_OF_DAYS
        ]
        
        if NetworkUtils.isInternetAvailable(){
            DispatchQueue.main.async {
                self.isLoadingDayWiseData = true
            }
            AF.request(url,method: .get,parameters: parameters,encoding: URLEncoding.queryString,headers:nil)
                .validate()
                .publishDecodable(type: ModelDailyWeatherDataResponse.self)
                .value()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: {[weak self] completion in
                    onCompletion()
                    switch(completion){
                    case .finished:
                        break
                    case .failure(let error):
                        print("\(self?.TAG) \(methodTag) errorcode : \(error.responseCode)")
                        self?.isLoadingDayWiseData = false
                        if error.isResponseSerializationError {
                            self?.showAlert(message: "Error while decoding data, please try again.")
                        }else{
                            self?.handleApiErrors(errorCode: error.responseCode ?? 0)
                        }
                    }
                }, receiveValue: {[weak self] response in
                    print("\(self?.TAG) \(methodTag) response : \(response)")
                    guard let self = self else { return }
                    guard let modelDailyForecast = response.forecast, let modelForecastDataList = modelDailyForecast.forecastday else {
                        self.dailyWeatherList = []
                        self.isLoadingDayWiseData = false
                        return
                    }
                    
                    self.dailyWeatherList = modelForecastDataList
                    self.isLoadingDayWiseData = false
                })
                .store(in: &cancellables)
        }else{
            showAlert(message: "Bad internet connectivity, please try again.")
        }
    }
    
    deinit{
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func handleApiErrors(errorCode : Int){
        var errorMessage = ""
        switch(errorCode){
        case APIErrorCodes.ERROR_CODE_API_KEY_INVALID :
            errorMessage = "Invalid API Key, please contact developer"
        case APIErrorCodes.ERROR_CODE_AUTHENTICATION :
            errorMessage = "Invalid API Key, please contact developer"
        case APIErrorCodes.ERROR_CODE_INVALID_QUERY_PARAM :
            errorMessage = "Invalid location, Please enter valid location"
        case 500..<600 :
            errorMessage = "Server error, please try again after some time"
        default :
            errorMessage = "Some Error Occured"
        }
        showAlert(message: errorMessage)
    }
    
    func showAlert(message : String){
        shouldShowAlert = true
        errorMessage = message
    }
}
