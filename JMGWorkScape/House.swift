//
//  House.swift
//  JMGWorkScape
//
//  Created by Christopher Rebollar on 7/18/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class House: Identifiable{
    
    var id: String
    private var name: String
    private var address: String
    private var frequency: String
    private var jobD: String
    private var imageData: Data? // Image needs to be in Data format
    
    init(_ name: String="", _ address: String="", _ job: String="", _ frequency: String="", _ imageData: Data? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.address = address
        self.frequency = frequency
        self.jobD = job
        self.imageData = imageData
    }
    
    func update(_ name: String="", _ address: String="", _ job: String="", _ frequency: String="", _ imageData: Data? = nil) {
        self.name = name
        self.address = address
        self.frequency = frequency
        self.jobD = job
        self.imageData = imageData
    }
    
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
    
    func getImg() -> Data? {
        return self.imageData
    }
    func toggleSelect() -> String {
        return "circlebadge.fill"
    }
    func toggleUnselect() -> String {
        return "circlebadge"
    }
}
