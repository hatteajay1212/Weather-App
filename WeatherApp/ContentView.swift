//
//  ContentView.swift
//  WeatherApp
//
//  Created by Ajay Hatte on 25/06/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var weatherViewmodel : WeatherViewModel
    var body: some View {
            ScrollView(showsIndicators: false){
                LazyVStack(
                    spacing: 24
                ){
                    HStack(spacing:8){
                        Text("Hello, User")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                            .resizable()
                            .frame(width: 24,height: 24)
                            .foregroundColor(Color("PrimaryAccentColor"))
                            .onTapGesture {
                                weatherViewmodel.fetchWeatherData()
                            }
                    }
                    
                    HStack(
                        spacing: 16
                    ){
                        TextField("", text: $weatherViewmodel.location)
                            .font(.caption)
                            .padding(8)
                            .background(content: {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.gray, lineWidth: 1.5)
                            })
                        
                        Text("Submit")
                            .frame(width: 80,height: 36)
                            .font(.caption)
                            .foregroundColor(Color.white)
                            .background(Color("PrimaryAccentColor"))
                            .clipShape(.capsule)
                            .onTapGesture {
                                weatherViewmodel.fetchWeatherData()
                            }
                    }
                    
                    CurrentWeatherView()
                    DailyWeatherView()
                    
                    if weatherViewmodel.shouldShowDetailedView{
                        if let model = weatherViewmodel.selectedModelForecast, let modelWeatherData = model.day{
                            DailyWeatherDetailedView(modelDailyWeatherData: modelWeatherData)
                                .padding(4)
                        }
                    }
                }
            }
        .padding()
        .onAppear(perform: {
            weatherViewmodel.fetchWeatherData()
        })
        .alert(isPresented: $weatherViewmodel.shouldShowAlert, content: {
            Alert(title: Text("WeatherApp"),message: Text(weatherViewmodel.errorMessage),dismissButton: .default(Text("OK")))
        })
    }
}

#Preview {
    ContentView()
}

