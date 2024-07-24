//
//  HomeDetailsScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero and Christopher Rebollar-Ramirez on 7/13/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct AddHomeScreen: View {
    @Environment(\.modelContext) private var context

    @State var currName:String = ""
    @State var currAddress:String = ""
    @State var currFrequncy:String = "Friday" //default value to not get error for having "" as default
    @State var currJobD:String = ""
    
    @State var goBackToHome: Bool = false
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?

    
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
    
    var body: some View {
        // bool variable changed by Cancel and Done buttons
        NavigationStack {
            VStack(spacing: 30){
                HStack(spacing: 125){
                    // Cancel Button
                    Button(action: {
                        goBackToHome = true
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
                        goBackToHome = true
                        let house = House(currName, currAddress, currJobD, currFrequncy, selectedPhotoData)
                        context.insert(house)
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
                }.navigationDestination(isPresented: $goBackToHome) {
                    HomeScreen().navigationBarBackButtonHidden(true)
                }

                PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                    if let selectedPhotoData,
                       let uiImage = UIImage(data: selectedPhotoData) {
                        withAnimation {
                            Image(uiImage: uiImage)
                                .resizable()
                                    .cornerRadius(40)
                                .aspectRatio(contentMode: .fit)
                                .padding(5)
                        }
                    } else {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size:  50))
                            .foregroundColor(.black)
                            .padding(.vertical, 75.0)
                            .padding(.horizontal, 150)
                            .background(Color(red: 200, green: 200, blue: 200))
                            .cornerRadius(40)
                    }
                }
                if selectedPhotoData != nil {
                    Button (role: .destructive) {
                        withAnimation {
                            selectedPhotoData = nil
                            selectedPhoto = nil
                        }
                    } label: {
                        Image(systemName: "trash.circle.fill")
                    }
                        .font(.title)
                }
                

                // Text field where Name of client is inputted
                TextField("Customer Name", text: $currName)
                                    .frame(maxWidth: 350, alignment: .topLeading)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                
                // Text field where Address of client is inputted
                TextField("Address", text: $currAddress)
                                    .frame(maxWidth: 350, alignment: .topLeading)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Text field where job description is inputted
                TextField("Job Description", text: $currJobD)
                                    .frame(maxWidth: 350, alignment: .topLeading)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Picker for the frequency (still need to allign better)
                HStack(alignment: .center) {
                    Text("Frequency: ")
                    Picker("Frequency", selection: $currFrequncy) {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                Spacer()
                Spacer()
            }.task(id: selectedPhoto) {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    selectedPhotoData = data
                }
            }
        }
    }
}
