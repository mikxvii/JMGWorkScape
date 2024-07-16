//
//  HomeDetailsScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero on 7/13/24.
//

import Foundation
import SwiftUI

struct AddHomeScreen: View {
    @Environment(\.modelContext) private var context

    
    // [Name, Address, Frequency]
    @State var houseInfo = ["", "", ""]
    
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
                    var newHome = House(name: houseInfo[0], address: houseInfo[1], frequency: houseInfo[2], image: selectedImage)
                    context.insert(newHome)
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
                        .background(Color(red: 200, green: 200, blue: 200))
                        .cornerRadius(40)
                }
            }.sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }


            // Text field where Name of client is inputted
            TextField("Name", text: $houseInfo[0])
                                .frame(maxWidth: 350, alignment: .topLeading)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                
            
            // Text field where Address of client is inputted
            TextField("Address", text: $houseInfo[1])
                                .frame(maxWidth: 350, alignment: .topLeading)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Picker for the frequency (still need to allign better)
            HStack(alignment: .center) {
                Text("Frequency: ")
                Picker("Frequency", selection: $houseInfo[2]) {
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
