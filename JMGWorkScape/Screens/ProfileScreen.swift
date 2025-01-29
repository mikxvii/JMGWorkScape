import Foundation
import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var profileManager: ProfileManager
    @Environment(\.presentationMode) var presentationMode

    @State private var companyText: String = ""
    @State private var nameText: String = ""
    @State private var addressText: String = ""
    @State private var licenseText: String = ""
    
    @FocusState private var isFocused: Bool


    var body: some View {
        Form {
            Section(header: Text("Name of Company")) {
                TextField("Enter Company", text: $companyText)
                    .focused($isFocused)
                    .onTapGesture {
                        isFocused.toggle()
                    }
                // For some reason, it is bugging out when the keyboard pops up
            }
            
            Section(header: Text("Name of contractor")) {
                TextField("Enter Name", text: $nameText)
                    .onTapGesture {
                        isFocused.toggle()
                    }
                    .focused($isFocused)

            }
            
         
            Section(header: Text("Billing Address")) {
                TextField("Enter Address", text: $addressText)
                    .onTapGesture {
                        isFocused.toggle()
                    }
                    .focused($isFocused)
            }
            
            Section(header: Text("License #")) {
                SecureField("Enter Number", text: $licenseText)
                    .onTapGesture {
                        isFocused.toggle()
                    }
                    .focused($isFocused)

            }
            
        }
        .navigationBarTitle("Contractor Profile")
        .onAppear {
            // Initialize with existing profile data if needed
            companyText = profileManager.profile.companyName
            nameText = profileManager.profile.contractorName
            addressText = profileManager.profile.billingAddress
            licenseText = profileManager.profile.licenseNumber
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    profileManager.updateProfile(companyName: companyText, contractorName: nameText, billingAddress: addressText, licenseNumber: licenseText)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                })
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer() // Pushes the button to the right side
                Button("Done") {
                    isFocused = false
                }
            }
        }
    }
}
