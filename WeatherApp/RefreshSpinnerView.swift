//
//  RefreshSpinnerView.swift
//  WeatherApp
//
//  Created by Ajay Hatte on 26/06/24.
//

import SwiftUI

struct RefreshSpinnerView: View {
    @State private var degree:Int = 270
    @State private var spinnerLength = 0.6
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 8)
            ZStack{
                Circle()
                    .fill(Color.white)
                    .frame(width: 36,height: 36)
                    .shadow(radius: 4)

                Circle()
                    .trim(from: 0.0,to: spinnerLength)
                    .stroke(Color("PrimaryAccentColor"),style: StrokeStyle(lineWidth: 2.0))
                    .animation(Animation.easeIn(duration: 1.5).repeatForever(autoreverses: true))
                    .frame(width: 16,height: 16)
                    .rotationEffect(Angle(degrees: Double(degree)))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .onAppear{
                        degree = 270 + 360
                        spinnerLength = 0
                    }
            }
            Spacer()
                .frame(height: 8)
        }
    }
}

#Preview {
    RefreshSpinnerView()
}
