//
//  HomeDetailsScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero on 7/13/24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            let red = Double((hexNumber & 0xff0000) >> 16) / 255.0
            let green = Double((hexNumber & 0x00ff00) >> 8) / 255.0
            let blue = Double(hexNumber & 0x0000ff) / 255.0
            
            self.init(red: red, green: green, blue: blue)
            return
        }
        
        self.init(red: 0, green: 0, blue: 0) // Return black if unable to parse
    }
}


struct AddHomeScreen: View {
    @State var emptyArray = ["", "", ""]
    @State private var navigateToNextScreen = false
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
    
    var body: some View {
        VStack {
            
        }
        VStack(spacing: 30){
            
            HStack(spacing: 125){
                
                // Cancel button
                Button(action: {
                    cancel()
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
                
                // Done Button
                Button(action: {
                    done()
                }, label: {
                    Text("Done")
                        .bold()
                        .foregroundColor(olive)
                        .padding(.horizontal, 25.0)
                        .padding(.vertical, 10)
                        .background(Color(hex: "#758f64"))
                        .cornerRadius(70)
                        .padding(5)
                        
                })

            }
        
            // Upload an image
            Button(action: {
                showingImagePicker = true
            }) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .cornerRadius(40)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                } else {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size:  50))
                        .foregroundColor(.black)
                        .padding(.vertical, 75.0)
                        .padding(.horizontal, 150)
                        .background(Color(hex: "#e4e4e4"))
                        .cornerRadius(40)
                }
            }.sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }


            // Text field where Name of client is inputted
            TextField("Name", text: $emptyArray[0])
                                .frame(maxWidth: 350, alignment: .topLeading)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                
            
            // Text field where Address of client is inputted
            TextField("Address", text: $emptyArray[1])
                                .frame(maxWidth: 350, alignment: .topLeading)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Picker for the frequency (still need to allign better)
            HStack(alignment: .center) {
                Text("Frequency: ")
                Picker("Frequency", selection: $emptyArray[2]) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
        }.navigationBarBackButtonHidden(true)
        Spacer()


    }
}
