//
//  HomeDetailsScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero on 7/13/24.
//

import Foundation
import SwiftUI

struct HomeDetailsScreen: View {
    @Environment(\.presentationMode) var presentationMode
    var house: House
    var houseDic: [String: House]
    @State var goToEdit: Bool = false

    
    let gray = Color(red: 0, green: 0, blue: 0, opacity: 0.04)
    let darkOlive = Color(red: 0.19, green: 0.23, blue: 0.16, opacity: 1.00)


    var body: some View {
        ZStack {
            Image("stone_screen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            ScrollView(.vertical) {
                VStack {
                    if house.getImg() != nil {
                        if let image = UIImage(data: house.getImg()!) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: 270)
                                .cornerRadius(40)
                        }
                    } else {
                        Image(systemName: "photo.artframe")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(gray)
                            .frame(maxWidth: .infinity, maxHeight: 270)
                            .cornerRadius(40)

                    }

                    
                    Text(house.getName() + "'s Home")
                        .font(.largeTitle)
                        .bold()
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                    
                    Text(house.getAddress())
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .frame(width: 289, height: 60)
                        .background(.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)

                    Text("\(house.getFrqFormatted())'s")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .frame(width: 289, height: 60)
                        .background(darkOlive)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)

                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Create Invoice")
                    })
                        .frame(width: 289, height: 50)
                        .foregroundColor(.white)
                        .background(.cyan)
                        .cornerRadius(10)
                        .padding(.bottom, 20)

                    Button(action: {
                        openMap(house.getAddress().replacingOccurrences(of: " ", with: ","))
                    }, label: {
                        Text("Take Me There")
                    })
                        .frame(width: 289, height: 50)
                        .foregroundColor(.white)
                        .background(.brown)
                        .cornerRadius(10)
                    
                    Spacer()
                }
                .ignoresSafeArea()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            goToEdit = true
                        }, label: {
                            Image(systemName: "pencil")
                        })
                    }
                }
            }
        }
        .sheet(isPresented: $goToEdit) {
            EditHomeScreen(housesDic: houseDic, house: house)
        }
    }
}
