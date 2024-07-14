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
    
    let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
    
    var body: some View {
        VStack(spacing: 30){
            
            HStack(spacing: 125){
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
        
            
            Image(systemName: "photo.badge.plus")
                .font(.system(size:  50))
                .foregroundColor(.black)
                .padding(.vertical, 75.0)
                .padding(.horizontal, 150)
                .background(Color(hex: "#e4e4e4"))
                .cornerRadius(40)


            
            TextField("Name", text: $emptyArray[0])
                                .frame(maxWidth: 350, alignment: .topLeading)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                
            
            
            TextField("Address", text: $emptyArray[1])
                                .frame(maxWidth: 350, alignment: .topLeading)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Frequency", text: $emptyArray[2])
                                .frame(maxWidth: 350, alignment: .topLeading)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
            
        }.navigationBarBackButtonHidden(true)
        Spacer()


    }
}
