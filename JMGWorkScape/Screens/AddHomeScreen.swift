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
    @Environment(\.presentationMode) var presentationMode
    var housesDic: [String: House]

    @State var currName:String = ""
    @State var currAddress:String = ""
    @State var currFrequncy = Set<String>() //default value to not get error for having "" as default
    @State var currJobD:String = ""
    @State private var showFieldAlert: Bool = false
    @State private var showMatchAlert: Bool = false
    
    @State private var monButtonColor: Color = .gray
    @State private var tuesButtonColor: Color = .gray
    @State private var wedButtonColor: Color = .gray
    @State private var thursButtonColor: Color = .gray
    @State private var friButtonColor: Color = .gray

    @State var goBackToHome: Bool = false
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?

    
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
    
    var body: some View {
        // bool variable changed by Cancel and Done buttons
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 30) {
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
                    .padding()
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
                    Text("Frequency:")
                        .font(.title2)
                        .bold()
                    HStack {
                        Spacer()
                        DayButton(currFrequency: $currFrequncy, buttonColor: .gray, day: "Monday")
                        Spacer()
                        DayButton(currFrequency: $currFrequncy, buttonColor: .gray, day: "Tuesday")
                        Spacer()
                        DayButton(currFrequency: $currFrequncy, buttonColor: .gray, day: "Wednesday")
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        DayButton(currFrequency: $currFrequncy, buttonColor: .gray, day: "Thursday")
                        Spacer()
                        DayButton(currFrequency: $currFrequncy, buttonColor: .gray, day: "Friday")
                        Spacer()
                    }
                    
                    
                }
                .task(id: selectedPhoto) {
                    if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                        selectedPhotoData = data
                    }
                }
                .alert(isPresented: $showFieldAlert) {
                    Alert(title: Text("Validation Error"), message: Text("All text fields must be filled"), dismissButton: .default(Text("OK")))
                }
                .navigationBarBackButtonHidden(true) // Hide default back button
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: {
                            goBackToHome = true
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
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {
                            print("Name: \(currName), Frequency: \(currFrequncy), Address: \(currAddress), Job Description: \(currJobD)")
                            if (currName.isEmpty || currFrequncy.isEmpty || currAddress.isEmpty || currJobD.isEmpty) {
                                showFieldAlert = true
                            } else if (housesDic[currName] != nil) {
                                showMatchAlert = true
                            } else {
                                // Proceed with form submission
                                goBackToHome = true
                                let dayOrderMap = Dictionary(uniqueKeysWithValues: daysOfWeek.enumerated().map { ($1, $0) })
                                let filteredUnsortedDays = currFrequncy.filter { dayOrderMap.keys.contains($0) }
                                let sortedDays = filteredUnsortedDays.sorted {
                                    guard let index1 = dayOrderMap[$0], let index2 = dayOrderMap[$1] else {
                                        return false
                                    }
                                    return index1 < index2
                                }
                                let house = House(currName, currAddress, currJobD, sortedDays.formatted(), selectedPhotoData)
                                context.insert(house)
                                presentationMode.wrappedValue.dismiss()
                            }
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
                        .alert(isPresented: $showMatchAlert) {
                            Alert(title: Text("Validation Error"), message: Text("A House with this name already exists, please rename"), dismissButton: .default(Text("Ok")))
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("Add Home")
                                .font(.headline)
                                .bold()
                                .foregroundColor(olive)
                        }
                    }
                }
            }
        }
    }
}

