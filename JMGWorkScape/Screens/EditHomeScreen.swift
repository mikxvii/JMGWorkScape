//
//  EditHomeScreen.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero on 7/27/24.
//

import Foundation
import SwiftUI
import PhotosUI

/// A view that allows users to edit details of an existing house in the JMGWorkScape app.
/// This view includes text fields for editing the name, address, job description, and service frequency,
/// as well as the ability to upload or remove a photo associated with the house.
struct EditHomeScreen: View {
    // Environment context used to interact with the model data.
    @Environment(\.modelContext) private var context
    
    // Environment variable for managing the view's presentation mode (e.g., dismissing the view).
    @Environment(\.presentationMode) var presentationMode
    
    // The dictionary of all houses passed from the parent view, allowing updates and deletions.
    @State var houseSearchManager: HouseSearchManager?
    
    // The house object being edited.
    var house: House
    
    // A state variable for a temporary dictionary used during the editing process.
    
    // State variables to hold the current values of the house's properties for editing.
    @State var currName: String = ""
    @State var currAddress: String = ""
    @State var currFrequncy = Set<String>() // The frequency of services, initialized as an empty set to avoid errors.
    @State var currJobD: String = ""
    
    // State variables for managing the display of alerts.
    @State private var showFieldAlert: Bool = false
    @State private var showMatchAlert: Bool = false
    
    // State variable to trigger navigation back to the details view after saving or canceling edits.
    @State var goBackToDetails: Bool = false
    
    // State variables to handle photo selection and display.
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?

    // Constants representing the days of the week and a custom color used in the UI.
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    let olive = Color(red: 0.23, green: 0.28, blue: 0.20, opacity: 1.00)
    
    var body: some View {
        // A horizontal stack for the top bar, containing Cancel and Done buttons and the title "Edit Home".
        HStack {
            Spacer()
            
            // Cancel button dismisses the view without saving changes.
            Button(action: {
                goBackToDetails = true
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
            
            // The title of the screen, styled with a custom color and bold font.
            Text("Edit Home")
                .font(.headline)
                .bold()
                .foregroundColor(olive)
            
            // Done button saves the changes to the house if all fields are valid, otherwise shows appropriate alerts.
            Button(action: {
                print("Name: \(currName), Frequency: \(currFrequncy), Address: \(currAddress), Job Description: \(currJobD)")
                if (currName.isEmpty || currFrequncy.isEmpty || currAddress.isEmpty || currJobD.isEmpty) {
                    showFieldAlert = true
                } else if (houseSearchManager?.alreadyExists(addressKeyFormat(currAddress)) ?? false) {
                    showMatchAlert = true
                } else {
                    // Save the changes and update the house's properties.
                    goBackToDetails = true
                    let dayOrderMap = Dictionary(uniqueKeysWithValues: daysOfWeek.enumerated().map { ($1, $0) })
                    let filteredUnsortedDays = currFrequncy.filter { dayOrderMap.keys.contains($0) }
                    let sortedDays = filteredUnsortedDays.sorted {
                        guard let index1 = dayOrderMap[$0], let index2 = dayOrderMap[$1] else {
                            return false
                        }
                        return index1 < index2
                    }
                    house.update(currName, currAddress, currJobD, sortedDays.formatted(), selectedPhotoData)
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
            // Alert shown when the user tries to save a house with a duplicate address.
            .alert(isPresented: $showMatchAlert) {
                Alert(title: Text("Validation Error"), message: Text("A House with this address already exists"), dismissButton: .default(Text("Ok")))
            }
            
            Spacer()
        }
        
        // ScrollView containing the main form fields for editing the house details.
        ScrollView(.vertical) {
            VStack(spacing: 30) {
                // PhotosPicker allows the user to select or remove a photo for the house.
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
                
                // Button to delete the selected photo if one is chosen.
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
                
                // Text field for entering or editing the customer's name.
                TextField("Customer Name", text: $currName)
                    .frame(maxWidth: 350, alignment: .topLeading)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Text field for entering or editing the address of the house.
                TextField("Address", text: $currAddress)
                    .frame(maxWidth: 350, alignment: .topLeading)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Text field for entering or editing the job description for the house.
                TextField("Job Description", text: $currJobD)
                    .frame(maxWidth: 350, alignment: .topLeading)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Label and buttons for selecting the service frequency (days of the week).
                Text("Frequency:")
                    .font(.title2)
                    .bold()
                
                // Horizontal stack for day buttons representing Monday, Tuesday, and Wednesday.
                HStack {
                    Spacer()
                    let monday: Color = house.getFrqSet().contains("Monday") ? .cyan : .gray
                    DayButton(currFrequency: $currFrequncy, buttonColor: monday, day: "Monday")
                    Spacer()
                    let tuesday: Color = house.getFrqSet().contains("Tuesday") ? .cyan : .gray
                    DayButton(currFrequency: $currFrequncy, buttonColor: tuesday, day: "Tuesday")
                    Spacer()
                    let wednesday: Color = house.getFrqSet().contains("Wednesday") ? .cyan : .gray
                    DayButton(currFrequency: $currFrequncy, buttonColor: wednesday, day: "Wednesday")
                    Spacer()
                }
                
                // Horizontal stack for day buttons representing Thursday and Friday.
                HStack {
                    Spacer()
                    let thursday: Color = house.getFrqSet().contains("Thursday") ? .cyan : .gray
                    DayButton(currFrequency: $currFrequncy, buttonColor: thursday, day: "Thursday")
                    Spacer()
                    let friday: Color = house.getFrqSet().contains("Friday") ? .cyan : .gray
                    DayButton(currFrequency: $currFrequncy, buttonColor: friday, day: "Friday")
                    Spacer()
                }
            }
            // Task that loads the selected photo data when the view appears.
            .task(id: selectedPhoto) {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    selectedPhotoData = data
                }
            }
            // Alert shown when the user tries to save the form with empty required fields.
            .alert(isPresented: $showFieldAlert) {
                Alert(title: Text("Validation Error"), message: Text("All text fields must be filled"), dismissButton: .default(Text("OK")))
            }
        }
        // Populates the state variables with the house's current details when the view appears.
        .onAppear {
            currName = house.getName()
            currAddress = house.getAddress()
            currFrequncy = house.getFrqSet()
            currJobD = house.getJobD()
            selectedPhotoData = house.getImg()
            houseSearchManager?.remove(house)
        }
    }
}
