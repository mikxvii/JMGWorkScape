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
    
    //
    // Environment variables
    //
    
    // Context for adding House items to SwiftData
    @Environment(\.modelContext) private var context
    
    // Necessary for switching back to main view
    @Environment(\.presentationMode) var presentationMode
    

    
    //
    // State Variables
    //
    
    // Used to show alerts incase there is an existing house or fields are missing
    @State private var showFieldAlert: Bool = false
    @State private var showMatchAlert: Bool = false
    
    @State private var currName:String = ""
    @State private var currAddress:String = ""
    @State private var currFrequncy = Set<String>() //default value to not get error for having "" as default
    @State private var currJobD:String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    // Used to switch back to HomeScreen
    @State private var goBackToHome: Bool = false
    
    // Dictionary is used to check if the new house already exists
    
    //
    // Parameters
    //
    
    @State var houseSearchManager: HouseSearchManager?

    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
    
    var body: some View {
        HStack() {
            Spacer()
            // Cancel Button (<- HomeScreen)
            Button(action: {
                goBackToHome = true
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
                    .bold()
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 25.0)
                    .padding(.vertical, 10)
                    .background(.red)
                    .cornerRadius(70)
                    .padding(5)
            })
            
            Spacer()
            // Headline Text for View
            Text("Add Home")
                .font(.headline)
                .bold()
                .foregroundColor(olive)
            
            Spacer()
            // Done Button (saves house object, <- HomeScreen)
            Button(action: {
                print("Name: \(currName), Frequency: \(currFrequncy), Address: \(currAddress), Job Description: \(currJobD)")
                if (currName.isEmpty || currFrequncy.isEmpty || currAddress.isEmpty || currJobD.isEmpty) {
                    showFieldAlert = true
                } else if (houseSearchManager?.alreadyExists(currAddress) ?? false) {
                    showMatchAlert = true
                } else {
                    // Proceed with form submission
                    goBackToHome = true
                    // Makes sure that the selected frequency days are in order of earliest to latest in the week
                    let dayOrderMap = Dictionary(uniqueKeysWithValues: daysOfWeek.enumerated().map { ($1, $0) })
                    let filteredUnsortedDays = currFrequncy.filter { dayOrderMap.keys.contains($0) }
                    let sortedDays = filteredUnsortedDays.sorted {
                        guard let index1 = dayOrderMap[$0], let index2 = dayOrderMap[$1] else {
                            return false
                        }
                        return index1 < index2
                    }
                    // Creates house object and saves in context
                    let house = House(currName, currAddress, currJobD, sortedDays.formatted(), selectedPhotoData)
                    context.insert(house)
                    presentationMode.wrappedValue.dismiss()
                }
            }, label: {
                Text("Done")
                    .bold()
                    .font(.headline)
                    .foregroundColor(olive)
                    .padding(.horizontal, 25.0)
                    .padding(.vertical, 10)
                    .background(Color(red: 117/255, green: 143/255, blue: 100/255))
                    .cornerRadius(70)
                    .padding(5)
            })
            Spacer()
            // Only appears when there is an existing house with the same name
            .alert(isPresented: $showMatchAlert) {
                Alert(title: Text("Validation Error"), message: Text("A House with this address already exists"), dismissButton: .default(Text("Ok")))
            }
        }.padding(.top, 20)
        
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                // VStack with image picker and delete button
                // Image Picker
                VStack(spacing: 10){
                    PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        if let selectedPhotoData,
                           let uiImage = UIImage(data: selectedPhotoData) {
                            withAnimation {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .cornerRadius(40)
                                    .aspectRatio(contentMode: .fit)
                                    .padding(0)
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
                    .padding([.horizontal], 10)
                    
                    // Delete Picture Button
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
                }
                
                // VStack with fill in items
                VStack(spacing: 20){
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
                }
                .font(.headline)

                
                // VStack with days of the week frequency
                VStack(spacing: 10){
                    Text("Frequency:")
                        .font(.title2)
                        .bold()
                    // The following buttons allow for frequency selection (refer to Helper)
                    HStack {
                        Spacer()
                        DayButton(currFrequency: $currFrequncy, buttonColor: .gray, day: "Monday")
                        Spacer()
                        DayButton(currFrequency: $currFrequncy, buttonColor: .gray, day: "Tuesday")
                        Spacer()
                        DayButton(currFrequency: $currFrequncy, buttonColor: .gray, day: "Wednesday")
                        Spacer()
                    }
                    .font(.headline)

                    HStack {
                        Spacer()
                        DayButton(currFrequency: $currFrequncy, buttonColor: .gray, day: "Thursday")
                        Spacer()
                        DayButton(currFrequency: $currFrequncy, buttonColor: .gray, day: "Friday")
                        Spacer()
                    }
                    .font(.headline)
                }

            }
            // Updates the variable storing the selected image data
            .task(id: selectedPhoto) {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    selectedPhotoData = data
                }
            }
            .alert(isPresented: $showFieldAlert) {
                Alert(title: Text("Validation Error"), message: Text("All text fields must be filled"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

