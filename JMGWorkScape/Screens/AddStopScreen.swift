//
//  HomeDetailsScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero on 7/13/24.
//

import Foundation
import SwiftUI

struct AddStopScreen: View {
    
    var houses: [House]
    var housesDic: [String: House]
    @State var selectedHouse: House?
    
    let gray = Color(red: 0, green: 0, blue: 0, opacity: 0.04)
    let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
    let darkOlive = Color(red: 0.19, green: 0.23, blue: 0.16, opacity: 1.00)
    

    @Environment(\.presentationMode) var presentationMode
    
    private let numberColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func pullItems(_ houseNames: [String]) -> [House] {
        // Use the house names to look up the corresponding House objects in the dictionary
        let houseObjects = houseNames.compactMap { housesDic[$0] }
        return houseObjects
    }
    
    func getItems(for page: Int, itemsPerPage: Int) -> [House] {
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, houses.count)
        return Array(houses[startIndex..<endIndex])
    }
    
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                            .bold()
                            .foregroundColor(.black)
                            .padding(.horizontal, 25.0)
                            .padding(.vertical, 10)
                            .background(.red)
                            .cornerRadius(70)
                            .padding(5)
                    })
                    Spacer()
                    Text("Add Stop")
                        .font(.headline)
                        .bold()
                        .foregroundColor(olive)
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done")
                            .bold()
                            .foregroundColor(olive)
                            .padding(.horizontal, 25.0)
                            .padding(.vertical, 10)
                            .background(Color(red: 117/255, green: 143/255, blue: 100/255))
                            .cornerRadius(70)
                            .padding(5)
                    })
                    Spacer()
                }
                
                let itemsPerPage = 6
                let pages = Int(ceil(Double(houses.count) / Double(itemsPerPage)))
                
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 50) {
                        ForEach(1..<pages + Int(1.0), id: \.self) { page in
                            let housesArray = getItems(for: page, itemsPerPage: itemsPerPage)
                            VStack {
                                LazyVGrid(columns: numberColumns, spacing: 20) {
                                    ForEach(housesArray, id: \.self) { house in
                                        @State var image = "circlebadge"
                                        ZStack {
                                            Button(action: {
                                                selectedHouse = house
                                            }, label: {
                                                ZStack {
                                                    if let imageData = house.getImg(), let image = UIImage(data: imageData) {
                                                        Image(uiImage: image)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 150, height: 150)
                                                            .cornerRadius(40)
                                                            .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                                    } else {
                                                        RoundedRectangle(cornerRadius: 40)
                                                            .fill(gray)
                                                            .frame(width: 150, height: 150)
                                                            .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                                    }
                                                    VStack {
                                                        Spacer()
                                                        Text(house.getName())
                                                            .foregroundStyle(.white)
                                                            .padding(.horizontal, 12)
                                                            .padding(.vertical, 6)
                                                            .background(darkOlive)
                                                            .cornerRadius(15)
                                                            .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                                    }
                                                    .padding(.bottom, 20)
                                                }
                                            })
                                        }
                                    }
                                }
                                .frame(width: 330)
                                Spacer() // Need this spacer so when page isn't full of items, it starts on top
                            }
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, 40)
                }
                .padding(.top, 20)
                .scrollClipDisabled()
                .scrollTargetBehavior(.viewAligned)

                if houses.isEmpty {
                    Spacer()
                    Image(systemName: "tree")
                        .foregroundColor(.gray)
                        .font(.title)
                    Text("No homes added")
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
    }
}
