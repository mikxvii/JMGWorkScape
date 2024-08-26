//
//  House.swift
//  JMGWorkScape
//
//  Created by Christopher Rebollar on 7/18/24.
//

import Foundation
import SwiftData
import SwiftUI

//// Data Model
//@Model
final class House {
    
    //
    // Class Attributes
    //
    
    var id: String
    private var name: String
    private var address: String
    private var frequency: String
    private var jobD: String
    private var imageData: Data?
    
    
    // _ imageData: Data? = nil code for image
    // Initialize
    init(_ name: String="", _ address: String="", _ job: String="", _ frequency: String="") {
        self.id = UUID().uuidString
        self.name = name
        self.address = address
        self.frequency = frequency
        self.jobD = job
//        self.imageData = imageData
    }
    // _ imageData: Data? = nil
    // Exclusively used in EditHomeScreen
    func update(_ name: String="", _ address: String="", _ job: String="", _ frequency: String="") {
        self.name = name
        self.address = address
        self.frequency = frequency
        self.jobD = job
//        self.imageData = imageData
    }
    
    //
    // Class Methods
    //
    
    func getName() -> String {
        return self.name
    }
    
    func getAddress() -> String {
        return self.address
    }
    
    func getJobD() -> String {
        return self.jobD
    }
    
    func getFrqSet() -> Set<String> {
        var components = self.frequency.components(separatedBy: ",")
        // Handle "and" separately, splitting components further
        components = components.flatMap { $0.components(separatedBy: "and") }
        // Trim whitespace and filter out invalid days
        let trimmedDays = components.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        return Set(trimmedDays)
    }
    
    func getFrqFormatted() -> String {
        return self.frequency
    }
    
//    func getImg() -> Data? {
//        return self.imageData
//    }
}
