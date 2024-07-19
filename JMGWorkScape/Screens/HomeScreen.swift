//
//  HomeScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero and Christopher Rebollar-Ramirez on 7/13/24.
//

import SwiftUI
import Foundation
import SwiftData

struct HomeScreen: View {
    let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
    @State var searchText = ""
    
    @State var goToDetails: Bool = false
    @State var goToAdd: Bool = false
    @State var goToRoute: Bool = false
    @Query private var houses: [House]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        // Setting up for Screen switching
        if goToDetails {
            HomeDetailsScreen()
        } else if goToAdd {
            AddHomeScreen()
                .transition(.move(edge: .trailing).animation(.bouncy))
        } else if goToRoute {
            RouteScreen()
        } else {
            ZStack {
                // HomeScreen background
                Image("olive_screen")
                    .resizable()
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)
                
                VStack(spacing: 10) {
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
                            if !houses.isEmpty {
                                context.delete(houses[0])
                            }
                        }, label: {
                            Text("Filter")
                                .bold()
                                .foregroundColor(.blue)
                        })
                    }

                    ZStack {
                        TextField("'Calle Miramar..'", text: $searchText)
                            .frame(maxWidth: 350, alignment: .topLeading)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            search()
                        }, label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(olive)
                        }).offset(x: 145)
                    }
                    
                    // Page Calculation
                    let itemsPerPage = 6
                    let pages = Int(ceil(Double(houses.count) / Double(itemsPerPage)))
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(1..<pages + 1, id: \.self) { page in
                                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                                    ForEach(getItems(for: page, itemsPerPage: itemsPerPage), id: \.self) { item in
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.green)
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(45)
                                            
                                            Text(item.name)
                                                .padding(.horizontal, 40)
                                                .padding(.vertical, 8)
                                                .background(Color.white)
                                                .cornerRadius(20)
                                                .frame(width: 200, height: 100, alignment: .bottom)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Buttons for actions
                    HStack(spacing: 115) {
                        // Add a Home Button
                        Button(action: {
                            goToAdd = true
                        }, label: {
                            Image(systemName: "house.fill").foregroundColor(olive)
                        })
                        
                        Button(action: {
                            route()
                        }, label: {
                            Image(systemName: "map")
                                .foregroundColor(olive)
                        })
                    }
                    .padding(.bottom, 30.0)
                    .font(.system(size: 40))
                }
                .padding()
            }
            .padding()
        }
    }
    
    // Function to get items for a specific page
    func getItems(for page: Int, itemsPerPage: Int) -> [House] {
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, houses.count)
        return Array(houses[startIndex..<endIndex])
    }
}
