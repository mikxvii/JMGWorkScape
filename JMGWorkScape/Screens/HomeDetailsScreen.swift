//
//  HomeDetailsScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero on 7/13/24.
//

import Foundation
import SwiftUI

struct HomeDetailsScreen: View {
    
    //
    // Environment variables
    //
    
    @Environment(\.presentationMode) var presentationMode
    
    //
    // Parameters
    //
    
    var house: House
    var houseDic: [String: House]
    
    //
    // State Variables
    //
    
    @State var goToEdit: Bool = false
    @State var goToInvoice: Bool = false

    
    let gray = Color(red: 0, green: 0, blue: 0, opacity: 0.04)
    let darkOlive = Color(red: 0.19, green: 0.23, blue: 0.16, opacity: 1.00)


    var body: some View {
        // Used to frame background
        GeometryReader { geo in
            ZStack {
                // Background
                Image("stone_screen")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)

                ScrollView(.vertical) {
                    VStack {
                        // Display Image
                        if house.getImg() != nil {
                            if let image = UIImage(data: house.getImg()!) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity, maxHeight: 270)
                                    .cornerRadius(40)
                            }
                        } 
                        else {
                            Image(systemName: "photo.artframe")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(gray)
                                .frame(maxWidth: .infinity, maxHeight: 270)
                                .cornerRadius(40)

                        }

                        // Display House Owner Name
                        Text(house.getName() + "'s Home")
                            .font(.largeTitle)
                            .bold()
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                        
                        // Display House Address
                        Text(house.getAddress())
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .frame(width: 289, height: 60)
                            .background(.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                        
                        // Display formatted frequency
                        Text("\(house.getFrqFormatted())'s")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .frame(width: 289, height: 60)
                            .background(darkOlive)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 20)

                        // Create Invoice Button (-> InvoiceScreen)
                        Button(action: {
                            goToInvoice = true
                        }, label: {
                            Text("Create Invoice")
                        })
                            .frame(width: 289, height: 50)
                            .foregroundColor(.white)
                            .background(.cyan)
                            .cornerRadius(10)
                            .padding(.bottom, 20)

                        // Opens Map directions to house address (-> Apple Maps)
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
                        // Edit Home Button (-> EditHomeScreen)
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
            .navigationDestination(isPresented: $goToInvoice) {
                InvoiceScreen(house: house)
            }
        }
    }
}
