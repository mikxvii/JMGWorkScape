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
    // in Cmyk format
    let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
    let gray = Color(red: 0, green: 0, blue: 0, opacity: 0.04)
    
    let darkOlive = Color(red: 0.19, green: 0.23, blue: 0.16, opacity: 1.00)
    @State var searchText = ""
    @State var goToDetails: Bool = false
    @State var goToAdd: Bool = false
    @State var goToRoute: Bool = false
    @Query private var houses: [House]
    @Environment(\.modelContext) private var context
    
//    These are used to help display the houses!
    private let numberColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    // Function to get items for a specific page
    func getItems(for page: Int, itemsPerPage: Int) -> [House] {
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, houses.count)
        return Array(houses[startIndex..<endIndex])
    }
    
    
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
                    HStack(spacing: 157) {
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
                            HStack(spacing: 2){
                                Text("Label")
                                    .bold()
                                    .foregroundColor(.blue)
                                Image(systemName: "arrow.up.and.down")
                            }
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
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 30) {
                            ForEach(1..<pages + 1, id: \.self) { page in
                                let housesArray = getItems(for: page, itemsPerPage: itemsPerPage)
                                VStack{
                                    LazyVGrid(columns: numberColumns, spacing: 20){
                                        ForEach(housesArray, id: \.self) { item in
                                            Button(action: {
                                                // what to do when we click a house item
                                            }, label: {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 40)
                                                        .fill(gray)
                                                        .frame(width: 150, height: 150)
                                                        //.shadow(radius: 10, y: 10)
                                                    VStack{
                                                        Spacer()
                                                        Text(item.name)
                                                            .foregroundStyle(.white)
                                                            .padding(.horizontal, 12)
                                                            .padding(.vertical, 6)
                                                            .background(darkOlive)
                                                            .cornerRadius(15)
                                                    }.padding(.bottom, 20)
                                                }
                                            })
                                        }
                                    }
                                    //.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/) just used for testing
                                    // padding to make whole scrollable centers, might be a better way to do this
                                        .frame(width: 330)
                                    Spacer() // Need this spacer so when page isnt full of items, it start on top
                                }
                            }
                        }.scrollTargetLayout()
                    }.padding(.top, 20)
                    .scrollClipDisabled()
                    .scrollTargetBehavior(.viewAligned)
                    
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
            }.padding()
            
        }
    }

}
