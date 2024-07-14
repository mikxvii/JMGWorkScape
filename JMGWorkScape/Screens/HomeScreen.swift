//
//  HomeScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero and Christopher Rebollar-Ramirez on 7/13/24.
//

import SwiftUI
import Foundation

struct HomeScreen: View {
    let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
    @State var searchText = ""
    
    var body: some View {
        // Setting up for Screen switching
        NavigationView {
            ZStack {
                // HomeScreen background
                Image("olive_screen")
                    .resizable()
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)

                VStack {
                    HStack(spacing: 170) {
                        // Title of the Screen
                        Text("Homes")
                            .bold()
                            .font(.largeTitle)
                            .shadow(color: Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 0.25), radius: 4, x: 0, y: 4)
                            .foregroundColor(olive)
                        
                        // Supposed to be a filter button
                        Button(action: {
                            filter()
                        }, label: {
                            Text("Filter")
                                .bold()
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        })
  
                    }
                    ZStack {
                        // Text Box
                        TextField("'Calle Miramar..'", text: $searchText)
                                            .frame(maxWidth: 350, alignment: .topLeading)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Image(systemName: "magnifyingglass")
                                                    .offset(x: 150)
                                                    .foregroundColor(olive)
                    }
                    Spacer()
                    
                    // Might wanna change the UI for these, as
                    // only one button is needed
                    HStack(spacing: 115){
                        
//                        Button(action: {
//                            home()
//                        }, label: {
//                            Image(systemName: "house.fill")
//                                .foregroundColor(olive)
//                        })
                        
                        NavigationLink(destination: AddHomeScreen()) {
                            Image(systemName: "house.fill").foregroundColor(olive)
                                        }
                            
                        Button(action: {
                            route()
                        }, label: {
                            Image(systemName: "map")
                                .foregroundColor(olive)
                        })
                        
                    }.padding(.bottom, 30.0).font(.system(size:  40))

                    
                }
                .padding()
            }
            .padding()
        }.navigationBarBackButtonHidden(true)
    }
}
