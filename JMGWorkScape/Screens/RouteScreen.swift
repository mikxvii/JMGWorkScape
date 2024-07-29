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
    var currentWeekday: String = "Monday" // Tester Day
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    let darkOlive = Color(red: 0.19, green: 0.23, blue: 0.16, opacity: 1.00)


    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Image("bronze_screen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                
                if daysOfWeek.contains(currentWeekday) {
                    VStack(spacing: 30) {
                        ScrollView(.vertical) {
                            ForEach(houses) { house in
                                ZStack {
                                    if let imageData = house.getImg(), let image = UIImage(data: imageData) {
                                        Image(uiImage: image)
                                            .multilineTextAlignment(.center)
                                            .frame(width: 289, height: 60)
                                            .cornerRadius(10)
                                            .padding(.bottom, 20)
                                    } else {
                                        RoundedRectangle(cornerRadius: 10)
                                            .multilineTextAlignment(.center)
                                            .frame(width: 289, height: 60)
                                            .cornerRadius(10)
                                            .padding(.bottom, 20)
                                    }
                                    Text(house.getName())
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(darkOlive)
                                        .cornerRadius(15)
                                        .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                }
                            }
                            Spacer()
                        }
                    }
                }
//                else {
//                    Spacer()
//                    VStack {
//                        Image(systemName: "tree")
//                            .foregroundColor(.gray)
//                            .font(.title)
//                        Text("No work today")
//                            .foregroundColor(.gray)
//                    }
//                }
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
    }
}
