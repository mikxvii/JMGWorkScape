import Foundation
import SwiftData
import SwiftUI

/// The `House` class represents a house with various attributes like name, address, frequency of jobs, job description, and an optional image.
/// It is used as a data model within the JMGWorkScape application.
@Model
final class House: Identifiable {

    //
    // Class Attributes
    //
    
    var id: String
    private var name: String
    private var address: String
    private var frequency: String
    private var jobD: String
    private var imageData: Data?

    /// Initializes a new `House` object with the provided parameters.
    ///
    /// - Parameters:
    ///   - name: The name of the customer associated with the house. Default is an empty string.
    ///   - address: The address of the house. Default is an empty string.
    ///   - job: The description of the job to be performed at the house. Default is an empty string.
    ///   - frequency: The frequency of the job, represented as a comma-separated string. Default is an empty string.
    ///   - imageData: Optional image data associated with the house. Default is `nil`.
    init(_ name: String = "", _ address: String = "", _ job: String = "", _ frequency: String = "", _ imageData: Data? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.address = address
        self.frequency = frequency
        self.jobD = job
        self.imageData = imageData
    }

    /// Updates the house's attributes with new values.
    ///
    /// This method is used exclusively in the `EditHomeScreen` to update the house's details.
    ///
    /// - Parameters:
    ///   - name: The new name of the customer associated with the house. Default is an empty string.
    ///   - address: The new address of the house. Default is an empty string.
    ///   - job: The new job description to be performed at the house. Default is an empty string.
    ///   - frequency: The new frequency of the job, represented as a comma-separated string. Default is an empty string.
    ///   - imageData: The new image data associated with the house. Default is `nil`.
    func update(_ name: String = "", _ address: String = "", _ job: String = "", _ frequency: String = "", _ imageData: Data? = nil) {
        self.name = name
        self.address = address
        self.frequency = frequency
        self.jobD = job
        self.imageData = imageData
    }

    /// Returns the name of the customer associated with the house.
    ///
    /// - Returns: A `String` representing the customer's name.
    func getName() -> String {
        return self.name
    }

    /// Returns the address of the house.
    ///
    /// - Returns: A `String` representing the house's address.
    func getAddress() -> String {
        return self.address
    }

    /// Returns a formatted version of the house's address that can be used as a unique key.
    ///
    /// The address is converted to lowercase, and non-alphanumeric characters are removed.
    ///
    /// - Returns: A `String` representing the formatted address.
    func getAddressKeyFormat() -> String {
        let modifiedAddress = self.address
            .lowercased() // Convert to lowercase
            .filter { $0.isLetter || $0.isNumber } // Keep only letters and numbers
        return modifiedAddress
    }

    /// Returns the job description associated with the house.
    ///
    /// - Returns: A `String` representing the job description.
    func getJobD() -> String {
        return self.jobD
    }

    /// Returns the frequency of the job as a set of strings, representing the days of the week.
    ///
    /// The frequency string is split by commas and "and", and any invalid days are removed.
    ///
    /// - Returns: A `Set<String>` representing the valid days of the week for the job.
    func getFrqSet() -> Set<String> {
        var components = self.frequency.components(separatedBy: ",")
        // Handle "and" separately, splitting components further
        components = components.flatMap { $0.components(separatedBy: "and") }
        // Trim whitespace and filter out invalid days
        let trimmedDays = components.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        return Set(trimmedDays)
    }

    /// Returns the frequency string as it was originally formatted.
    ///
    /// - Returns: A `String` representing the original frequency.
    func getFrqFormatted() -> String {
        return self.frequency
    }

    /// Returns the image data associated with the house, if available.
    ///
    /// - Returns: An optional `Data` object containing the image data.
    func getImg() -> Data? {
        return self.imageData
    }

    /// Updates the address of the house.
    ///
    /// - Parameter newAddress: The new address to be set for the house.
    func update(_ newAddress: String) {
        self.address = newAddress
    }
}
