//
//  LaunchView.swift
//  FlickrHunt
//
//  Created by Sadiya Syeda on 9/26/24.
//

import SwiftUI

struct LaunchView: View {
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]),
                           startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 20)
                
                Text("Welcome to Flickr Hunt!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Text("Discover beautiful images")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                Spacer()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .padding(.bottom, 50)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    isActive = false
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(isActive: .constant(true))
    }
}
