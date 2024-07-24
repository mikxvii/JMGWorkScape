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
final class House: Identifiable {
    var id: String
    
    var name: String
    var address: String
    var frequency: String
    var jobD: String
    var imageData: Data? // Image needs to be in Data format
    
    init(_ name: String="", _ address: String="", _ job: String="", _ frequency: String="", _ imageData: Data? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.address = address
        self.frequency = frequency
        self.jobD = job
        self.imageData = imageData
    }
    
}
