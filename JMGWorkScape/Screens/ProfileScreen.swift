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
            VStack {
                HStack {
                    Text("Name of Company:\n")
                    
                    TextField("Enter Company", text: $companyText)
                        .focused($isFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer() // Pushes the button to the right side
                                Button("Done") {
                                    isFocused = false
                                }
                            }
                        }
                        
                }
                .padding(.bottom, 20)
                .padding(.top, 30)
                .padding(.horizontal, 20)
                Group {
                    HStack {
                        Text("Name of Contractor:\n")
                        TextField("Enter Name", text: $nameText)
                            .focused($isFocused)

                    }
                    HStack {
                        Text("Billing Address:\n")
                        TextField("Enter Address", text: $addressText)
                            .focused($isFocused)

                    }
                    HStack {
                        Text("License #:\n")
                        TextField("Enter Number", text: $licenseText)
                            .focused($isFocused)

                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 20)

                Spacer()
            }
            .navigationTitle("Contractor Profile")
        }
        .onTapGesture {
            isFocused = false
        }
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
        }
    }
}