struct CurrentWeatherView : View {
    @EnvironmentObject var weatherViewmodel : WeatherViewModel
    let NOT_AVAILABLE = "NA"
    var body: some View {
        ZStack(
            alignment: .topTrailing
        ){
            ZStack{
                VStack(
                    spacing: 16
                ){
                    if let currentWeatherData = weatherViewmodel.currentWeatherData, let tempratureData = currentWeatherData.temperature{
                        
                        HStack{
                            Text("\(nil != tempratureData.temp ? "\(tempratureData.temp!) °C" : NOT_AVAILABLE)")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        HStack(
                            spacing: 0
                        ){
                            Text("Feels like ")
                            Text(nil != tempratureData.feels_like ? "\(tempratureData.feels_like!)°C" : NOT_AVAILABLE)
                            Text(" / ")
                            Text(currentWeatherData.weather?.first?.description ?? NOT_AVAILABLE)
                            Spacer()
                        }
                        .font(.subheadline)
                        
                        VStack{
                            VStack(
                                spacing: 16
                            ){
                                
                                HStack(){
                                    VStack{
                                        Image(systemName: "thermometer.high")
                                            .foregroundColor(Color.white)
                                        Text(nil != tempratureData.temp_max ? "\(tempratureData.temp_max!)°C" : NOT_AVAILABLE)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                        Text("Max Temp")
                                            .font(.caption)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    VStack{
                                        Image(systemName: "thermometer.low")
                                            .foregroundColor(Color.white)
                                        Text(nil != tempratureData.temp_min ? "\(tempratureData.temp_min!)°C" : NOT_AVAILABLE)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                        Text("Min Temp")
                                            .font(.caption)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    VStack{
                                        Image(systemName: "humidity.fill")
                                            .foregroundColor(Color.white)
                                        Text(nil != tempratureData.humidity ? "\(tempratureData.humidity!)%" : NOT_AVAILABLE)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                        Text("Humidity")
                                            .font(.caption)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                
                                HStack(){
                                    VStack{
                                        Image(systemName: "barometer")
                                            .foregroundColor(Color.white)
                                        Text(nil != tempratureData.pressure ? "\(tempratureData.pressure!) mb" : NOT_AVAILABLE)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                        Text("Pressure")
                                            .font(.caption)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    VStack{
                                        Image(systemName: "water.waves")
                                            .foregroundColor(Color.white)
                                        Text(nil != tempratureData.sea_level ? "\(tempratureData.sea_level!) ft" : NOT_AVAILABLE)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                        Text("Sea Level")
                                            .font(.caption)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    VStack{
                                        Image(systemName: "decrease.quotelevel")
                                            .foregroundColor(Color.white)
                                        Text(nil != tempratureData.grnd_level ? "\(tempratureData.grnd_level!) ft" : NOT_AVAILABLE)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                        Text("Ground Level")
                                            .font(.caption)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }else{
                            VStack{
                                if !weatherViewmodel.isLoadingCurrentData{
                                    Text("No Data Available")
                                }
                            }
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .foregroundColor(Color.white)
                .background{
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundColor(Color("PrimaryAccentColor"))
                }
                
                if weatherViewmodel.isLoadingCurrentData{
                    RefreshSpinnerView()
                }
            }
            
            Image("ic_weather_normal")
                .resizable()
                .frame(width: 100,height: 100)
                .scaledToFit()
                .offset(x: -24,y: -24)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DailyWeatherView : View {
    @EnvironmentObject var weatherViewmodel : WeatherViewModel
    let NOT_AVAILABLE = "NA"
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack{
            HStack{
                Text("Daily forecast")
                    .font(.title3)
                Spacer()
            }
            
            ZStack{
                if !weatherViewmodel.isLoadingDayWiseData && weatherViewmodel.dailyWeatherList.isEmpty{
                    VStack{
                        Text("No Data Available for Daywise forecast")
                            .font(.caption2)
                    }
                    .frame(height: 120)
                }else{
                    ScrollView(.horizontal,showsIndicators: false){
                        LazyHStack(spacing: 16,content: {
                            ForEach(weatherViewmodel.dailyWeatherList,id: \.date_epoch){modelDailyForecastData in
                                VStack(
                                    spacing: 8
                                ){
                                    Text(modelDailyForecastData.date ?? NOT_AVAILABLE)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                    HStack{
                                        if (modelDailyForecastData.day?.daily_chance_of_rain ?? 0) > 50{
                                            Image("ic_weather_rainy")
                                                .resizable()
                                                .frame(width: 48,height: 48)
                                        }else{
                                            Image("ic_weather_normal")
                                                .resizable()
                                                .frame(width: 48,height: 48)
                                        }
                                    }
                                    
                                    if let day = modelDailyForecastData.day{
                                        HStack(
                                            spacing:0
                                        ){
                                            Spacer()
                                            Text(nil != day.maxtemp_c ? "\(day.maxtemp_c!)°" : NOT_AVAILABLE)
                                            Text("/")
                                            Text(nil != day.mintemp_c ? "\(day.mintemp_c!)°" : NOT_AVAILABLE)
                                            Spacer()
                                        }
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        if let condition = day.condition{
                                            Text(condition.text ?? NOT_AVAILABLE)
                                                    .font(.caption2)
                                        }
                                    }
                                }
                                .padding(8)
                                .frame(width: 120)
                                .background{
                                    RoundedRectangle(cornerRadius: 16)
                                        .padding(8)
                                        .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                                        .overlay{
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color("PrimaryAccentColor"), lineWidth: 1)
                                        }
                                }
                                .onTapGesture(perform: {
                                    weatherViewmodel.selectedModelForecast = modelDailyForecastData
                                    weatherViewmodel.shouldShowDetailedView = true
                                })
                            }
                        })
                        .padding(8)
                        
                    }
                }
                
                if weatherViewmodel.isLoadingDayWiseData{
                    VStack{
                        RefreshSpinnerView()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct DailyWeatherDetailedView : View {
    var modelDailyWeatherData : ModelDailyWeatherData
    let NOT_AVAILABLE = "NA"
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(
            spacing: 16
        ){
            HStack(){
                VStack{
                    Image(systemName: "sun.max")
                        .foregroundColor(Color("PrimaryAccentColor"))
                    Text(nil != modelDailyWeatherData.uv ? "\(modelDailyWeatherData.uv!)" : NOT_AVAILABLE)
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text("UV index")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                
                VStack{
                    Image(systemName: "wind")
                        .foregroundColor(Color("PrimaryAccentColor"))
                    Text(nil != modelDailyWeatherData.maxwind_kph ? "\(modelDailyWeatherData.maxwind_kph!)km/h" : NOT_AVAILABLE)
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text("Wind")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                
                VStack{
                    Image(systemName: "humidity.fill")
                        .foregroundColor(Color("PrimaryAccentColor"))
                    Text(nil != modelDailyWeatherData.avghumidity ? "\(modelDailyWeatherData.avghumidity!)%" : NOT_AVAILABLE)
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text("Humidity")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
            }
            
            HStack(){
                VStack{
                    Image(systemName: "cloud.rain")
                        .foregroundColor(Color("PrimaryAccentColor"))
                    Text(nil != modelDailyWeatherData.daily_chance_of_rain ? "\(modelDailyWeatherData.daily_chance_of_rain!)%" : NOT_AVAILABLE)
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text("Chances of Rain")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                
                VStack{
                    Image(systemName: "cloud.snow")
                        .foregroundColor(Color("PrimaryAccentColor"))
                    Text(nil != modelDailyWeatherData.daily_chance_of_snow ? "\(modelDailyWeatherData.daily_chance_of_snow!)%" : NOT_AVAILABLE)
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text("Chances of Snow")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                
                VStack{
                    Image(systemName: "eye.fill")
                        .foregroundColor(Color("PrimaryAccentColor"))
                    Text(nil != modelDailyWeatherData.avgvis_km ? "\(modelDailyWeatherData.avgvis_km!)km" : NOT_AVAILABLE)
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text("Visibility")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 16)
                .padding(8)
                .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                .overlay{
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.secondary,lineWidth: 0.5)
                }
        }
    }
}

