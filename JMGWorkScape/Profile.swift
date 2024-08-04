//
//  Profile.swift
//  JMGWorkScape
//
//  Created by Michael Guerrero on 8/4/24.
//

import Foundation
import SwiftUI
import Combine

// Define the Profile struct
struct Profile: Codable {
    var companyName: String
    var contractorName: String
    var billingAddress: String
    var licenseNumber: String
}
// Define the ObservableObject class
class ProfileManager: ObservableObject {
    @Published var profile: Profile {
        didSet {
            saveProfile()
        }
    }
    
    private let profileKey = "savedProfile"

    init() {
        self.profile = Profile(companyName: "", contractorName: "", billingAddress: "", licenseNumber: "")
        loadProfile()
    }
    
    func updateProfile(companyName: String, contractorName: String, billingAddress: String, licenseNumber: String) {
        self.profile = Profile(companyName: companyName, contractorName: contractorName, billingAddress: billingAddress, licenseNumber: licenseNumber)
    }
    
    private func saveProfile() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }
    
    private func loadProfile() {
        if let savedProfileData = UserDefaults.standard.object(forKey: profileKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedProfile = try? decoder.decode(Profile.self, from: savedProfileData) {
                DispatchQueue.main.async {
                    self.profile = loadedProfile
                }
            }
        }
    }
}
