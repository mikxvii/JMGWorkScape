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
    var housesDic: [String: House]
    @State var editHouses: [House] = []
    @State var stopHouses: [House] = []
    @State var remainingHouses: [House] = []
    var currentWeekday: String = "Monday" // Tester Day
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    let darkOlive = Color(red: 0.19, green: 0.23, blue: 0.16, opacity: 1.00)
    @State private var goToDetails = false
    @State private var goToAddStop = false
    @State private var selectedHouse: House?
       
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                Image("bronze_screen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                if daysOfWeek.contains(currentWeekday) {
                    VStack {
                        
                        Image(systemName: "map.circle")
                            .font(.title2)
                            .foregroundColor(.brown)
//                        Spacer()
//                        List {
//                            ForEach(editHouses, id: \.self) { house in
//                                HStack {
//                                    Spacer()
//                                    ZStack {
//                                        if let imageData = house.getImg(), let image = UIImage(data: imageData) {
//                                            Image(uiImage: image)
//                                                .frame(width: 360, height: 70)
//                                                .cornerRadius(10)
//                                                .padding(.bottom, 20)
//                                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                                                    Button(role: .destructive) {
//                                                        if let index = editHouses.firstIndex(of: house) {
//                                                            editHouses.remove(at: index)
//                                                        }
//                                                    } label: {
//                                                        Label("Delete", systemImage: "trash")
//                                                    }
//                                                }
//                                                .multilineTextAlignment(.center)
//                                                .onTapGesture {
//                                                    goToDetails = true
//                                                    selectedHouse = house
//                                                }
//                                        } else {
//                                            RoundedRectangle(cornerRadius: 10)
//                                                .frame(width: 360, height: 70)
//                                                .cornerRadius(10)
//                                                .padding(.bottom, 20)
//                                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                                                    Button(role: .destructive) {
//                                                        if let index = editHouses.firstIndex(of: house) {
//                                                            editHouses.remove(at: index)
//                                                        }
//                                                    } label: {
//                                                        Label("Delete", systemImage: "trash")
//                                                    }
//                                                }
//                                                .multilineTextAlignment(.center)
//                                                .onTapGesture {
//                                                    goToDetails = true
//                                                    selectedHouse = house
//                                                }
//                                        }
//                                        Text("\(house.getName()): \(house.getAddress())")
//                                            .foregroundStyle(.white)
//                                            .padding(.horizontal, 12)
//                                            .padding(.vertical, 6)
//                                            .background(darkOlive)
//                                            .cornerRadius(15)
//                                            .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
//                                    }
//                                    Spacer()
//                                }
//                            }
//
//                        }
//                        .listStyle(.inset)
//                        .frame(height: 640)
//                        Spacer()
                    }
                } else {
                    VStack {
                        Spacer()
                        Image(systemName: "tree")
                            .foregroundColor(.gray)
                            .font(.title)
                        Text("No work today :)")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if daysOfWeek.contains(currentWeekday) {
                        Text("\(currentWeekday) Route")
                            .bold()
                            .font(.largeTitle)
                            .shadow(color: Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 0.25), radius: 4, x: 0, y: 4)
                            .foregroundColor(.brown)
                    } else {
                        Text("\(currentWeekday)")
                            .bold()
                            .font(.largeTitle)
                            .shadow(color: Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 0.25), radius: 4, x: 0, y: 4)
                            .foregroundColor(.brown)
                    }
                }
            }
            .navigationDestination(isPresented: $goToDetails) {
                if let selectedHouse = selectedHouse {
                    HomeDetailsScreen(house: selectedHouse, houseDic: housesDic)
                }
            }
            .onAppear {
                editHouses = houses.filter { $0.getFrqSet().contains(currentWeekday) }
                remainingHouses = houses.filter { !$0.getFrqSet().contains(currentWeekday) }

            }
        }
    }
}
