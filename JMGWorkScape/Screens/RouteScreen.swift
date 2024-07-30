//
//  HomeDetailsScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero on 7/13/24.
//

import Foundation
import SwiftUI

struct RouteScreen: View {
//    var currentWeekday: String = getCurrentWeekday()
    var houses: [House]
    @State var editHouses: [House] = []
    var currentWeekday: String = "Monday" // Tester Day
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    let darkOlive = Color(red: 0.19, green: 0.23, blue: 0.16, opacity: 1.00)
    
       
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    // Background
                    Image("bronze_screen")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    
                    if daysOfWeek.contains(currentWeekday) {
                        VStack(spacing: 30) {
                            
                            Image(systemName: "map.circle")
                                .font(.title2)
                                .foregroundColor(.brown)
                            
                            ScrollView(.vertical) {
                                ForEach(editHouses, id: \.self) { house in
                                    ZStack {
                                        if let imageData = house.getImg(), let image = UIImage(data: imageData) {
                                            Image(uiImage: image)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 289, height: 60)
                                                .cornerRadius(10)
                                                .padding(.bottom, 20)
                                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                                    Button(role: .destructive) {
                                                        if let index = editHouses.firstIndex(of: house) {
                                                            editHouses.remove(at: index)
                                                        }
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                }
                                        } else {
                                            RoundedRectangle(cornerRadius: 10)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 289, height: 60)
                                                .cornerRadius(10)
                                                .padding(.bottom, 20)
                                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                                    Button(role: .destructive) {
                                                        if let index = editHouses.firstIndex(of: house) {
                                                            editHouses.remove(at: index)
                                                        }
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                }
                                        }
                                        Text("\(house.getName()): \(house.getAddress())")
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(darkOlive)
                                            .cornerRadius(15)
                                            .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                    }
                                }
                                Button(action: {
                                    // Navigate to AddStopScreen
                                }, label: {
                                    Image(systemName: "plus")
                                        .bold()
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 289, height: 60)
                                        .background(.brown)
                                        .cornerRadius(10)
                                        .padding(.bottom, 20)
                                })
                                
                                Button(action: {
                                    // Navigate to Maps
                                }, label: {
                                    Text("Go")
                                        .bold()
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 289, height: 60)
                                        .background(.green)
                                        .cornerRadius(10)
                                        .padding(.bottom, 20)
                                })
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("\(currentWeekday) Route")
                            .bold()
                            .font(.largeTitle)
                            .shadow(color: Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 0.25), radius: 4, x: 0, y: 4)
                            .foregroundColor(.brown)
                    }
                }
            }
            .onAppear {
                editHouses = houses
            }
        }
    }
}
