import Foundation
import SwiftUI
import Combine

/// `Profile` structure defines the contractor's business details.
/// This struct is used in multiple screens:
/// - `ProfileScreen`: For editing and updating profile details.
/// - `InvoiceScreen`: For retrieving and displaying profile information.
struct Profile: Codable {
    var companyName: String        // The name of the contractor's company
    var contractorName: String     // The name of the contractor
    var billingAddress: String     // The billing address of the contractor/company
    var licenseNumber: String      // Contractor's professional license number
}

/// `ProfileManager` class manages the `Profile` data and ensures persistence.
/// It observes changes to the profile and updates the stored data accordingly.
class ProfileManager: ObservableObject {
    /// The current `Profile` instance. Whenever it is updated, the profile is saved automatically.
    @Published var profile: Profile {
        didSet {
            saveProfile()
        }
    }
    
    // Key for storing profile data in UserDefaults
    private let profileKey = "savedProfile"

    /// Initializes a new `ProfileManager` instance.
    /// If saved profile data exists in `UserDefaults`, it loads that data into the `profile`.
    init() {
        self.profile = Profile(companyName: "", contractorName: "", billingAddress: "", licenseNumber: "")
        loadProfile()
    }
    
    /// Updates the `Profile` with new values and triggers a save to persist the changes.
    /// - Parameters:
    ///   - companyName: Updated company name
    ///   - contractorName: Updated contractor name
    ///   - billingAddress: Updated billing address
    ///   - licenseNumber: Updated license number
    func updateProfile(companyName: String, contractorName: String, billingAddress: String, licenseNumber: String) {
        self.profile = Profile(companyName: companyName, contractorName: contractorName, billingAddress: billingAddress, licenseNumber: licenseNumber)
    }
    
    /// Saves the current `Profile` to `UserDefaults` as encoded JSON.
    private func saveProfile() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }
    
    /// Loads the `Profile` from `UserDefaults` if available, and updates the current `profile`.
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
